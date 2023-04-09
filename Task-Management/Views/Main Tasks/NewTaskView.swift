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
	@State var priorityLevel: PriorityLevel = .auto
	@State var datePicked: Date = Date.now
	@State var isAlertActive = false
	@State var parent: Task?
	
    var body: some View {
		VStack {
			Text((parent == nil) ? "Create New Task" : "Create New Subtask in \(parent!.title)")
				.font(.headline)
			Form {
				TextField("Enter the title", text: $taskTitle)
					.onSubmit {
						createTask()
					}
				DatePicker("Enter the due date", selection: $datePicked, displayedComponents: .date)
					.datePickerStyle(.field)
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
		if parent == nil {
			let newParent = Task(type: .parent, title: taskTitle, dueDate: datePicked, priority: priorityLevel)
			taskManager.totalTasks.append(newParent)
		} else {
			// Create new Subtask
			let newChild = Task(type: .child, title: taskTitle, dueDate: datePicked, priority: priorityLevel)
			taskManager.totalTasks.append(newChild)
			if let index = taskManager.totalTasks.firstIndex(where: {$0.id == parent?.id}) {
				taskManager.totalTasks[index].children.append(newChild)
			}
		}
		presentationMode.wrappedValue.dismiss()
	}
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
    }
}
