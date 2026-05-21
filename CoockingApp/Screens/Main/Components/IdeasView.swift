//
//  IdeasView.swift
//  CoockingApp
//
//  Created by user on 02.05.2026.
//

import SwiftUI

struct IdeasView: View {
  let spacing: CGFloat
  let iconSize: CGFloat
  let createRecipe: (String) -> Void

  init(spacing: CGFloat = 8, iconSize: CGFloat = 34, createRecipe: @escaping (String) -> Void) {
    self.spacing = spacing
    self.iconSize = iconSize
    self.createRecipe = createRecipe
  }

  var body: some View {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: 4), spacing: spacing) {
      ForEach(IdeasEnum.getRandom()) { item in
        Button {
          createRecipe(item.prompt)
        } label: {
          IdeaCard(item, iconSize: iconSize)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
      }
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  IdeasView(createRecipe: { _ in })
}
