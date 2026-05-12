//
//  PersonalizationRow.swift
//  CoockingApp
//
//  Created by user on 12.05.2026.
//

import SwiftUI

struct PersonalizationRow: View {
  let title: String
  let subtitle: String
  let icon: String
  let state: Bool
    var body: some View {
		HStack(spacing: 14) {
		  Image(systemName: icon)
			 .font(.system(size: 17, weight: .semibold))
			 .foregroundStyle(Color.primaryAction)
			 .frame(width: 38, height: 38)
			 .background(Circle().fill(Color.background.opacity(0.72)))
		  
		  VStack(alignment: .leading, spacing: 3) {
			 Text(title)
				.font(.subheadline.weight(.semibold))
				.foregroundStyle(Color.primarytext)
			 
			 Text(subtitle)
				.font(.caption)
				.foregroundStyle(Color.primarytext.opacity(0.55))
		  }
		  
		  Spacer()
		  
		  Image(systemName: "chevron.down")
			 .font(.caption.weight(.semibold))
			 .rotationEffect(Angle(degrees: state ? 180 : 0))
			 .foregroundStyle(Color.primarytext.opacity(0.35))
		}
    }
}

#Preview {
    PersonalizationRow(title: "Cooking identity",
							  subtitle: "qweqwe",
					  icon: "fork.knife",
					  state: false)
}
