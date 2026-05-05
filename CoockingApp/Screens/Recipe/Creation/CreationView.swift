//
//  CreationView.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import SwiftUI

struct CreationView: View {
  @StateObject private var vm = CreationViewModel()
  @State private var showCamera: Bool = false
  @State private var createdImage: UIImage? = nil
  @State private var isNote: Bool = false
  var body: some View {
	 ZStack{
		Color.softIvory.ignoresSafeArea()
		VStack(alignment: .leading, spacing: 15){
		  HStack{
			 Button{
				NavigationManager.shared.secondaryScreens = nil
			 }label:{
				Image(systemName: "chevron.left")
				  .foregroundStyle(.mossGreen)
				  .font(.headline)
				  .padding(10)
				  .background(
					 Circle()
						.fill(.warmBeige.opacity(0.2))
						.shadow(radius: 1)
				  )
			 }
			 Text("Dish Creation")
				.font(.largeTitle)
				.fontWeight(.medium)
				.fontDesign(.serif)
				.foregroundStyle(.mossGreen)
				.frame(maxWidth: .infinity, alignment: .leading)
		  }
		  VStack(alignment: .leading){
			 
			 Text("Time of Cooking")
				.headline()
			 TimeSelection(userTime: $vm.selectedTime)
		  }
		  
		  IngredientsView(selectedIngredient: $vm.userIngredients, showCamera: $showCamera)
		  
	 
		  Spacer()

		  
//		  TODO: USER Note section
		  NoteCard(noteText: $vm.userNote)
		  
				 //			 MARK: Difficulty section
				 VStack(spacing: 2){
					HStack{
					  Text("Difficulty")
					  Spacer()
					  Text("\(vm.difficulty) / 5")
						 .contentTransition(.numericText())
					}
					.headline()
					HStack{
					  ForEach(1..<6){i in
						 let selected = i <= vm.difficulty
						 Button{
							withAnimation(.easeInOut){
							  vm.difficulty = i
							}
						 }label: {
							Image(systemName: "fork.knife.circle.fill")
							  .font(.largeTitle.bold())
							  .foregroundStyle(selected ? .accent : .softIvory)
							  .background(
								Circle()
								  .fill(.black.opacity(0.15))
							  )
						 }
						 .buttonStyle(.plain)
					  }
					}
					.padding(10)
					.frame(maxWidth: .infinity)
					
				 }
		  
//		  MARK: Button creation
		  Button{
			 vm.request()
		  }label: {
			 Text("Create")
				.font(.title3)
				.foregroundStyle(.white)
				.padding()
				.frame(maxWidth: .infinity)
				.background(
				  RoundedRectangle(cornerRadius: 20)
					 .fill(.accent)
				)
		  }
		  .buttonStyle(buttonTapScale())
		  
		}
		.padding()
		
	 }
	 .fullScreenCover(isPresented: $showCamera) {
		CameraView(image: $createdImage)
		  .ignoresSafeArea()
	 }
	 .onChange(of: createdImage) { _, newValue in
		if let createdImage{
		  vm.analyzePhoto(image: createdImage)
		  self.createdImage = nil
		}
	 }
  }
}

#Preview {
  CreationView()
}
