//
//  User.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import Foundation

class User: ObservableObject {
	@Published var isTimerOn = false
	@Published var focusDuration = 30 //In Minutes
	@Published var timeLeft = 30 // In Seconds
	@Published var focusMode = false
	@Published var focusTasks: [Task] = []
	
	func endTimer() {
		self.isTimerOn = false
		self.focusMode = false
		self.timeLeft = self.focusDuration * 60
	}
}
