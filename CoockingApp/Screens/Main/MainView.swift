//
//  MainView.swift
//  CoockingApp
//
//  Created by user on 02.05.2026.
//

import SwiftUI

struct MainView: View {
  @State private var showAllIdeas: Bool = false
    var body: some View {
		ZStack{
		  Color.softIvory.ignoresSafeArea()
		  VStack{
			 header
			 ScrollView {
				VStack(alignment: .leading){
				  //				MARK: Recomendation
				  Text("Recomended for you")
					 .headline()
				  RecipeCardView(recipe: .preview)
				  //				MARK: Quick ideas
				  HStack{
					 Text("Quick Ideas")
						.headline()
					 Spacer()
					 Button{
						showAllIdeas.toggle()
					 }label: {
						Text("View all")
						  .font(.callout)
						  .foregroundStyle(.charcoal.opacity(0.5))
					 }
				  }
				  IdeasView()
				  
				  
				  //				MARK: Latest Recipe
				  
				  Text("Latest recipe")
					 .headline()
					 .padding(.top)
				}
			 }
		  }
		  .padding()
		}
		.sheet(isPresented: $showAllIdeas) {
		  VStack{
			 HStack{
			 Text("Ideas")
				  .font(.title2.bold())
				  .foregroundStyle(.herbalGreen)
				.padding(.trailing)
			 
				Button{
				  showAllIdeas = false
				}label: {
				  Image(systemName: "xmark")
					 .foregroundStyle(.mossGreen)
					 .padding()
					 .background(
						Circle()
						  .fill(.warmBeige.opacity(0.5))
					 )
					 
				}
				.frame(maxWidth: .infinity, alignment: .trailing)
			 }
			 .padding()
			 ScrollView{
				LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
				  ForEach(IdeasEnum.allCases){idea in
					 IdeaCard(idea)
				  }
				}
			 }
		  }
		}
    }
  
  private var header: some View{
	 VStack(alignment: .leading, spacing: 0){
		Text("Hello, chef!")
		  .foregroundStyle(.mossGreen)
		  .font(.title.bold())
		Text("Ready to cook?")
		  .foregroundStyle(.herbalGreen)
	 }
	 .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
    MainView()
}
