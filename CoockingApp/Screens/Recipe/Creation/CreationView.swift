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
  var body: some View {
	 ZStack{
		Color.background.ignoresSafeArea()
		VStack(alignment: .leading, spacing: 15){
		  Text("Dish Creation")
			 .shadow(color: .black.opacity(0.12),radius: 2,x: -3, y: 3)
			 .titleStyle()
			 .frame(maxWidth: .infinity, alignment: .leading)
		  
		  VStack(alignment: .leading){
			 Text("Time of Cooking")
				.headline()
			 TimeSelection(userTime: $vm.selectedTime)
		  }
		  
		  IngredientsView(selectedIngredient: $vm.userIngredients, showCamera: $showCamera)
		  
		  if let createdImage{
			 Image(uiImage: createdImage)
				.resizable()
				.frame(width: 200, height: 200)
				.scaledToFit()
		  }
		  Spacer()
		  VStack{
			 HStack{
				Text("Difficulty:")
				
				Spacer()
				Text("\(vm.difficulty) / 5")
				  .foregroundStyle(.accent)
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
					 Image(systemName: selected ? "fork.knife.circle.fill" : "fork.knife.circle")
						.font(.largeTitle.bold())
						.foregroundStyle(selected ? .accent : .general.opacity(0.5))
				  }
				}
			 }
			 .padding(10)
			 .frame(maxWidth: .infinity)
			 .background(
				ZStack{
				  RoundedRectangle(cornerRadius: 20)
					 .fill(.secondory2.opacity(0.3).shadow(.inner(radius: 10)))
				  RoundedRectangle(cornerRadius: 20)
					 .stroke(.accent, lineWidth: 3)
				}
			 )
			 .frame(maxWidth: .infinity)
		  }
		  
		  
		  
		  Button{
			 vm.request()
		  }label: {
			 Text("Create")
				.font(.title3.bold())
				.fontWeight(.black)
				.foregroundStyle(.white)
				.shadow(radius: 3)
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
	 }
  }
}

#Preview {
  CreationView()
}
