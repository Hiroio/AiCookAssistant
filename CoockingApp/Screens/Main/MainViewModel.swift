//
//  MainViewModel.swift
//  CoockingApp
//
//  Created by user on 08.05.2026.
//

import Foundation
import Combine

@MainActor
class MainViewModel: ObservableObject {
  @Published var recipes: [UIRecipeModel] = []
  @Published var recomendedLoading: Bool = false
  @Published var recomendedError: CreationError? = .badInternetConnection
  @Published var user: UserModel

  private let recipeManager = RecipesManager.shared
  private let geminiAPI = GeminiAPI()
  private let pexelsManager = PexelsAPI()
  private let userManager = UserManager.shared
  private let storeManager = StoreManager.shared
  private var recipesTask: Task<Void, Never>?
  private var cancellables = Set<AnyCancellable>()

  init() {
    self.user = UserManager.shared.user
    self.recipes = recipeManager.recipes
    observeRecipes()
    observeAccessChanges()
    self.initializeRecomendedRecipe()
  }

  deinit {
    recipesTask?.cancel()
  }

  var ideasRemainingText: String? {
    AccessPolicy.remainingLabel(for: .ideas, isPremium: storeManager.hasFullAccess)
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

  func initializeRecomendedRecipe() {
    if recommendedRecipe == nil && !recomendedLoading {
      recomendedError = nil
      generateRecomendedRecipe()
    }
  }

  private func observeRecipes() {
    let publisher = recipeManager.$recipes
    recipesTask = Task { [weak self] in
      for await recipes in publisher.values {
        await MainActor.run {
          self?.recipes = recipes
          self?.initializeRecomendedRecipe()
        }
      }
    }
  }

  var recommendedRecipe: UIRecipeModel? {
    let recommended = self.recipes.filter({
      $0.recommendedDate?.inToday() ?? false
    })

    return recommended.first(where: { $0.recommendedDate?.inToday() ?? false })
  }

  var latestRecipes: [UIRecipeModel] {
    self.recipes.filter({ !$0.isRecommended }).sorted(by: { $0.dateCreated > $1.dateCreated })
  }
}

extension MainViewModel {
  func generateRecomendedRecipe() {
    let user = UserManager.shared.user
    self.recomendedLoading = true
    Task {
      defer { recomendedLoading = false }
      do {
        let response = try await geminiAPI.recomendedRequest(user: user, recipeList: self.recipes.recipeList)
        let image = try await pexelsManager.searchImage(query: response.search)
        var recipe = UIRecipeModel(recipe: response, isRecommended: true, recomendedDate: Date())
        recipe.imageUrl = image ?? ""
        await MainActor.run {
          let _ = recipeManager.createRecipe(recipe: recipe)
        }
      } catch {
        await MainActor.run {
          print(error.localizedDescription)
          self.recomendedError = CreationError.map(error)
        }
      }
    }
  }

  func generateQuickIdeaRecipe(prompt: String) {
    let isPremium = storeManager.hasFullAccess

    guard AccessPolicy.canUse(.ideas, isPremium: isPremium) else {
      AccessPolicy.showBlockedPopup(for: .ideas)
      user = userManager.user
      return
    }

    user = userManager.user

    NavigationManager.shared.isLoading = true
    Task {
      defer { NavigationManager.shared.isLoading = false }

      do {
        let response = try await geminiAPI.quickIdeaRequest(
          user: user,
          prompt: prompt,
          recipeList: recipes.recipeList
        )
        let image = try await pexelsManager.searchImage(query: response.search)
        var recipe = UIRecipeModel(recipe: response)
        recipe.imageUrl = image ?? ""
        await MainActor.run {
          if AccessPolicy.shouldTrackUsage(for: .ideas, isPremium: isPremium) {
            self.addIdeaCount()
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

  func addIdeaCount() {
    userManager.addIdeaGenerationUser()
    user = userManager.user
  }
}
