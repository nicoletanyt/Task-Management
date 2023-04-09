//
//  TaskDetailView.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import SwiftUI

struct TaskDetailView: View {
	@EnvironmentObject var taskManager: TaskManager
	@State var task: Task
	@State var taskChildren: [Task] = []
	
    var body: some View {
		VStack {
			Header(task: $task)
			Divider()
			List {
				ForEach(taskChildren) { subTask in
					Text(subTask.title)
				}
			}
			.onAppear {
				if let parentTask = taskManager.totalTasks.first(where: {$0.id == task.id}) {
					taskChildren = parentTask.children
				}
			}
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
