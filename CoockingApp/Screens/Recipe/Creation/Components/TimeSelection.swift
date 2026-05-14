//
//  TimeSelection.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import SwiftUI

struct TimeSelection: View {
  @Namespace var nameSpace
  let times: [String] = ["< 20", "20 - 50", "> 50"]
  @Binding var userTime: String
    var body: some View {
		HStack(spacing: 0){
		  ForEach(times, id: \.self){time in
			 Button{
				userTime = time
			 }label:{
				ZStack{
				  let selected = userTime == time
				  if selected{
					 RoundedRectangle(cornerRadius: 20)
						.fill(Color.accentCard.opacity(0.8))
						.matchedGeometryEffect(id: "rectange", in: nameSpace)
						.shadow(radius: 5)
				  }
				  
				  Text("\(time) min")
					 .foregroundStyle(selected ? Color.background : Color.accentCard)
					 
					 .fontDesign(.rounded)
					 .contentTransition(.opacity)
				}
				.contentShape(.rect)
				.frame(maxWidth: .infinity, maxHeight: 55)
			 }
			 .buttonStyle(.plain)
		  }
		  
		}
		.animation(.easeInOut, value: userTime)
		.frame(maxWidth: .infinity)
		.background(
		  ZStack{
			 RoundedRectangle(cornerRadius: 20)
				.stroke(Color.secondaryCard, lineWidth: 5)
		  }
		  
		)
			.clipShape(.rect(cornerRadius: 20))
	    }
}

#Preview {
  ZStack{
	 Color.background.ignoresSafeArea()
	 TimeSelection(userTime: .constant("< 20"))

  }
}
