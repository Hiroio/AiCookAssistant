//
//  IdeasView.swift
//  CoockingApp
//
//  Created by user on 02.05.2026.
//

import SwiftUI

struct IdeasView: View {
  let createRecipe: (String) -> ()
    var body: some View {
		HStack(alignment: .top){
		  ForEach(IdeasEnum.getRandom()){item in
			 Button{
				createRecipe(item.prompt)
			 }label:{
				VStack{
				  Image(systemName: item.icon)
					 .font(.largeTitle)
					 .fontWeight(.medium)
					 .frame(width: 35, height: 35)
					 .foregroundStyle(Color.primaryAction)
					 .padding()
					 .background(
						RoundedRectangle(cornerRadius: 15)
						  .fill(.secondaryCard.opacity(0.8))
					 )
				  Text(item.title)
					 .foregroundStyle(.primarytext)
					 .fontDesign(.rounded)
					 .font(.caption)
					 .multilineTextAlignment(.center)
				}
				.frame(maxWidth: .infinity, alignment: .top)
			 }
		  }
		}
    }
}

#Preview {
    IdeasView(createRecipe: { _ in})
}


