//
//  IngredientsView.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import SwiftUI
import AVFoundation
import UIKit

struct IngredientsView: View {
  @State private var text: String = ""
  @State private var cameraAlert: CameraAccessAlert?
  @Binding var selectedIngredient: [String]
  @Binding var showCamera: Bool
  @Environment(\.openURL) private var openURL
  let leftScan: Int
  
  private var hasFullAccess: Bool {
	 StoreManager.shared.hasFullAccess
  }
  
  private var freeScansLeft: Int {
	 max(0, leftScan)
  }
  
  var body: some View {
	 VStack(alignment: .leading){
		Text("Ingredients")
		  .headline()
		
		HStack(alignment: .center,spacing: 2){
		  HStack{
			 TextField("", text: $text, prompt: Text("Potato Chicken Herbs"))
				.foregroundStyle(Color.primaryAction)
				.padding()
			 HStack(spacing: 0){
				Button{
				  addIngredient(text: text)
				}label:{
				  Image(systemName: "plus")
					 .padding()
					 .foregroundStyle(Color.background)
					 .background(
						RoundedRectangle(cornerRadius: 22)
						  .fill(Color.accentCard)
						  .shadow(radius: 2, x: -2, y: 1)
					 )
					 .padding(4)
				}
			 }
		  }
		  .background(
			 ZStack{
				RoundedRectangle(cornerRadius: 25)
				  .fill(Color.secondaryCard.shadow(.inner(radius: 1)))
			 }
		  )
			 Button{
				if !hasFullAccess && freeScansLeft < 1{
				  NavigationManager.shared.popup = .weeklyLimit(.photoScan)
				}else{
				  handleCameraTap()
				}
			 }label:{
				Image(systemName: "camera")
				  .padding(20)
				  .foregroundStyle(Color.background)
				  .background(
					 RoundedRectangle(cornerRadius: 22)
						.fill(Color.accentCard)
				  )
				  .padding(.horizontal, 4)
			 }
			 .opacity(freeScansLeft < 1 && !hasFullAccess ? 0.5 : 1)
		}
		HStack{
		  Text("To add multiple items, separate them with a comma")
			 .font(.caption2)
			 .foregroundStyle(Color.primarytext.opacity(0.6))
			 .frame(maxWidth: .infinity, alignment: .leading)
		  if !hasFullAccess{
			 Text("\(freeScansLeft) of 3")
				.font(.caption)
				.opacity(0.6)
		  }
		}
		.padding(.horizontal, 18)
			ScrollView{
				LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
				ForEach(selectedIngredient, id: \.self){text in
				  Button{
					 selectedIngredient.removeAll(where: {$0.lowercased() == text.lowercased()})
				  }label: {
					 HStack{
						Text(text)
						  .frame(maxWidth: .infinity, alignment: .leading)
						Image(systemName: "xmark")
					 }
					 .font(.footnote)
					 .foregroundStyle(Color.primarytext.opacity(0.8))
					 .frame(maxWidth: .infinity)
					 .padding(10)
					 .background(
						RoundedRectangle(cornerRadius: 15)
						  .fill(Color.secondaryCard.shadow(.inner(radius: 1)).opacity(0.5))
					 )
					 .contentShape(.rect)
				  }
				  .transition(.scale)
				  .allowsHitTesting(selectedIngredient.contains(where: {$0.lowercased() == text.lowercased()}))
				}
			 }
				.padding(.horizontal)
				.frame(maxWidth: .infinity)
			}
			.scrollIndicators(.hidden)
			  
		 }
	 .animation(.easeInOut, value: selectedIngredient)
	 .alert(item: $cameraAlert) { alert in
		switch alert {
		case .permissionIntro:
		  Alert(
			 title: Text("Scan ingredients"),
			 message: Text("DeliNote uses your camera only to recognize ingredients from a photo."),
			 primaryButton: .default(Text("Continue")) {
				requestCameraAccess()
			 },
			 secondaryButton: .cancel()
		  )
		case .permissionDenied:
		  Alert(
			 title: Text("Camera access needed"),
			 message: Text("Please allow camera access in Settings to scan ingredients."),
			 primaryButton: .default(Text("Open Settings")) {
				openAppSettings()
			 },
			 secondaryButton: .cancel()
		  )
		case .cameraUnavailable:
		  Alert(
			 title: Text("Camera unavailable"),
			 message: Text("This device does not have an available camera."),
			 dismissButton: .default(Text("OK"))
		  )
		}
	 }
  }
  
  func addIngredient(text: String){
	 if !selectedIngredient.contains(where: {$0.lowercased() == text.lowercased()}){
		if text.contains(","){
		  let multipleText = text.components(separatedBy: ",").map({$0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)})
		  selectedIngredient.insert(contentsOf: multipleText, at: 0)
		}else{
		  selectedIngredient.insert(text.capitalized, at: 0)
		}
	 }
	 self.text.removeAll()
  }
  
  private func handleCameraTap() {
	 guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
		cameraAlert = .cameraUnavailable
		return
	 }
	 
	 switch AVCaptureDevice.authorizationStatus(for: .video) {
	 case .authorized:
		showCamera = true
	 case .notDetermined:
		cameraAlert = .permissionIntro
	 case .denied, .restricted:
		cameraAlert = .permissionDenied
	 @unknown default:
		cameraAlert = .permissionDenied
	 }
  }
  
  private func requestCameraAccess() {
	 AVCaptureDevice.requestAccess(for: .video) { granted in
		DispatchQueue.main.async {
		  if granted {
			 showCamera = true
		  } else {
			 cameraAlert = .permissionDenied
		  }
		}
	 }
  }
  
  private func openAppSettings() {
	 guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
	 openURL(url)
  }
}

private enum CameraAccessAlert: Identifiable {
  case permissionIntro
  case permissionDenied
  case cameraUnavailable
  
  var id: String {
	 switch self {
	 case .permissionIntro:
		"permissionIntro"
	 case .permissionDenied:
		"permissionDenied"
	 case .cameraUnavailable:
		"cameraUnavailable"
	 }
  }
}

#Preview {
  ZStack{
	 Color.background
	 IngredientsView(selectedIngredient: .constant(["qwerqw", "fkoreqw"]), showCamera: .constant(false), leftScan: 0)
  }
}
