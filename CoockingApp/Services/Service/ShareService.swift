//
//  ShareService.swift
//  CoockingApp
//
//  Created by Codex on 11.05.2026.
//

import SwiftUI
import UIKit

@MainActor
final class ShareService {
  static let shared = ShareService()
  
  private init() {}
  
  func makeRecipeShareImage(recipe: UIRecipeModel) async -> UIImage? {
	 let image = await loadRecipeImage(from: recipe.imageUrl)
	 let renderer = ImageRenderer(content: RecipeShareCardView(recipe: recipe, recipeImage: image))
	 renderer.scale = UIScreen.main.scale
	 renderer.proposedSize = ProposedViewSize(width: 1600, height: 1000)
	 
	 return renderer.uiImage
  }
  
  private func loadRecipeImage(from path: String) async -> UIImage? {
	 guard let url = URL(string: path) else { return nil }
	 
	 do {
		let (data, _) = try await URLSession.shared.data(from: url)
		return UIImage(data: data)
	 } catch {
		return nil
	 }
  }
}

private struct RecipeShareCardView: View {
  let recipe: UIRecipeModel
  let recipeImage: UIImage?
  
  var body: some View {
	 HStack(spacing: 28) {
		VStack(spacing: 24) {
		  RecipeShareHeroCard(recipe: recipe, recipeImage: recipeImage)
		  RecipeShareIngredientsCard(recipe: recipe)
		}
		.frame(width: 690)
		
		RecipeShareInstructionsCard(recipe: recipe)
		  .frame(width: 742)
		  .frame(maxHeight: .infinity)
	 }
	 .padding(56)
	 .frame(width: 1600, height: 1000)
	 .background(Color.background)
	 .overlay(alignment: .bottomTrailing) {
		HStack(spacing: 8) {
		  Image("CheffsyLogo")
			 .resizable()
			 .scaledToFit()
			 .frame(width: 26, height: 26)
		  Text("Made with DeliNote")
			 .font(.system(size: 24, weight: .medium, design: .rounded))
			 .foregroundStyle(Color.primaryAction)
		}
		.padding(.trailing, 56)
		.padding(.bottom, 26)
	 }
  }
}

private struct RecipeShareHeroCard: View {
  let recipe: UIRecipeModel
  let recipeImage: UIImage?
  
  var body: some View {
	 ZStack(alignment: .leading) {
		if let recipeImage {
		  Image(uiImage: recipeImage)
			 .resizable()
			 .scaledToFill()
			 .frame(maxWidth: .infinity, maxHeight: .infinity)
			 .clipped()
		} else {
		  Color.secondaryCard
		}
		
		LinearGradient(
		  colors: [Color.background, Color.background.opacity(0.92), Color.background.opacity(0.18)],
		  startPoint: .leading,
		  endPoint: .trailing
		)
		
		VStack(alignment: .leading, spacing: 24) {
		  Text(recipe.name)
			 .font(.system(size: 54, weight: .bold, design: .serif))
			 .foregroundStyle(Color.primarytext)
			 .lineLimit(4)
			 .minimumScaleFactor(0.72)
			 .frame(maxWidth: 440, alignment: .leading)
		  
		  Text(recipe.description)
			 .font(.system(size: 24, weight: .regular, design: .rounded))
			 .foregroundStyle(Color.primarytext.opacity(0.82))
			 .lineLimit(3)
			 .minimumScaleFactor(0.75)
			 .frame(maxWidth: 420, alignment: .leading)
		  
		  VStack(alignment: .leading, spacing: 12) {
			 RecipeShareStat(icon: "clock", text: "\(recipe.time) min")
			 RecipeShareStat(icon: RecipeDifficulty.getDifficulty(recipe.difficulty).icon, text: RecipeDifficulty.getDifficulty(recipe.difficulty).text)
		  }
		  .font(.system(size: 25, weight: .medium, design: .rounded))
		}
		.padding(46)
	 }
	 .frame(height: 420)
	 .clipShape(RoundedRectangle(cornerRadius: 34))
	 .overlay {
		RoundedRectangle(cornerRadius: 34)
		  .stroke(Color.primaryAction.opacity(0.22), lineWidth: 2)
	 }
	 .shadow(color: Color.primarytext.opacity(0.14), radius: 16, y: 8)
  }
}

private struct RecipeShareIngredientsCard: View {
  let recipe: UIRecipeModel
  
  private var visibleIngredients: [String] {
	 Array(recipe.ingredients.prefix(10))
  }
  
