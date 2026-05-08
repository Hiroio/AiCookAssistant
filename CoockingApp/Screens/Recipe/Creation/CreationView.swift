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
		
		if let error = vm.error {
		  ZStack{
			 Color.black.opacity(0.08)
				.ignoresSafeArea()
				.onTapGesture {
				  vm.error = nil
				}
			 errorPopup(error)
				.transition(.opacity.combined(with: .scale(scale: 0.96)))
		  }
		  .zIndex(1)
		  .allowsHitTesting(vm.error != nil)
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
  
  private func errorPopup(_ error: CreationError) -> some View {
	 ZStack {
		
		VStack(spacing: 16) {
		  Image(error.icon)
			 .resizable()
			 .scaledToFit()
			 .frame(width: 154, height: 134)
			 
		  VStack(spacing: 8) {
			 Text(error.title)
				.font(.headline.weight(.medium))
				.foregroundStyle(Color.primarytext)
			 
			 Text(error.message)
				.font(.footnote.weight(.light))
				.foregroundStyle(Color.primarytext.opacity(0.62))
				.multilineTextAlignment(.center)
		  }
		  
		  Button {
			 vm.error = nil
		  } label: {
			 Text("OK")
				.font(.subheadline.weight(.semibold))
				.foregroundStyle(.white)
				.padding(.vertical, 12)
				.frame(maxWidth: .infinity)
				.background(
				  RoundedRectangle(cornerRadius: 16)
					 .fill(Color.primaryAction)
				)
		  }
		  .buttonStyle(.plain)
		}
		.padding(20)
		.frame(maxWidth: 300)
		.background(
		  RoundedRectangle(cornerRadius: 24)
			 .fill(Color.background.mix(with: .white, by: 0.2))
			 .shadow(color: .black.opacity(0.52), radius: 5, y: 2)
		)
		.padding(.horizontal, 28)
	 }
  }
}

#Preview {
  CreationView()
}
