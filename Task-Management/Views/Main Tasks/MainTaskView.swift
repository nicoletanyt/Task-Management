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
	@State var highPrTasks: [Task] = []
	@State var medPrTasks: [Task] = []
	@State var lowPrTasks: [Task] = []
	
	var body: some View {
		NavigationStack {
			List {
				Section {
					SectionView(editTask: $editTask, prTasks: $highPrTasks)
				} header: {
					Text("High Priority")
				}
				Section {
					SectionView(editTask: $editTask, prTasks: $medPrTasks)
				} header: {
					Text("Medium Priority")
				}
				Section {
					SectionView(editTask: $editTask, prTasks: $lowPrTasks)
				} header: {
					Text("Low Priority")
				}
			}
			.onAppear {
				highPrTasks = taskManager.sortTasks(priority: .high)
				medPrTasks = taskManager.sortTasks(priority: .medium)
				lowPrTasks = taskManager.sortTasks(priority: .low)
			}
			.onChange(of: taskManager.totalTasks) { _ in
				taskManager.uncompletedTasks = taskManager.returnUncompleted(unsortedTasks: taskManager.totalTasks)
				highPrTasks = taskManager.sortTasks(priority: .high)
				medPrTasks = taskManager.sortTasks(priority: .medium)
				lowPrTasks = taskManager.sortTasks(priority: .low)
			}
		}
	}
}

struct SectionView: View {
	@Binding var editTask: Bool
	@Binding var prTasks: [Task]
	
	var body: some View {
		ForEach($prTasks) { $task in
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
						TaskDetailView(task: $task)
							.navigationTitle("Title: \(task.title)")
					} label: {
						Image(systemName: "arrowtriangle.forward")
					}
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
