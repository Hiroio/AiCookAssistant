//
//  AlergiesSheet.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import SwiftUI

struct AlergiesSheet: View {
  @EnvironmentObject private var vm: ProfileViewModel
	    var body: some View {
			ZStack{
			  Color.rareCard.opacity(0.4)
				 .ignoresSafeArea()
		  
		  VStack(spacing: 15){
			header
			 Text("\(vm.activeSheet?.title ?? "Edit")")
				.fontDesign(.serif)
				.fontWeight(.semibold)
				.frame(maxWidth: .infinity)
			 VStack(alignment: .leading, spacing: 15){
				//			 MARK: TextField
				HStack{
				  HStack{
					 Image(systemName: "leaf")
					 Rectangle()
						.frame(width: 1, height: 20)
				  }.foregroundStyle(.primaryAction)
				  
					  TextField("", text: $vm.sheetText, prompt: Text("Enter Product here"))
						 .submitLabel(.done)
						 .onSubmit {
							vm.textAction()
						 }
					  
					  Button{
						 vm.textAction()
					  }label: {
					 Image(systemName: "plus")
						.foregroundStyle(Color.background)
						.padding(10)
						.background(
						  Circle()
							 .fill(.accentCard)
						)
					  }
					  .iconButtonAccessibility("Add ingredient preference")
					}
				.padding(8)
				.background(
				  RoundedRectangle(cornerRadius: 15)
					 .fill(Color.background)
				)
				
				Text("Popular choises")
				  .font(.footnote)
				  .foregroundStyle(.primaryAction)
				
				ListOfIngredients(current: false, array: (vm.getListOfPreferences())){alergie in vm.sheetAction(item: alergie)}
				Divider()
				
				VStack(alignment: .leading, spacing: 25){
				  HStack{
					 Text("Your choises")
						.font(.footnote)
						.foregroundStyle(.primaryAction)
					Spacer()
					 Text("\(vm.user.alergieIngredients.count) items")
						.font(.caption)
						.opacity(0.6)
				  }
				  
				  if vm.user.alergieIngredients.isEmpty{
					 VStack{
						Image(systemName: "leaf")
						  .padding()
						  .background(
							 Circle()
								.fill(.accentCard.opacity(0.6))
						  )
						Text("No Ingredient added yet")
						  .font(.headline)
						Text("Add ingredients to presonalize you recipes")
						  .font(.subheadline)
						  .opacity(0.7)
					 }
					 .frame(maxWidth: .infinity)
				  }else{
					 ListOfIngredients(
						current: true,
						array: (vm.activeSheet == .allergies ? vm.user.alergieIngredients : vm.user.avoidIngredients))
					 {alergie in vm.sheetAction(item: alergie)}
				  }
				}
			 }
			 .frame(maxHeight: .infinity, alignment: .top)
			 
			
		  }
		  .animation(.bouncy, value: vm.user.alergieIngredients)
		  .animation(.bouncy, value: vm.user.avoidIngredients)
		  .padding()
			}
			
	    }
  
  
  public var header: some View{
	 HStack{
			Button{
			  vm.cancel()
			}label: {
		  Text("Cancel")
		}
		Spacer()
			Button{
			  vm.save()
			}label:{
		  Text("Save")
		}
	 }
	 .font(.subheadline)
	 .foregroundStyle(.primaryAction)
	 .padding(.top)
  }
  
}

#Preview {
    AlergiesSheet()
	 .environmentObject(ProfileViewModel())
}
