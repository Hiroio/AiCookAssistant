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

  let scansRemainingText: String?
  let isPhotoScanAvailable: Bool
  let onScanTapped: () -> Void

  var body: some View {
    VStack(alignment: .leading) {
      Text("Ingredients")
        .headline()

      HStack(alignment: .center, spacing: 2) {
        HStack {
          TextField("", text: $text, prompt: Text("Potato Chicken Herbs"))
            .submitLabel(.done)
            .onSubmit {
              addIngredient(text: text)
            }
            .foregroundStyle(Color.primaryAction)
            .padding()
          HStack(spacing: 0) {
            Button {
              addIngredient(text: text)
            } label: {
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
            .iconButtonAccessibility("Add ingredient", hint: "Adds typed ingredients")
          }
        }
        .background(
          ZStack {
            RoundedRectangle(cornerRadius: 25)
              .fill(Color.secondaryCard.shadow(.inner(radius: 1)))
          }
        )
        Button {
          if isPhotoScanAvailable {
            handleCameraTap()
          } else {
            onScanTapped()
          }
        } label: {
          Image(systemName: "camera")
            .padding(20)
            .foregroundStyle(Color.background)
            .background(
              RoundedRectangle(cornerRadius: 22)
                .fill(Color.accentCard)
            )
            .padding(.horizontal, 4)
        }
        .opacity(isPhotoScanAvailable ? 1 : 0.5)
        .iconButtonAccessibility("Scan ingredients", hint: "Opens the camera to recognize ingredients")
      }
      HStack {
        Text("To add multiple items, separate them with a comma")
          .font(.caption2)
          .foregroundStyle(Color.primarytext.opacity(0.6))
          .frame(maxWidth: .infinity, alignment: .leading)
        if let scansRemainingText {
          Text(scansRemainingText)
            .font(.caption)
            .opacity(0.6)
        }
      }
      .padding(.horizontal, 18)
      ScrollView {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
          ForEach(selectedIngredient, id: \.self) { text in
            Button {
              selectedIngredient.removeAll(where: { $0.lowercased() == text.lowercased() })
            } label: {
              HStack {
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
            .iconButtonAccessibility("Remove \(text)", hint: "Removes ingredient from the list")
            .transition(.scale)
            .allowsHitTesting(selectedIngredient.contains(where: { $0.lowercased() == text.lowercased() }))
          }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
      }
      .scrollDismissesKeyboard(.interactively)
      .scrollIndicators(.hidden)
    }
    .animation(.easeInOut, value: selectedIngredient)
    .alert(item: $cameraAlert) { alert in
      switch alert {
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

  func addIngredient(text: String) {
    if !selectedIngredient.contains(where: { $0.lowercased() == text.lowercased() }) {
      if text.contains(",") {
        let multipleText = text.components(separatedBy: ",").map({
          $0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
        }).filter { !$0.isEmpty }
        selectedIngredient.insert(contentsOf: multipleText, at: 0)
      } else {
        let checkedtext = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !checkedtext.isEmpty {
          selectedIngredient.insert(checkedtext.capitalized, at: 0)
        }
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
      requestCameraAccess()
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
  case permissionDenied
  case cameraUnavailable

  var id: String {
    switch self {
    case .permissionDenied:
      "permissionDenied"
    case .cameraUnavailable:
      "cameraUnavailable"
    }
  }
}

#Preview {
  ZStack {
    Color.background
    IngredientsView(
      selectedIngredient: .constant(["qwerqw", "fkoreqw"]),
      showCamera: .constant(false),
      scansRemainingText: "2 of 3",
      isPhotoScanAvailable: true,
      onScanTapped: {}
    )
  }
}
