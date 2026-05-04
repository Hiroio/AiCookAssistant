//
//  AlergiesSheet.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import SwiftUI

struct AlergiesSheet: View {
  @State private var text: String = ""
  @AppStorage("test") private var alergies: String = ""
  var splitedAlergies: [String]{
	 get{
		alergies.components(separatedBy: "\n")
	 }
	 set{
		self.alergies = newValue.joined(separator: "\n")
	 }
  }
  
  let array: [String] = ["🥛 Lactose free", "🍞 Gluten free", "🥜 Peanuts", "🌰 Tree nuts", "🥚 Egg free", "🍋 Citrus", "🦐 Seafood", "🐟 Fish", "🫘 Soy free"]
    var body: some View {
		ZStack{
		  Color.warmBeige.opacity(0.5)
			 .ignoresSafeArea()
		  
		  VStack{
			 HStack{
				TextField("", text: $text, prompt: Text("Enter Product here"))
				  .padding()
				  .background(
					 RoundedRectangle(cornerRadius: 15)
						.fill(.softIvory)
				  )
				
				Button{
				  
				}label: {
				  Image(systemName: "plus")
					 .foregroundStyle(.softIvory)
					 .padding(15)
					 .background(
						Circle()
						  .fill(.herbalGreen)
					 )
				}
			 }
			 
			 ScrollView(.horizontal){
				HStack{
				  if alergies.isEmpty{
					 Text("Your list currently empty")
						.opacity(0.7)
				  }else{
//					 ForEach(usermanager.userAlergies, id: \.self){item in
//						HStack{
//						  Text(item)
//						  Button{
//							 usermanager.addAlergie(alergie: item)
//						  }label: {
//							 Image(systemName: "minus")
//						  }
//						}
//						.font(.headline)
//						.padding(5)
//						.background(
//						  RoundedRectangle(cornerRadius: 15)
//							 .fill(.softIvory)
//							 .shadow(radius: 1)
//						)
//					 }
				  }
				}
				.padding()
			 }
			 .background(
				RoundedRectangle(cornerRadius: 15)
				  .fill(.black.opacity(0.1))
			 )
			 Divider()
			 Text("Alergies")
				.font(.title)
				.fontDesign(.serif)
			 ScrollView(.horizontal){
				LazyHGrid(rows: [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)], spacing: 15) {
				  ForEach(array, id: \.self){item in
					 if !splitedAlergies.contains(item){
						HStack{
						  Text(item)
						  Button{
							 
						  }label: {
							 Image(systemName: "plus")
						  }
						}
						.font(.headline)
						.padding(5)
						.background(
						  RoundedRectangle(cornerRadius: 15)
							 .fill(.softIvory)
							 .shadow(radius: 1)
						)
					 }
				  }
				}
			 }
			 
		  }
		  .padding()
		}
		
    }
}

#Preview {
    AlergiesSheet()
}


