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
  @State private var showWarning: Bool = false
  var body: some View {
		ZStack{
		Color.background.ignoresSafeArea()
		  VStack(alignment: .leading, spacing: 15){
		  HStack{
			 Button{
				NavigationManager.shared.secondaryScreens = nil
			 }label:{
				Image(systemName: "chevron.left")
				  .foregroundStyle(Color.primaryAction)
				  .font(.subheadline)
				  .padding(10)
				  .background(
					 Circle()
						.fill(Color.rareCard.opacity(0.1))
						.shadow(radius: 1)
				  )
			 }
			 Text("Dish Creation")
				.font(.title)
				.fontWeight(.medium)
				.fontDesign(.serif)
				.foregroundStyle(Color.primaryAction)
				.frame(maxWidth: .infinity, alignment: .leading)
		  }
		  VStack(alignment: .leading){
			 
			 Text("Time of Cooking")
				.section(weight: .medium, color: .primarytext.opacity(0.6))
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
							  .foregroundStyle(selected ? Color.primaryAction : Color.background)
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
			 withAnimation(.bouncy){
				if vm.ableToCreate{
				  vm.request()
				}else{
				  showWarning = true
				}
			 }
		  }label: {
			 Text("Create")
				.font(.title3.weight(.semibold))
				.fontDesign(.rounded)
				.foregroundStyle(.white)
				.padding()
				.frame(maxWidth: .infinity)
				.background(
				  RoundedRectangle(cornerRadius: 20)
					 .fill(Color.accentCard)
				)
		  }
		  .buttonStyle(buttonTapScale())
		  .opacity(vm.ableToCreate ? 1 : 0.6)
			 if showWarning{
				Text("Please add some ingredients or note")
				  .frame(maxWidth: .infinity, alignment: .center)
				  .font(.footnote.weight(.black))
				  .foregroundStyle(.avoid)
				  
			 }
		}
		.padding()
		.onChange(of: showWarning){_, newValue in
		  if newValue{
			 DispatchQueue.main.asyncAfter(deadline: .now() + 2){
				withAnimation(.bouncy){
				  showWarning = false
				}
			 }
		  }
		}
		
		
	 }
	 .animation(.easeInOut(duration: 0.2), value: vm.error != nil)
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
