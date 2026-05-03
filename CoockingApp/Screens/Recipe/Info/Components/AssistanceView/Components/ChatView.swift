//
//  ChatView.swift
//  CoockingApp
//
//  Created by user on 01.05.2026.
//

import SwiftUI

struct ChatView: View {
  @EnvironmentObject private var vm: RecipeInfoViewModel
  @State private var loadingAnimation: Bool = false
    var body: some View {
		ScrollView{
		  VStack{
			 ForEach(vm.recipe.chatHistory, id: \.parts){message in
				let user = message.role == .user
				Text(message.parts.first?["text"] ?? "")
				  .padding()
				  .background {
					 UnevenRoundedRectangle(cornerRadii: .init(topLeading: 30, bottomLeading: user ? 30 : 5, bottomTrailing: user ? 5 : 30, topTrailing: 30))
						.fill(.herbalGreen.opacity(0.4))
					 
				  }
				  .frame(maxWidth: .infinity, alignment: user ? .trailing : .leading)
				  .padding(user ? .leading : .trailing, 40)
				  .multilineTextAlignment(user ? .trailing : .leading)
			 }
			 
			 if vm.messageIsLoading{
				HStack{
				  RoundedRectangle(cornerRadius: 30)
					 .fill(.herbalGreen.opacity(0.4))
					 .frame(width: loadingAnimation ? 100 : 80, height: 55)
					 .frame(maxWidth: .infinity, alignment: .leading)
					 .onAppear{
						loadingAnimation.toggle()
					 }
				}
				
			 }
		  }
		  .animation(.spring(duration: 1.5).repeatForever(), value: loadingAnimation)
		  .animation(.bouncy, value: vm.recipe.chatHistory.count)
		  .padding()
		  
		}
    }
}

#Preview {
  ChatView()
	 .environmentObject(RecipeInfoViewModel(recipe: UIRecipeModel(name: "", time: 32, difficulty: 3, description: "", ingredients: [], instructions: [], imageUrl: "", chatHistory: [])))
}
