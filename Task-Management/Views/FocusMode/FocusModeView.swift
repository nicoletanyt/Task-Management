//
//  FocusModeView.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import SwiftUI

struct FocusModeView: View {
	@EnvironmentObject var taskManager: TaskManager
	@EnvironmentObject var user: User
	
	//	@State var user.focusTasks: [Task] = []
	@State var finishSession = false
	
	var body: some View {
		HStack {
			TimerView()
			//.frame(width: ((NSApplication.shared.windows.first?.frame.width)!)/2  - 120, height: (NSApplication.shared.windows.first?.frame.height)! - 100)
				.frame(width: 300, height: 100)
			VStack {
				if !user.isTimerOn {
					Text("Select a list of tasks to complete during this focus period.")
						.font(.headline)
						.padding()
				}
				List {
					if (user.isTimerOn) {
						ForEach($user.focusTasks) { $task in
							TaskSelectView(task: $task, finishSession: $finishSession)
						}
					}
					else {
						ForEach($taskManager.uncompletedTasks) { $task in
							TaskSelectView(task: $task, finishSession: $finishSession)
						}
					}
				}
				.onAppear {
					taskManager.uncompletedTasks = taskManager.returnUncompleted()
				}
				.onChange(of: taskManager.totalTasks) { updatedAll in
					taskManager.uncompletedTasks = taskManager.returnUncompleted()
				}
				.onChange(of: user.timeLeft) { timeLeft in
					if timeLeft == 0 {
						finishSession = true
					}
				}
				.alert(isPresented: $finishSession) { // Alert when all tasks have been completed
					Alert(title: Text("Session Finished"), message: user.focusTasks.isEmpty ? Text("Good Job, you finished all your tasks!") : Text("You have \(user.focusTasks.count) task left, try to finish them next time!"), dismissButton: .default(Text("Done"), action: {
						// End Timer
						finishSession = true
						user.endTimer()
					}))
				}
			}
		}
	}
}

struct TaskSelectView: View {
	@EnvironmentObject var taskManager: TaskManager
	@EnvironmentObject var user: User
	@Binding var task: Task
	@State var isSelected = false
	@Binding var finishSession: Bool
	
	var body: some View {
		HStack {
			if user.isTimerOn {
				Image(systemName: task.isCompleted ? "circle.fill" : "circle")
			} else {
				Image(systemName: isSelected  ? "checkmark.square.fill" : "square")
			}
			Text(task.title)
		}
		.onTapGesture {
			if user.isTimerOn {
				//Mark task as complete
				task.isCompleted = true
				removeTask(selecting: false)
			} else {
				//Select Task
				isSelected.toggle()
				if (isSelected) {
					user.focusTasks.append(task)
				} else {
					removeTask(selecting: true)
				}
			}
		}
		.onAppear {
			isSelected = false
		}
	}
	
	func removeTask(selecting: Bool) {
		if (!selecting) {
			// Mark task as completed
			markTaskComplete()
		}
		if let index = user.focusTasks.firstIndex(where: { $0.id == task.id }) {
			user.focusTasks.remove(at: index)
			if (!selecting) {
				if user.focusTasks.isEmpty {
					// End Timer
					finishSession = true
					user.endTimer()
				}
			}
		}
	}
	
	func markTaskComplete() {
		if let index = taskManager.totalTasks.firstIndex(where: {$0.id == task.id}) {
			taskManager.totalTasks[index].isCompleted = true
		}
		if task.type == .child {
			// If it's a subtask, mark it as complete in the parentTask child
			if let parentIndex = taskManager.totalTasks.firstIndex(where: {$0.children.contains(where: {$0.id == task.id})}) {
				if let childIndex = taskManager.totalTasks[parentIndex].children.firstIndex(where: {$0.id == task.id}) {
					taskManager.totalTasks[parentIndex].children[childIndex].isCompleted = true
				}
			}
		}
	}
}

struct FocusModeView_Previews: PreviewProvider {
    static var previews: some View {
        FocusModeView()
    }
}
