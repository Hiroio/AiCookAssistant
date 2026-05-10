//
//  AssistanceView.swift
//  CoockingApp
//
//  Created by user on 01.05.2026.
//

import SwiftUI

struct AssistanceView: View {
  @EnvironmentObject private var vm: RecipeInfoViewModel
  @State private var text: String = ""
    var body: some View {
		VStack(spacing: 25){
		  if vm.recipe.chatHistory.isEmpty{
			 Spacer()
			 Image(systemName: "sparkles")
				.font(.largeTitle.bold())
				.foregroundStyle(.primaryAction.shadow(.inner(color: .accentCard,radius: 2, x: 3 ,y: 2)))
				.padding()
				.background(
				  Circle()
					 .fill(.accentCard.opacity(0.2))
				)
				.scaleEffect(1.5)
			 
		  VStack(spacing: 15){
			 Text("Need help with this recipe?")
				.font(.title)
				.fontWeight(.medium)
				.foregroundStyle(.primaryAction)
			 Text("Ask our AI assistant anything about ingredients, substitutionsm technique, or tips!")
				.padding(.horizontal, 30)
				.foregroundStyle(.primarytext.opacity(0.6))
				
		  }
		  .shadow(radius: 0.5)
		  .multilineTextAlignment(.center)
		  .padding(.vertical)
		  .fontDesign(.serif)
		  }else{
			 ChatView()
		  }
		  Spacer()
		  HStack{
			 TextField("", text: $vm.chatMessage, prompt: Text("Ask a question.."))
				.padding()
			 
			 Button{
				vm.sendChatMessage()
			 }label: {
				Image(systemName: "paperplane.fill")
				  .foregroundStyle(Color.background)
				  .padding()
				  .background(
					 RoundedRectangle(cornerRadius: 25)
						.fill(.primaryAction)
				  )
			 }
		  }
			 .background(
				RoundedRectangle(cornerRadius: 20)
				  .fill(.white.opacity(0.9))
			 )
		}
		.animation(.bouncy, value: vm.chatMessage)
		.padding()
    }
}

#Preview {
  ZStack{
	 Color.background.ignoresSafeArea()
	 AssistanceView()
  }
  .environmentObject(RecipeInfoViewModel(recipe: .preview))
}
