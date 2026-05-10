//
//  ErrorPopUpView.swift
//  CoockingApp
//
//  Created by user on 09.05.2026.
//

import SwiftUI

struct ErrorPopUpView: View {
  let error: CreationError
  let dismissAction: () -> Void
  
    var body: some View {
		ZStack {
		VStack(spacing: 16) {
		  Image(error.icon)
			 .resizable()
			 .scaledToFit()
			 .frame(width: 154, height: 134)
			 
		  VStack(spacing: 8) {
			 Text(error.title)
				.font(.headline.weight(.medium))
				.foregroundStyle(Color.primarytext)
			 
			 Text(error.message)
				.font(.footnote.weight(.light))
				.foregroundStyle(Color.primarytext.opacity(0.62))
				.multilineTextAlignment(.center)
		  }
		  
			  Button {
				 dismissAction()
			  } label: {
			 Text("OK")
				.font(.subheadline.weight(.semibold))
				.foregroundStyle(.white)
				.padding(.vertical, 12)
				.frame(maxWidth: .infinity)
				.background(
				  RoundedRectangle(cornerRadius: 16)
					 .fill(Color.primaryAction)
				)
		  }
		  .buttonStyle(.plain)
		}
		.padding(20)
		.frame(maxWidth: 300)
		.background(
		  RoundedRectangle(cornerRadius: 24)
			 .fill(Color.background.mix(with: .white, by: 0.2))
			 .shadow(color: .black.opacity(0.52), radius: 5, y: 2)
		)
		.padding(.horizontal, 28)
	 }
  }
}

#Preview {
  ErrorPopUpView(error: .somethingWentWrong) {}
}
