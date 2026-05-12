//
//  MainLoadingScreen.swift
//  CoockingApp
//
//  Created by user on 11.05.2026.
//

import SwiftUI

struct MainLoadingScreen: View {
    var body: some View {
		ZStack(alignment: .bottom){
		  Color.background.ignoresSafeArea()
		  VStack(spacing: 0){
			 LoadingCard()
				.frame(width: 140)
			 Text("DeliNote")
				.font(.subheadline.weight(.black))
				.fontDesign(.rounded)
				.foregroundStyle(.primaryAction)
		  }
		}
    }
}

#Preview {
    MainLoadingScreen()
}
