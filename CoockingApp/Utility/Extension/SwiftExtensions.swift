//
//  SwiftExtensions.swift
//  CoockingApp
//
//  Created by user on 08.05.2026.
//

import Foundation
import SwiftUI


extension Date{
  func inToday() -> Bool{
	 let calendar = Calendar.current
	 
	 return calendar.isDateInToday(self)
  }
}


extension UIDevice {
	 static var isIPad: Bool {
		  UIDevice.current.userInterfaceIdiom == .pad
	 }
	 
	 static var isIPhone: Bool {
		  UIDevice.current.userInterfaceIdiom == .phone
	 }
}
