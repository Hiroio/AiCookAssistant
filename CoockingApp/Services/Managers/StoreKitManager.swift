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
		  // Слухаємо оновлення транзакцій у фоні
		  updateListenerTask = listenForTransactions()
		  
		  Task {
				await fetchProducts()
				await updateSubscriptionStatus()
		  }
	 }

	 // Отримуємо продукти з App Store
	 func fetchProducts() async {
		  do {
				// ID твоїх підписок з App Store Connect
				let ids = ["com.cheffsy.monthly", "com.cheffsy.yearly"]
				self.products = try await Product.products(for: ids)
		  } catch {
				print("Помилка завантаження продуктів: \(error)")
		  }
	 }

	 // Купівля
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

	 // Перевірка, чи є активна підписка зараз
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
		  Task.detached {
			 for await _ in Transaction.updates {
					 // Оновлюємо статус, якщо транзакція прийшла ззовні (наприклад, через налаштування iOS)
					 await self.updateSubscriptionStatus()
				}
		  }
	 }
}

enum StoreError: Error {
	 case failedVerification
}
