//
//  IdeaCard.swift
//  CoockingApp
//
//  Created by user on 02.05.2026.
//

import SwiftUI

struct IdeaCard: View {
  let item: IdeasEnum
  init(_ item: IdeasEnum) {
	 self.item = item
  }
    var body: some View {
		VStack{
		  Image(systemName: item.icon)
			 .font(.largeTitle)
			 .frame(width: 45, height: 45)
			 .foregroundStyle(Color.primaryAction)
			 .padding()
			 .background(
				RoundedRectangle(cornerRadius: 15)
				  .fill(Color.rareCard.opacity(0.5))
			 )
		  Text(item.title)
			 .font(.caption)
			 .multilineTextAlignment(.center)
		}
		.frame(maxWidth: .infinity, maxHeight: 140, alignment: .top)
    }
}

#Preview {
  IdeaCard(.budgetMeal)
}
