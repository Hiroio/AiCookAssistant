//
//  AccessPolicy.swift
//  CoockingApp
//

import Foundation

enum PremiumFeature {
  case ideas
  case recipeCreation
  case photoScan
  case aiAssistance

  var usageFeature: UsageFeature? {
    switch self {
    case .ideas:
      return .ideas
    case .recipeCreation:
      return .recipeGeneration
    case .photoScan:
      return .photoScan
    case .aiAssistance:
      return nil
    }
  }
}

enum AccessPolicy {
  private static let ideasWeeklyLimit = 3
  private static let recipeCreationWeeklyLimit = 5
  private static let photoScanWeeklyLimit = 3

  /// Weekly reset runs only when the free tier limit is already exhausted.
  private static func userForAccessCheck(_ feature: PremiumFeature, isPremium: Bool) -> UserModel {
    guard !isPremium else { return UserManager.shared.user }

    let user = UserManager.shared.user
    guard isAtWeeklyLimit(feature, user: user) else { return user }

    UserManager.shared.refreshWeeklyLimitsIfNeeded()
    return UserManager.shared.user
  }

  private static func isAtWeeklyLimit(_ feature: PremiumFeature, user: UserModel) -> Bool {
    switch feature {
    case .ideas:
      return user.freeIdeasUsed >= ideasWeeklyLimit
    case .recipeCreation:
      return user.freeGenerationsUsed >= recipeCreationWeeklyLimit
    case .photoScan:
      return user.freeScanUses >= photoScanWeeklyLimit
    case .aiAssistance:
      return false
    }
  }

  static func canUse(_ feature: PremiumFeature, isPremium: Bool) -> Bool {
    if isPremium { return true }

    let user = userForAccessCheck(feature, isPremium: isPremium)

    switch feature {
    case .aiAssistance:
      return false
    case .ideas:
      return user.freeIdeasUsed < ideasWeeklyLimit
    case .recipeCreation:
      return user.freeGenerationsUsed < recipeCreationWeeklyLimit
    case .photoScan:
      return user.freeScanUses < photoScanWeeklyLimit
    }
  }

  static func blockedPopup(for feature: PremiumFeature) -> NavigationPopup? {
    guard let usageFeature = feature.usageFeature else { return nil }
    return .weeklyLimit(usageFeature)
  }

  /// Call only after `canUse` returned `false` for the same feature.
  static func showBlockedPopup(for feature: PremiumFeature) {
    guard let popup = blockedPopup(for: feature) else { return }
    NavigationManager.shared.popup = popup
  }

  static func remainingLabel(for feature: PremiumFeature, isPremium: Bool) -> String? {
    guard !isPremium else { return nil }

    let user = userForAccessCheck(feature, isPremium: isPremium)

    switch feature {
    case .ideas:
      return "Generation left: \(max(0, ideasWeeklyLimit - user.freeIdeasUsed))"
    case .recipeCreation:
      return "Free creations left: \(max(0, recipeCreationWeeklyLimit - user.freeGenerationsUsed)) "
    case .photoScan:
      return "\(max(0, photoScanWeeklyLimit - user.freeScanUses)) of 3"
    case .aiAssistance:
      return nil
    }
  }

  static func shouldTrackUsage(for feature: PremiumFeature, isPremium: Bool) -> Bool {
    !isPremium && feature != .aiAssistance
  }
}