  var body: some View {
	 VStack(alignment: .leading, spacing: 22) {
		Text("Ingredients")
		  .font(.system(size: 34, weight: .semibold, design: .rounded))
		  .foregroundStyle(Color.primaryAction)
		
		VStack(spacing: 12) {
		  ForEach(visibleIngredients, id: \.self) { ingredient in
			 let parts = splitIngredient(ingredient)
			 HStack(alignment: .top, spacing: 13) {
				Circle()
				  .fill(Color.primaryAction)
				  .frame(width: 8, height: 8)
				  .padding(.top, 12)
				
				Text(parts.name)
				  .font(.system(size: 22, weight: .regular, design: .rounded))
				  .foregroundStyle(Color.primarytext)
				  .lineLimit(1)
				
				Spacer(minLength: 18)
				
				Text(parts.amount)
				  .font(.system(size: 21, weight: .regular, design: .rounded))
				  .foregroundStyle(Color.primarytext.opacity(0.72))
				  .lineLimit(1)
			 }
		  }
		  
		  if recipe.ingredients.count > visibleIngredients.count {
			 Text("+ \(recipe.ingredients.count - visibleIngredients.count) more")
				.font(.system(size: 20, weight: .medium, design: .rounded))
				.foregroundStyle(Color.primaryAction.opacity(0.75))
				.frame(maxWidth: .infinity, alignment: .leading)
		  }
		}
		
		Divider()
		  .overlay(Color.primaryAction.opacity(0.18))
		
		RecipeShareMacrosText(macros: recipe.macros)
	 }
	 .padding(34)
	 .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
	 .background(
		RoundedRectangle(cornerRadius: 34)
		  .fill(Color.secondaryCard.opacity(0.88))
	 )
  }
  
  private func splitIngredient(_ ingredient: String) -> (name: String, amount: String) {
	 let parts = ingredient.components(separatedBy: "-").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
	 return (parts.first ?? ingredient, parts.dropFirst().joined(separator: " - "))
  }
}

private struct RecipeShareInstructionsCard: View {
  let recipe: UIRecipeModel
  
  private var visibleInstructions: [String] {
	 Array(recipe.instructions.prefix(8))
  }
  
  var body: some View {
	 VStack(alignment: .leading, spacing: 28) {
		Text("Instructions")
		  .font(.system(size: 40, weight: .bold, design: .serif))
		  .foregroundStyle(Color.primarytext)
		
		VStack(spacing: 20) {
		  ForEach(Array(visibleInstructions.enumerated()), id: \.offset) { index, instruction in
			 let step = RecipeShareInstructionStep(instruction)
			 
			 HStack(alignment: .top, spacing: 18) {
				Text("\(index + 1)")
				  .font(.system(size: 22, weight: .bold, design: .rounded))
				  .foregroundStyle(Color.background)
				  .frame(width: 42, height: 42)
				  .background(Circle().fill(Color.primaryAction))
				
				VStack(alignment: .leading, spacing: 5) {
				  Text(step.action.capitalized)
					 .font(.system(size: 18, weight: .semibold, design: .rounded))
					 .foregroundStyle(Color.primaryAction)
				  Text(step.text)
					 .font(.system(size: 24, weight: .regular, design: .rounded))
					 .foregroundStyle(Color.primarytext.opacity(0.86))
					 .lineLimit(2)
					 .minimumScaleFactor(0.8)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			 }
		  }
		  
		  if recipe.instructions.count > visibleInstructions.count {
			 Text("+ \(recipe.instructions.count - visibleInstructions.count) more steps")
				.font(.system(size: 22, weight: .medium, design: .rounded))
				.foregroundStyle(Color.primaryAction.opacity(0.7))
				.frame(maxWidth: .infinity, alignment: .leading)
		  }
		}
		
		Spacer(minLength: 0)
		
		if !recipe.cookingTip.isEmpty {
		  HStack(spacing: 16) {
			 Image("chefsHat")
				.resizable()
				.scaledToFit()
				.frame(width: 54, height: 54)
			 
			 VStack(alignment: .leading, spacing: 4) {
				Text("Chef's Tip")
				  .font(.system(size: 24, weight: .semibold, design: .rounded))
				  .foregroundStyle(Color.primaryAction)
				Text(recipe.cookingTip)
				  .font(.system(size: 21, weight: .regular, design: .rounded))
				  .foregroundStyle(Color.primarytext.opacity(0.78))
				  .lineLimit(2)
			 }
		  }
		  .padding(22)
		  .background(
			 RoundedRectangle(cornerRadius: 28)
				.fill(Color.rareCard.opacity(0.42))
		  )
		}
	 }
	 .padding(38)
	 .background(
		RoundedRectangle(cornerRadius: 34)
		  .fill(Color.background)
		  .shadow(color: Color.primarytext.opacity(0.12), radius: 18, y: 8)
	 )
	 .overlay {
		RoundedRectangle(cornerRadius: 34)
		  .stroke(Color.primaryAction.opacity(0.16), lineWidth: 2)
	 }
  }
}

private struct RecipeShareStat: View {
  let icon: String
  let text: String
  
  var body: some View {
	 HStack(spacing: 12) {
		Image(systemName: icon)
		  .frame(width: 30)
		Text(text)
	 }
	 .foregroundStyle(Color.primarytext)
  }
}

private struct RecipeShareMacrosText: View {
  let macros: String
  
  var body: some View {
	 let values = macros.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
	 
	 if values.count >= 4 {
		Text("~\(values[0]) kcal  •  P \(values[1])g  •  F \(values[2])g  •  C \(values[3])g")
		  .font(.system(size: 20, weight: .regular, design: .rounded))
		  .foregroundStyle(Color.primarytext.opacity(0.62))
	 } else {
		EmptyView()
	 }
  }
}

private struct RecipeShareInstructionStep {
  let action: String
  let text: String
  
  init(_ instruction: String) {
	 let parts = instruction.components(separatedBy: "-").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
	 self.action = parts.first ?? "Step"
	 self.text = parts.dropFirst().joined(separator: " - ").isEmpty ? instruction : parts.dropFirst().joined(separator: " - ")
  }
}
