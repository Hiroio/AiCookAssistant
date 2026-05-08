//
//  SwiftExtensions.swift
//  CoockingApp
//
//  Created by user on 08.05.2026.
//

import Foundation


extension Date{
  func inToday() -> Bool{
	 let calendar = Calendar.current
	 
	 return calendar.isDateInToday(self)
  }
}



