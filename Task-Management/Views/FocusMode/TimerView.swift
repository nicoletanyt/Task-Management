//
//  TimerView.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import SwiftUI

struct TimerView: View {
	@EnvironmentObject var user: User
	@State var isActiveAlert = false
	
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	var body: some View {
		VStack {
			Text(formatTime(time: user.timeLeft))
				.font(.title)
				.onReceive(timer) { _ in
					if user.isTimerOn && user.timeLeft > 0 {
						user.timeLeft -= 1
					}
				}
			Button {
				if (!user.focusTasks.isEmpty) {
					//Start the timer and turn on focus mode
					user.isTimerOn = true
					user.focusMode = true
				} else {
					isActiveAlert = true // activates the alert that no tasks were selected
				}
			} label: {
				Text("Start")
					.padding()
					.background(Color.accentColor)
					.cornerRadius(10)
			}
			.buttonStyle(.plain)
			.padding()
			.opacity(user.isTimerOn ? 0 : 100)
		}
		.onAppear {
			user.timeLeft = user.focusDuration * 60
		}
		.alert(isPresented: $isActiveAlert) {
			Alert(title: Text("Please select a task first."), message: nil, dismissButton: .cancel(Text("Done")))
		}
	}
	func formatTime(time: Int) -> String {
		let minutes = time / 60
		let seconds = time % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}
}
