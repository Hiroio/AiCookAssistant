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
					 .foregroundStyle(.softIvory)
					 .padding()
					 .background(
						Circle()
						  .fill(.mossGreen)
					 )
				  VStack(alignment: .leading, spacing: 15){
					 let text = instructions[index].components(separatedBy: "-").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
					 Text(text[0])
						.font(.headline)
						.foregroundStyle(.mossGreen)
						.multilineTextAlignment(.leading)
					 Text(text.last ?? "")
						.multilineTextAlignment(.leading)
				  }
				  
					 .frame(maxWidth: .infinity)
				  
				  Image(systemName: "fork.knife")
					 .font(.title)
					 .foregroundStyle(.herbalGreen)
				}
				.padding()
			 }
		  }
		}
    }
}

#Preview {
    InstructionView(instructions: ["", "", ""])
}
