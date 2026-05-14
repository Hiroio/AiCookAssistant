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
  @Published var showingSheet: Bool = false
	 @Published private(set) var hasFullAccess: Bool = false
	 @Published private(set) var products: [Product] = []
	 
	 private var updateListenerTask: Task<Void, Error>?

	  private init() {
		  updateListenerTask = listenForTransactions()
		  
		  Task {
				await fetchProducts()
				await updateSubscriptionStatus()
		  }
	 }

	 // Getting products from App Store
	 func fetchProducts() async {
		  do {
				let ids = ["delinote.premium.month", "delinote.premium.three_months", "delinote.premium.annual"]
				self.products = try await Product.products(for: ids)
		  } catch {
				print("Помилка завантаження продуктів: \(error)")
		  }
	 }

	 // Purchase
	 func purchase(_ product: Product) async throws {
		  let result = try await product.purchase()
		  
		  switch result {
		  case .success(let verification):
				// StoreKit 2 автоматично валідує підпис транзакції
				let transaction = try checkVerified(verification)
				await updateSubscriptionStatus()
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
		await updateSubscriptionStatus()
	 } catch {
		print("Помилка відновлення покупок: \(error)")
	 }
  }

	 // Checking for subscriptions
	 func updateSubscriptionStatus() async {
		  for await result in Transaction.currentEntitlements {
			 if (try? checkVerified(result)) != nil {
					 // Перевіряємо, чи це підписка і чи вона не закінчилася
					 self.hasFullAccess = true
					 return
				}
		  }
		  self.hasFullAccess = false
	 }

	 func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
		  switch result {
		  case .unverified: throw StoreError.failedVerification
		  case .verified(let safe): return safe
		  }
	 }
	 
		 private func listenForTransactions() -> Task<Void, Error> {
			  Task {
				 for await _ in Transaction.updates {
						 await self.updateSubscriptionStatus()
					}
		  }
	 }
}

enum StoreError: Error {
	 case failedVerification
}
