//
//  AccessibilityViewModifiers.swift
//  CoockingApp
//
//  Created by Codex on 14.05.2026.
//

import SwiftUI

struct IconButtonAccessibilityModifier: ViewModifier {
  let label: String
  let hint: String?
  
  func body(content: Content) -> some View {
	 content
		.accessibilityLabel(Text(label))
		.accessibilityHint(Text(hint ?? ""))
		.accessibilityAddTraits(.isButton)
  }
}

struct RecipeCardAccessibilityModifier: ViewModifier {
  let recipe: UIRecipeModel
  let action: String
  
  func body(content: Content) -> some View {
	 let difficulty = RecipeDifficulty.getDifficulty(recipe.difficulty).text
	 
	 content
		.accessibilityElement(children: .ignore)
		.accessibilityLabel(Text("\(recipe.name), \(recipe.time) minutes, \(difficulty) difficulty"))
		.accessibilityHint(Text(action))
		.accessibilityAddTraits(.isButton)
  }
}

struct ModalAccessibilityModifier: ViewModifier {
  let label: String
  
  func body(content: Content) -> some View {
	 content
		.accessibilityElement(children: .contain)
		.accessibilityLabel(Text(label))
		.accessibilityAddTraits(.isModal)
  }
}

extension View {
  func iconButtonAccessibility(_ label: String, hint: String? = nil) -> some View {
	 modifier(IconButtonAccessibilityModifier(label: label, hint: hint))
  }
  
  func recipeCardAccessibility(_ recipe: UIRecipeModel, action: String = "Open recipe details") -> some View {
	 modifier(RecipeCardAccessibilityModifier(recipe: recipe, action: action))
  }
  
  func modalAccessibility(_ label: String) -> some View {
	 modifier(ModalAccessibilityModifier(label: label))
  }
}
