//
//  CreationViewModel.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CreationViewModel: ObservableObject {
  @Published var recipe: RecipeModel? = nil
  @Published var userIngredients: [String] = []
  @Published var selectedTime: String = "< 20"
  @Published var difficulty: Int = 2
  @Published var userNote: String = ""
  @Published var error: CreationError? = nil
  @Published var user: UserModel

  private let apiManager = GeminiAPI()
  private let pexelsManager = PexelsAPI()
  private let storeManager = StoreManager.shared
  private let userManager = UserManager.shared
  private var cancellables = Set<AnyCancellable>()

  init(ingredients: [String]) {
    let entity = CoreDataManager.shared.fetchUser()
    self.user = UserModel(entity: entity)
    self.userIngredients = ingredients
    observeAccessChanges()
  }

  var creationsRemainingText: String? {
    AccessPolicy.remainingLabel(for: .recipeCreation, isPremium: storeManager.hasFullAccess)
  }

  var scansRemainingText: String? {
    AccessPolicy.remainingLabel(for: .photoScan, isPremium: storeManager.hasFullAccess)
  }

  var isPhotoScanAvailable: Bool {
    AccessPolicy.canUse(.photoScan, isPremium: storeManager.hasFullAccess)
  }

  var loading: LoadingScreenType? {
    get {
      NavigationManager.shared.loadingScreen
    }
    set {
      NavigationManager.shared.loadingScreen = newValue
    }
  }

  private func observeAccessChanges() {
    storeManager.objectWillChange
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.objectWillChange.send()
      }
      .store(in: &cancellables)

    userManager.objectWillChange
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else { return }
        self.user = self.userManager.user
      }
      .store(in: &cancellables)
  }

  func attemptCreateRecipe() -> Bool {
    let isPremium = storeManager.hasFullAccess

    guard AccessPolicy.canUse(.recipeCreation, isPremium: isPremium) else {
      AccessPolicy.showBlockedPopup(for: .recipeCreation)
      user = UserManager.shared.user
      return false
    }

    user = UserManager.shared.user
    request()
    return true
  }

  func attemptPhotoScan() -> Bool {
    let isPremium = storeManager.hasFullAccess

    guard AccessPolicy.canUse(.photoScan, isPremium: isPremium) else {
      AccessPolicy.showBlockedPopup(for: .photoScan)
      user = UserManager.shared.user
      return false
    }

    user = UserManager.shared.user
    return true
  }

  func request() {
    loading = .recipeCreation
    let isPremium = storeManager.hasFullAccess

    Task {
      defer { loading = nil }

      do {
        let response = try await apiManager.recipeRequest(
          userIngredients: userIngredients,
          userDifficulty: difficulty,
          userTime: selectedTime,
          user: user,
          userNote: userNote
        )
        let image = try await pexelsManager.searchImage(query: response.search)
        var recipe = UIRecipeModel(recipe: response)
        IngredientsManager.shared.chekingNewIngredients(ingreedients: response.ingredients)
        recipe.imageUrl = image ?? ""
        await MainActor.run {
          self.recipe = response
          if AccessPolicy.shouldTrackUsage(for: .recipeCreation, isPremium: isPremium) {
            UserManager.shared.addGenerationUser()
            self.user = UserManager.shared.user
          }

          NavigationManager.shared.secondaryScreens = .info(recipe: recipe, creation: true)
        }
      } catch {
        await MainActor.run {
          NavigationManager.shared.error = CreationError.map(error)
        }
      }
    }
  }

  func analyzePhoto(image: UIImage) {
    let isPremium = storeManager.hasFullAccess

    guard AccessPolicy.canUse(.photoScan, isPremium: isPremium) else {
      AccessPolicy.showBlockedPopup(for: .photoScan)
      user = UserManager.shared.user
      return
    }

    user = UserManager.shared.user
    loading = .photoAnalysis
    Task {
      defer { loading = nil }

      do {
        let products = try await apiManager.analyzePhoto(image: image, userIngredients: userIngredients)
        let array = products.components(separatedBy: " ")
        await MainActor.run {
          let filtered = array.filter({ item in
            !self.userIngredients.contains(where: { $0.lowercased() == item })
          })
          self.userIngredients.insert(contentsOf: filtered, at: 0)
          if AccessPolicy.shouldTrackUsage(for: .photoScan, isPremium: isPremium) {
            UserManager.shared.addCameraUser()
            self.user = UserManager.shared.user
          }
        }
      } catch {
        await MainActor.run {
          NavigationManager.shared.error = CreationError.map(error)
        }
      }
    }
  }

  var ableToCreate: Bool {
    !userIngredients.isEmpty || !userNote.isEmpty
  }
}
