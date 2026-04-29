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
					 Rectangle()
						.fill(Color.accent.opacity(0.8))
						.matchedGeometryEffect(id: "rectange", in: nameSpace)
						.shadow(radius: 5)
				  }
				  
				  Text(time)
					 .foregroundStyle(selected ? .background : .accent)
					 .font(.headline)
					 .fontWeight(.black)
					 .contentTransition(.opacity)
				}
				.frame(maxWidth: .infinity, maxHeight: 55)
			 }
			 .buttonStyle(.plain)
			 if time != times.last{
				Rectangle()
				  .fill(.accent)
				  .frame(width: 3, height: 35)
			 }
		  }
		  
		}
		.animation(.easeInOut, value: userTime)
		.frame(maxWidth: .infinity)
		.background(
		  ZStack{
			 RoundedRectangle(cornerRadius: 20)
				.fill(.secondory2.opacity(0.3))
			 RoundedRectangle(cornerRadius: 20)
				.stroke(.accent, lineWidth: 5)
		  }
		  
		)
		.cornerRadius(20)
    }
}

#Preview {
  ZStack{
	 Color.background.ignoresSafeArea()
	 TimeSelection(userTime: .constant("< 20"))

  }
}
