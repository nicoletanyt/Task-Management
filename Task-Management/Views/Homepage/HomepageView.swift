//
//  HomepageView.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import SwiftUI

struct HomepageView: View {
	@EnvironmentObject var taskManager: TaskManager
	@EnvironmentObject var user: User
	@State var highPrTasks: [Task] = []
	@State var overdueTasks: [Task] = []
	
	var body: some View {
		ScrollView {
			Widget(tasksCount: highPrTasks.count, title: "High Priority Tasks", taskTitles: taskManager.returnTitle(tasks: highPrTasks), widgetColor: Color.red)
				.padding()
			Widget(tasksCount: overdueTasks.count, title: "Overdue Tasks", taskTitles: taskManager.returnTitle(tasks: taskManager.returnOverdue()), widgetColor: Color.indigo)
				.padding(.horizontal)
		}
		.onAppear {
			highPrTasks = taskManager.sortTasks(priority: .high)
			overdueTasks = taskManager.returnOverdue()
		}
		.onChange(of: taskManager.totalTasks) { _ in
			taskManager.uncompletedTasks = taskManager.returnUncompleted(unsortedTasks: taskManager.totalTasks)
			highPrTasks = taskManager.sortTasks(priority: .high)
			overdueTasks = taskManager.returnOverdue()
		}
	}
}

struct Widget: View {
	var tasksCount: Int
	var title: String
	var taskTitles: [String]
	var widgetColor: Color
	
	var body: some View {
		HStack {
			VStack {
				HStack {
					Text("\(tasksCount)")
						.font(.title.bold().italic())
					Spacer()
				}
				HStack {
					Text(title)
						.font(.headline)
					Spacer()
				}
			}
			.padding()
			List {
				ForEach(taskTitles, id: \.self) { taskTitle in
					Text(taskTitle)
				}
				.listRowSeparator(.visible)
			}
			.scrollContentBackground(.hidden)
		}
		.padding()
		.background(widgetColor)
		.cornerRadius(15)
	}
}

struct HomepageView_Previews: PreviewProvider {
	static var previews: some View {
		HomepageView()
	}
}
