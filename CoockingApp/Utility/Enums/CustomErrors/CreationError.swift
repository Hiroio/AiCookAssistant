//
//  CreationError.swift
//  CoockingApp
//
//  Created by Codex on 07.05.2026.
//

import Foundation

enum CreationError: Identifiable, Equatable {
  case badInternetConnection
  case somethingWentWrong
  
  var id: String { title }
  
  var title: String {
	 switch self {
	 case .badInternetConnection:
		"Bad internet connection"
	 case .somethingWentWrong:
		"Something went wrong"
	 }
  }
  
  var message: String {
	 switch self {
	 case .badInternetConnection:
		"Please check your internet connection and try again."
	 case .somethingWentWrong:
		"The assistant could not create a valid recipe. Please try again."
	 }
  }
  
  var icon: String {
	 switch self {
	 case .badInternetConnection:
		"badInternet"
	 case .somethingWentWrong:
		"smthWentWrong"
	 }
  }
  
  static func map(_ error: Error) -> CreationError {
	 if isInternetConnectionError(error) {
		return .badInternetConnection
	 }
	 
	 return .somethingWentWrong
  }
  
  private static func isInternetConnectionError(_ error: Error) -> Bool {
	 guard let urlError = error as? URLError else {
		let nsError = error as NSError
		return nsError.domain == NSURLErrorDomain
	 }
	 
	 switch urlError.code {
	 case .notConnectedToInternet,
			.networkConnectionLost,
			.cannotFindHost,
			.cannotConnectToHost,
			.dnsLookupFailed,
			.timedOut:
		return true
	 default:
		return false
	 }
  }
}
