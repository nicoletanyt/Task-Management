//
//  TaskDetailView.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import SwiftUI

struct TaskDetailView: View {
	@EnvironmentObject var taskManager: TaskManager
	@Binding var task: Task
	@State var taskChildren: [Task] = []
	@State var createNew = false
	
    var body: some View {
		VStack {
			Header(task: $task)
			Divider()
			List {
				Text("Subtasks: ")
					.font(.headline)
				ForEach($taskChildren) { $subTask in
					SubTaskView(subTask: $subTask, datePicked: $subTask.dueDate, priority: $subTask.priority, parentTask: task)
				}
			}
			.onAppear {
				updateChildren()
			}
			.onChange(of: getParent()) { _ in
				updateChildren()
			}
			Button {
				createNew = true
			} label: {
				HStack {
					Image(systemName: "plus")
					Text("Create Subtask")
				}
			}
			.padding(.top, 0)
			.padding()
		}
		.sheet(isPresented: $createNew) {
			NewTaskView(parent: task)
		}
    }
	
	func getParent() -> Task {
		return taskManager.totalTasks.first(where: {$0.id == task.id})!
	}
	func updateChildren() {
		if let parentTask = taskManager.totalTasks.first(where: {$0.id == task.id}) {
			taskChildren = parentTask.children
		}
	}
}

struct SubTaskView: View {
	@EnvironmentObject var taskManager: TaskManager
	@Binding var subTask: Task
	@State var isDetailShown = false
	@State var editTitle = false
	@Binding var datePicked: Date
	@Binding var priority: PriorityLevel
	var parentTask: Task
	
	var body: some View {
			DisclosureGroup {
				HStack {
					DatePicker("Due: ", selection: $datePicked)
						.datePickerStyle(.compact)
					Picker("Priority: ", selection: $priority) {
						ForEach(PriorityLevel.allCases, id: \.self) { item in
							Text(item.rawValue.capitalized)
						}
					}
				}
				.font(.body)
				.onChange(of: datePicked) { newDate in
					subTask.dueDate = newDate
					updateSubTask()
				}
				.onChange(of: priority) { newPriority in
					subTask.priority = newPriority
					updateSubTask()
				}
			} label: {
				TaskView(task: $subTask, isEdit: $editTitle)
					.onTapGesture {
						subTask.isCompleted.toggle()
					}
					.contextMenu {
						Button {
							editTitle = true
						} label: {
							Label("Rename", systemImage: "square.and.pencil")
						}
					}
					.onSubmit {
						updateSubTask()
					}
			}
	}
	
	func updateSubTask() {
		// Update in parent task
		if let parentIndex = taskManager.totalTasks.firstIndex(where: {$0.id == parentTask.id}) {
			if let childIndex = taskManager.totalTasks[parentIndex].children.firstIndex(where: {$0.id == subTask.id}) {
				taskManager.totalTasks[parentIndex].children[childIndex] = subTask
			}
		}
		// Update in total task
		if let index = taskManager.totalTasks.firstIndex(where: {$0.id == subTask.id}) {
			taskManager.totalTasks[index] = subTask
		}
	}
}

struct Header: View {
	@EnvironmentObject var taskManager: TaskManager
	@Binding var task: Task
	
	var body: some View {
		HStack {
			VStack {
				DatePicker("Due Date:", selection: $task.dueDate)
					.datePickerStyle(.compact)
					.bold()
				Picker("Priority level: ", selection: $task.priority) {
					ForEach(PriorityLevel.allCases, id: \.self) { item in
						Text(item.rawValue.capitalized)
					}
				}
				.bold()
			}
			.frame(width: ((NSApplication.shared.windows.first?.frame.width)!)/2 )
			.padding()
			.onChange(of: task, perform: { updatedTask in
				if let index = taskManager.totalTasks.firstIndex(where: {$0.id == updatedTask.id})  {
					if (taskManager.totalTasks[index] != updatedTask) {
						taskManager.totalTasks[index] = updatedTask
					}
				}
			})
			Spacer()
			Text("\(task.children.count)")
				.font(.system(size: 50))
				.padding()
		}
	}
}

//struct TaskDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskDetailView()
//    }
//}
