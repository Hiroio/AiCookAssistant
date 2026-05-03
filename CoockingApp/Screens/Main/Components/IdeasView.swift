//
//  IdeasView.swift
//  CoockingApp
//
//  Created by user on 02.05.2026.
//

import SwiftUI

struct IdeasView: View {
    var body: some View {
		HStack(alignment: .top){
		  ForEach(IdeasEnum.getRandom()){item in
			 VStack{
				Image(systemName: item.icon)
				  .font(.largeTitle)
				  .frame(width: 45, height: 45)
				  .foregroundStyle(.mossGreen)
				  .padding()
				  .background(
					 RoundedRectangle(cornerRadius: 15)
						.fill(.warmBeige.opacity(0.5))
				  )
				Text(item.title)
				  .font(.caption)
				  .multilineTextAlignment(.center)
			 }
			 .frame(maxWidth: .infinity, maxHeight: 140, alignment: .top)
			 
		  }
		}
    }
}

#Preview {
    IdeasView()
}



