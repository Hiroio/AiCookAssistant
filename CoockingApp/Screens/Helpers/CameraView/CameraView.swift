//
//  CameraView.swift
//  CoockingApp
//
//  Created by user on 30.04.2026.
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  @Environment(\.dismiss) var dismiss
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
	 let picker = UIImagePickerController() // creating camera picker
	 picker.sourceType = .camera  // set source as a camera
	 picker.delegate = context.coordinator // Set Coordinator as delegate
	 return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
//	 NO Updated needed
  }
  
  func makeCoordinator() -> Coordinator {
	 Coordinator(self)
  }
  
  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	 var parent: CameraView
	 
	 init(_ parent: CameraView) {
		self.parent = parent
	 }
	 
	 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[.originalImage] as? UIImage {
		  parent.image = image // pass selected Image to parent
		}
		
		parent.dismiss() // close after that
	 }
	 
	 func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		parent.dismiss() // dismiss if cancel
	 }
  }
}
