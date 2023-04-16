//
//  TaskDetailView.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import SwiftUI

struct TaskDetailView: View {
	@EnvironmentObject var taskManager: TaskManager
	@Environment(\.presentationMode) var presentationMode
	@Binding var task: Task
	@State var taskChildren: [Task] = []
	@State var createNew = false
	@State var deleted = false
	
    var body: some View {
		VStack {
			Header(task: $task)
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
				if !deleted {
					updateChildren()
				}
			}
			HStack {
				Button {
					createNew = true
				} label: {
					HStack {
						Image(systemName: "plus")
						Text("Create Subtask")
					}
				}
				Button {
					deleteTask()
					deleted = true
					presentationMode.wrappedValue.dismiss()
				} label: {
					HStack {
						Image(systemName: "trash.fill")
						Text("Delete Task")
					}
					.foregroundColor(Color.red)
				}
			}
			
			.padding(.top, 0)
			.padding()
		}
		.sheet(isPresented: $createNew) {
			NewTaskView(parent: task)
		}
    }
	
	func getParent() -> Task? {
		return taskManager.totalTasks.first(where: {$0.id == task.id})
	}
	func updateChildren() {
		if let parentTask = taskManager.totalTasks.first(where: {$0.id == task.id}) {
			taskChildren = taskManager.returnUncompleted(unsortedTasks: parentTask.children)
		}
	}
	func deleteTask() {
		// removes from total database
		if task.type == .SubTask {
			if let parentIndex = taskManager.totalTasks.firstIndex(where: {$0.children.contains(where: {$0.id == task.id})}) {
				taskManager.totalTasks[parentIndex].children.removeAll(where: {$0.id == task.id})
			}
		} else {
			for i in task.children {
				// remove all the children too
				taskManager.totalTasks.removeAll(where: {$0.id == i.id})
			}
		}
		taskManager.totalTasks.removeAll(where: {$0.id == task.id})
		print("Task Deleted")
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
		HStack {
			Button {
				subTask.isCompleted.toggle()
				updateSubTask()
			} label: {
				Image(systemName: subTask.isCompleted ? "checkmark.circle.fill" : "circle")
			}
			.buttonStyle(.plain)
			if editTitle {
				TextField(subTask.title, text: $subTask.title)
					.textFieldStyle(.squareBorder)
					.onSubmit {
						editTitle = false
					}
			} else {
				Text(subTask.title)
					.strikethrough(subTask.isCompleted)
			}
			Spacer()
			HStack {
				DatePicker("", selection: $subTask.dueDate, displayedComponents: .date)
					.backgroundStyle(.clear)
					.border(.clear)
					.datePickerStyle(.field)
				Picker("", selection: $subTask.priority) {
					ForEach(PriorityLevel.allCases, id: \.self) { item in
						Text(item.rawValue.capitalized)
					}
				}
				.pickerStyle(.menu)
				.backgroundStyle(.clear)
				.border(.clear)
			}
			.frame(width: (NSApplication.shared.windows.first?.frame.width)!/5)
		}
		.onChange(of: subTask, perform: { _ in
			updateSubTask()
		})
		.contextMenu {
			Button {
				editTitle = true
			} label: {
				Label("Rename", systemImage: "square.and.pencil")
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
	@State var childrenCount = 0
	
	var body: some View {
		HStack {
			VStack {
				DatePicker("Due Date:", selection: $task.dueDate, displayedComponents: .date)
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
			Text("\(childrenCount)")
				.font(.system(size: 50))
				.padding()
		}
		.onChange(of: task.children) { newChildren in
			childrenCount = taskManager.returnUncompleted(unsortedTasks: newChildren).count
		}
	}
}

//struct TaskDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskDetailView()
//    }
//}
