//
//  InstructionView.swift
//  CoockingApp
//
//  Created by user on 01.05.2026.
//

import SwiftUI

struct InstructionView: View {
  let instructions: [String]
    var body: some View {
		ScrollView{
		  VStack{
			 ForEach(0..<instructions.count, id: \.self){ index in
				if index != 0 {
				  Divider()
				}
				HStack{
				  Text("\(index)")
					 .font(.headline.weight(.medium))
					 .padding(12)
					 .foregroundStyle(.primaryAction)
					 .padding(5)
					 .background(
						Circle()
						  .stroke(.rareCard.shadow(.inner(color: .black, radius: 1.2)), lineWidth: 1)
					 )
				  
				  let text = instructions[index].components(separatedBy: "-")
				  let step = text[1].trimmingCharacters(in: .whitespacesAndNewlines)
				  Text(step)
					 .multilineTextAlignment(.leading)
					 .frame(maxWidth: .infinity, alignment: .leading)
					 .font(.subheadline.weight(.light))
					 .kerning(0.6)
				  let imageText = text[0].trimmingCharacters(in: .whitespaces)
				  Image(imageText.isEmpty ? "chefsHat" : "\(imageText)Icon")
					 .resizable()
					 .scaledToFit()
					 .frame(height: 65)
				}
				.fontDesign(.serif)
				.padding()
			 }
		  }
		}
    }
}

#Preview {
  ZStack{
	 Color.background.ignoresSafeArea()
	 InstructionView(instructions: ["wash - qweqesdjfis jdofjsdo jfsoidjfo sj dof jsdjfs doijsdij fsodjfo sjdofjsd ojfsod", "peel - qweqe", "boil - qweqe"])
  }
}
