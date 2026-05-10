//
//  CookingIdentity.swift
//  CoockingApp
//
//  Created by user on 10.05.2026.
//

import SwiftUI

struct ProfileOptionPicker<Option: ProfilePickerOption>: View where Option.AllCases: RandomAccessCollection {
  @Binding var selection: Option
  
    var body: some View {
		VStack{
		  Picker("", selection: $selection) {
			 ForEach(Option.allCases){item in
				let selected = selection == item
				Text(item.text)
				  .font(.headline.weight(selected ? .semibold : .medium))
				  .foregroundStyle(selected ? .primaryAction : .accentCard)
				  .tag(item)
			 }
		  }
		  .pickerStyle(.wheel)

		}
    }
}

#Preview {
  ProfileOptionPicker(selection: .constant(CookingIdentityEnum.baker))
}
