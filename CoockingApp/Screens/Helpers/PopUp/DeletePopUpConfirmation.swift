//
//  DeletePopUpConfirmation.swift
//  CoockingApp
//
//  Created by user on 11.05.2026.
//

import SwiftUI

struct DeletePopUpConfirmation: View {
  let cancel: () -> ()
  let confirm: () -> ()
    var body: some View {
		VStack(spacing: 26) {
		  VStack(spacing: 6) {
			 Text("Are you sure?")
				.font(.system(size: 34, weight: .black, design: .rounded))
				.foregroundStyle(Color.primarytext)
			 
			 Text("This action is dangerous!\nYou won't be able to restore the changes!")
				.font(.subheadline.weight(.bold))
				.foregroundStyle(Color.primarytext.opacity(0.82))
		  }
		  .multilineTextAlignment(.center)
		  .padding(.top, 58)
		  
		  HStack(spacing: 12) {
			 Button {
				cancel()
			 } label: {
				Text("Cancel")
				  .font(.title3.weight(.bold))
				  .foregroundStyle(Color.background)
				  .frame(maxWidth: .infinity)
				  .padding(.vertical, 12)
				  .background(
					 RoundedRectangle(cornerRadius: 16)
						.fill(Color.accentCard)
				  )
			 }
			 
			 Button {
				confirm()
			 } label: {
				Text("Confirm")
				  .font(.title3.weight(.bold))
				  .foregroundStyle(Color.background)
				  .frame(maxWidth: .infinity)
				  .padding(.vertical, 12)
				  .background(
					 RoundedRectangle(cornerRadius: 16)
						.fill(Color.avoid)
				  )
			 }
		  }
		}
		.buttonStyle(.plain)
		.padding(18)
		.background {
		  ZStack {
			 RoundedRectangle(cornerRadius: 22)
				.fill(Color.white)
			 RoundedRectangle(cornerRadius: 22)
				.fill(Color.rareCard.opacity(0.38))
			 
			 Image("PopUpBack")
				.resizable()
				.scaledToFit()
				.opacity(0.5)
				.padding(.horizontal, 48)
				.offset(y: -32)
				.shadow(radius: 1, y: 3)
		  }
		}
		.padding(.horizontal, 22)
    }
}

#Preview {
    DeletePopUpConfirmation(cancel: {}, confirm: {})
}
