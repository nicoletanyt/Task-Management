//
//  NewTaskView.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import SwiftUI

struct NewTaskView: View {
	@EnvironmentObject var taskManager: TaskManager
	@Environment(\.presentationMode) var presentationMode
	@State var taskTitle = ""
	@State var priorityLevel: PriorityLevel = .NIL
	@State var isAlertActive = false
	
    var body: some View {
		VStack {
			Text("Create New Task")
				.font(.headline)
			Form {
				TextField("Enter the text title", text: $taskTitle)
					.onSubmit {
						createTask()
					}
				Picker("Pick a priority level", selection: $priorityLevel) {
					ForEach(PriorityLevel.allCases, id: \.self) { item in
						Text(item.rawValue.capitalized)
					}
				}
			}
			.padding()
			//Done Button
			Button {
				if (taskTitle == "") {
					isAlertActive = true
				} else {
					createTask()
				}
			} label: {
				HStack {
					Text("Create")
					Image(systemName: "checkmark")
				}
				.padding()
			}
		}
		.padding()
		.frame(width: (NSApplication.shared.windows.first?.frame.width)! - 100, height: (NSApplication.shared.windows.first?.frame.height)! - 100)
		.alert(isPresented: $isAlertActive) {
			Alert(title: Text("Please enter a title for the task."), message: nil, dismissButton: .cancel(Text("Ok")))
		}
    }
	
	func createTask() {
		let newTask = Task(type: .parent, title: taskTitle, dueDate: Date.now, priority: priorityLevel)
		taskManager.totalTasks.append(newTask) //Total Tasks
		print("Added new task \(taskManager.totalTasks.count)")
		presentationMode.wrappedValue.dismiss()
	}
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
    }
}
