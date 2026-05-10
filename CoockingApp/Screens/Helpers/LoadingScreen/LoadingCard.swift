//
//  LoadingCard.swift
//  CoockingApp
//
//  Created by user on 08.05.2026.
//

import SwiftUI

struct LoadingCard: View {
  @State private var startTime = Date()
    var body: some View {
		
		TimelineView(.animation(minimumInterval: 1 / 30)) { context in
		  let elapsed = context.date.timeIntervalSince(startTime)
		  let sprite = Int(elapsed * 4) % 12
		  ZStack {
			 VStack(spacing: 14) {
				Image("cooking\(sprite)")
				  .resizable()
				  .scaledToFit()
			 }
			 .multilineTextAlignment(.center)
			 
		  }
		}
	 }
}

#Preview {
    LoadingCard()
}
