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
	@State var parentTasks: [Task] = []
	@State var childTasks: [Task] = []
	@State var filter = false
	@State var chosenType: TaskType = .Task
	
	var body: some View {
		NavigationStack {
			VStack {
				List {
					if !filter {
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
					} else {
						if chosenType == .SubTask {
							SectionView(editTask: $editTask, prTasks: $childTasks)
						} else {
							SectionView(editTask: $editTask, prTasks: $parentTasks)
						}
					}
				}
				.onAppear {
					loadTasks()
				}
				.onChange(of: taskManager.totalTasks) { _ in
					taskManager.uncompletedTasks = taskManager.returnUncompleted(unsortedTasks: taskManager.totalTasks)
					loadTasks()
				}
				.onChange(of: chosenType) { newType in
					if newType == .SubTask {
						childTasks = taskManager.childTasks(tasks: taskManager.uncompletedTasks)
					} else {
						parentTasks = taskManager.parentTasks(tasks: taskManager.uncompletedTasks)
					}
				}
				Spacer()
				HStack {
					Button {
						filter.toggle()
					} label: {
						Image(systemName: "line.3.horizontal.decrease.circle.fill")
							.buttonStyle(.plain)
					}
					if filter {
						Picker("", selection: $chosenType) {
							ForEach(TaskType.allCases, id: \.self) { item in
								Text("Show all \(item.rawValue)s")
							}
						}
						.pickerStyle(.segmented)
					}
					Spacer()
				}
				.padding()
			}
		}
	}
	func loadTasks() {
		highPrTasks = taskManager.sortTasks(priority: .high)
		medPrTasks = taskManager.sortTasks(priority: .medium)
		lowPrTasks = taskManager.sortTasks(priority: .low)
		childTasks = taskManager.childTasks(tasks: taskManager.uncompletedTasks)
		parentTasks = taskManager.parentTasks(tasks: taskManager.uncompletedTasks)
	}
}

struct SectionView: View {
	@EnvironmentObject var taskManager: TaskManager
	@Binding var editTask: Bool
	@Binding var prTasks: [Task]
	
	var body: some View {
		ForEach($prTasks) { $task in
			HStack {
				TaskView(task: $task, isEdit: $editTask)
					.onTapGesture {
						task.isCompleted.toggle()
						updateTask(task: task)
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
	func updateTask(task: Task) {
		if task.type == .SubTask {
			if let parentIndex = taskManager.totalTasks.firstIndex(where: {$0.children.contains(where: {$0.id == task.id})}) {
				if let taskIndex = taskManager.totalTasks[parentIndex].children.firstIndex(where: {$0.id == task.id}) {
					taskManager.totalTasks[parentIndex].children[taskIndex].isCompleted.toggle()
				}
			}
		}
		if let index = taskManager.totalTasks.firstIndex(where: {$0.id == task.id}) {
			taskManager.totalTasks[index].isCompleted.toggle()
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
