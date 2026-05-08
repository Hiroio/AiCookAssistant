//
//  TextViewModifiers.swift
//  CoockingApp
//
//  Created by user on 06.05.2026.
//

import Foundation
import SwiftUI

extension View{
  func title(weight: Font.Weight = .medium, color: Color = .primaryAction) -> some View{
	 self
		.fontDesign(.serif)
		.fontWeight(weight)
		.foregroundStyle(color)
  }
  
  func section(weight: Font.Weight = .medium, color: Color = .primarytext) -> some View{
	 self
		.font(.headline)
		.fontDesign(.serif)
		.fontWeight(weight)
		.foregroundStyle(color)
  }
}
