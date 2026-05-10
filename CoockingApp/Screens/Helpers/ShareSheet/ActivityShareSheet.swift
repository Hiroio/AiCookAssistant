//
//  ActivityShareSheet.swift
//  CoockingApp
//
//  Created by Codex on 11.05.2026.
//

import SwiftUI
import UIKit

struct ActivityShareSheet: UIViewControllerRepresentable {
  let activityItems: [Any]
  
  func makeUIViewController(context: Context) -> UIActivityViewController {
	 UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

