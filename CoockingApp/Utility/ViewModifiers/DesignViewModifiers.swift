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
		.foregroundStyle(.accentCard)
		.fontWeight(.black)
  }
}
struct HeadlineViewModifier: ViewModifier {
  func body(content: Content) -> some View {
	 content
		.font(.headline)
		.fontDesign(.rounded)
		.fontWeight(.semibold)
		.foregroundStyle(.primaryAction)
  }
}

struct BadgeIconViewModifier: ViewModifier{
  let color: Color
  let size: Font
  func body(content: Content) -> some View {
	 content
		.foregroundStyle(Color.background)
		.font(size)
		.padding(10)
		.background(
		  Circle()
			 .fill(color)
		)
  }
}

struct CardForPersonalizationViewModifier: ViewModifier{
  func body(content: Content) -> some View {
	 content
		.padding(.horizontal, 14)
		.padding(.vertical, 14)
		.background(
		  RoundedRectangle(cornerRadius: 22)
			 .fill(Color.secondaryCard.opacity(0.48))
		)
		.overlay(
		  RoundedRectangle(cornerRadius: 22)
			 .stroke(Color.primarytext.opacity(0.07), lineWidth: 1)
		)
		.padding(.horizontal, 22)
		.padding(.top, 4)
  }
}

struct LatestCardViewModifier: ViewModifier{
  func body(content: Content) -> some View{
	 content
		.frame(width: 90)
		.padding()
		.background(
		  ZStack{
			 Color.background
			 Color.rareCard.opacity(0.1)
		  }
		)
		.clipShape(
		  UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 15, bottomTrailing: 15, topTrailing: 0))
		)
		.padding(.top, 10)
		.overlay(alignment: .top) {
		  Image("pin")
			 .resizable()
			 .scaledToFit()
			 .frame(height: 24)
			 .blur(radius: 0.5)
		}
		.compositingGroup()
		.shadow(color: .black.opacity(0.1), radius: 2, y: 2)
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
  
  func badgeIcon(color: Color, size: Font = .title2) -> some View{
	 modifier(BadgeIconViewModifier(color: color, size: size))
  }
  
  func cardForPersonalization() -> some View {
	 modifier(CardForPersonalizationViewModifier())
  }
  
  func latestCard() -> some View{
	 modifier(LatestCardViewModifier())
  }
}
