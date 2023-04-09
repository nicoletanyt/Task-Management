//
//  MainTaskView.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import SwiftUI

struct MainTaskView: View {
	@EnvironmentObject var taskManager: TaskManager
	@EnvironmentObject var user: User
	@State var editTask = false
	
    var body: some View {
		NavigationStack {
			List {
				Section {
					ForEach($taskManager.uncompletedTasks) { $task in
						HStack {
							TaskView(task: $task, isEdit: $editTask)
								.onTapGesture {
									task.isCompleted.toggle()
								}
								.contextMenu {
									Button {
										editTask = true
									} label: {
										Label("Rename", systemImage: "square.and.pencil")
									}
								}
							Spacer()
							if !task.isCompleted && !editTask{
								NavigationLink {
									TaskDetailView(task: task)
										.navigationTitle("Title: \(task.title)")
								} label: {
									Image(systemName: "arrowtriangle.forward")
								}
							}
						}
					}
				} header: {
					Text("High Priority")
				}
			}
		}
    }
}

struct TaskView: View {
	@Binding var task: Task
	@Binding var isEdit: Bool
	var body: some View {
		HStack {
			Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
			if isEdit {
				TextField(task.title, text: $task.title)
					.textFieldStyle(.roundedBorder)
					.onSubmit {
						isEdit = false
					}
			} else {
				Text(task.title)
					.strikethrough(task.isCompleted)
			}
		}
	}
}


struct MainTaskView_Previews: PreviewProvider {
    static var previews: some View {
        MainTaskView()
    }
}
