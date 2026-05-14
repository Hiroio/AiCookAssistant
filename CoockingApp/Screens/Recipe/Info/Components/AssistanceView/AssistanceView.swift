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
			 Image("assist")
				.resizable()
				.scaledToFit()
				.padding()
			 
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
					.submitLabel(.send)
					.onSubmit {
					  vm.sendChatMessage()
					}
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
