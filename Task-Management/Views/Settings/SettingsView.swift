//
//  SettingsView.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject var user: User
	
	var body: some View {
		List {
//			Section {
//				//TODO: ADD A PICKER FOR START PAGE CONTENT (TUTORIAL? ALL TASKS? FOCUS MODE?)
//			} header: {
//				Text("General")
//			}
			Section {
				Toggle("Focus Mode: ", isOn: $user.focusMode)
					.toggleStyle(.switch)
				HStack {
					Text("Duration (In Minutes): ")
					Spacer()
					HStack {
						TextField("", value: $user.focusDuration, formatter: NumberFormatter())
						Stepper("", value: $user.focusDuration)
					}
					.frame(width: 50)
				}
			} header: {
				Text("Focus Mode Preferences")
			}
			
//			Section {
//				//TODO: ADD A COLOUR PICKER FOR COLOUR SCHEME
//				//TODO: SLIDER/STEPPER FOR FONT SIZE
//			} header: {
//				Text("Appearance")
//			}
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
