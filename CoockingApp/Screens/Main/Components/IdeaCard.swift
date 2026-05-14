//
//  IdeaCard.swift
//  CoockingApp
//
//  Created by user on 02.05.2026.
//

import SwiftUI

struct IdeaCard: View {
  let item: IdeasEnum
  let iconSize: CGFloat
  
  init(_ item: IdeasEnum, iconSize: CGFloat = 34) {
	 self.item = item
	 self.iconSize = iconSize
  }
    var body: some View {
		VStack(spacing: 8){
		  RoundedRectangle(cornerRadius: 15)
			 .fill(Color.rareCard.opacity(0.5))
			 .aspectRatio(1, contentMode: .fit)
			 .overlay {
				Image(systemName: item.icon)
				  .font(.system(size: iconSize, weight: .medium))
				  .foregroundStyle(Color.primaryAction)
			 }
		  
		  Text(item.title)
			 .font(.caption)
			 .foregroundStyle(Color.primarytext)
			 .multilineTextAlignment(.center)
			 .lineLimit(1)
			 .frame(maxWidth: .infinity, minHeight: 12, alignment: .top)
			 .minimumScaleFactor(0.25)
		}
		.frame(maxWidth: .infinity, alignment: .top)
    }
}

#Preview {
  IdeaCard(.budgetMeal)
}
