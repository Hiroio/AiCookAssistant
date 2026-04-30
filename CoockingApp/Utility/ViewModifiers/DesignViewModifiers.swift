//
//  DesignViewModifiers.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//
import SwiftUI

struct TitleViewModifier: ViewModifier {
  func body(content: Content) -> some View {
	 content
		.font(.largeTitle)
		.fontDesign(.rounded)
		.foregroundStyle(.accent)
		.fontWeight(.black)
  }
}
struct HeadlineViewModifier: ViewModifier {
  func body(content: Content) -> some View {
	 content
		.font(.headline)
		.fontDesign(.rounded)
		.fontWeight(.semibold)
		.foregroundStyle(.mossGreen)
  }
}


struct buttonTapScale: ButtonStyle{
  func makeBody(configuration: Configuration) -> some View {
	 configuration
		.label
		.offset(y: configuration.isPressed ? 2 : 0)
		.scaleEffect(configuration.isPressed ? 0.95 : 1)
		.brightness(configuration.isPressed ? -0.1 : 0)
		.shadow(radius: configuration.isPressed ? 0 : 2, y: 3)
  }
  
  
}

extension View{
  func titleStyle() -> some View {
	 modifier(TitleViewModifier())
  }
  
  func headline() -> some View{
	 modifier(HeadlineViewModifier())
  }
}
