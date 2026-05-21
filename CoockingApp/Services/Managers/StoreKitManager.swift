//
//  StoreKitManager.swift
//  CoockingApp
//
//  Created by user on 05.05.2026.
//

import Foundation
import StoreKit
import Combine

@MainActor
class StoreManager: ObservableObject {
  static let shared = StoreManager()

  static let subscriptionProductIDs: [String] = [
    "delinote.premium.month.com",
    "delinote.premium.three_months.com",
    "delinote.premium.annual.com"
  ]

  private static let subscriptionProductIDSet = Set(subscriptionProductIDs)

  @Published var showingSheet: Bool = false
  @Published private(set) var hasFullAccess: Bool = false
  @Published private(set) var products: [Product] = []

  private var updateListenerTask: Task<Void, Error>?

  private init() {
    updateListenerTask = listenForTransactions()

    Task {
      await fetchProducts()
      await refreshAccess()
    }
  }

  // Getting products from App Store
  func fetchProducts() async {
    do {
      self.products = try await Product.products(for: Self.subscriptionProductIDs)
    } catch {
      print("Помилка завантаження продуктів: \(error)")
    }
  }

  // Purchase
  func purchase(_ product: Product) async throws {
    let result = try await product.purchase()

    switch result {
    case .success(let verification):
      let transaction = try checkVerified(verification)
      await refreshAccess()
      await transaction.finish()
    case .userCancelled, .pending:
      break
    @unknown default:
      break
    }
  }

  func restorePurchases() async {
    do {
      try await AppStore.sync()
      await refreshAccess()
    } catch {
      print("Помилка відновлення покупок: \(error)")
    }
  }

  func refreshAccess() async {
    await updateSubscriptionStatus()
  }

  func updateSubscriptionStatus() async {
    var isActive = false

    for await result in Transaction.currentEntitlements {
      guard let transaction = try? checkVerified(result) else { continue }
      guard Self.subscriptionProductIDSet.contains(transaction.productID) else { continue }
      guard transaction.revocationDate == nil else { continue }

      if let expirationDate = transaction.expirationDate, expirationDate < Date() {
        continue
      }

      isActive = true
      break
    }

    hasFullAccess = isActive
  }

  func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
    switch result {
    case .unverified:
      throw StoreError.failedVerification
    case .verified(let safe):
      return safe
    }
  }

  private func listenForTransactions() -> Task<Void, Error> {
    Task {
      for await result in Transaction.updates {
        guard let transaction = try? checkVerified(result) else { continue }
        await updateSubscriptionStatus()
        await transaction.finish()
      }
    }
  }
}

enum StoreError: Error {
  case failedVerification
}
