//
//  NoteCard.swift
//  CoockingApp
//
//  Created by user on 05.05.2026.
//

import SwiftUI

struct NoteCard: View {
  @Binding var noteText: String
  @State private var added: Bool = false
  @State private var folded: Bool = false
    var body: some View {
		VStack{
		  Button{
			 if !added{
				added.toggle()
				folded.toggle()
			 }else{
				folded.toggle()
			 }
		  }label: {
			 HStack{
				if added{
				  Image(systemName: "note.text")
					 .headline()
				}
				Text("\(added ? "Preference per dish" : "Add note (optional)")")
				  .foregroundStyle(Color.primaryAction)
				  .headline()
				Spacer()
				
				Image(systemName: added ? "chevron.up" : "plus")
				  .foregroundStyle(Color.background)
				  .rotationEffect(Angle(degrees: folded ? 0 : -180))
				  .padding(10)
				  .background(
					 Circle()
						.fill(Color.primaryAction)
				  )
			 }
			 .contentTransition(.numericText())
		  }.buttonStyle(.plain)
		  if added && folded{
			 TextField("", text: $noteText,  prompt: Text("Preferences regarding the dish"), axis: .vertical)
				.foregroundStyle(Color.primaryAction)
				.padding()
				.background(
				  RoundedRectangle(cornerRadius: 15)
					 .fill(Color.accentCard.opacity(0.2))
				)
				.frame(minHeight: 55, maxHeight: 75)
				.fixedSize(horizontal: false, vertical: true)
		  }
		}
		.padding(12)
		.background(
		  RoundedRectangle(cornerRadius: 20)
			 .fill(Color.secondaryCard.opacity(0.5))
		)
		.overlay(
		  RoundedRectangle(cornerRadius: 20)
			 .stroke(Color.accentCard, style: .init(lineWidth: 0.5, lineJoin: .round, dash: [8.5], dashPhase: 0))
		)
		.animation(.easeInOut, value: folded)
		.animation(.easeInOut, value: added)
    }
}

#Preview {
  CreationView(ingredients: [])
}
