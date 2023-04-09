//
//  Task.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import Foundation

struct Task: Identifiable, Hashable, Equatable {
	var id = UUID()
	var type: TaskType
	var title: String
	var isCompleted: Bool = false
	var dueDate: Date
	var priority: PriorityLevel
	var children: [Task] = []
}

enum PriorityLevel: String, CaseIterable {
	case high, medium, low, auto
}

enum TaskType {
	case parent, child
}

class TaskManager: ObservableObject {
	@Published var totalTasks: [Task] = []
	@Published var uncompletedTasks: [Task] = []
	
	init() {
		self.uncompletedTasks = self.totalTasks.filter({!$0.isCompleted})
	}
	
	func parentTasks(tasks: [Task]) -> [Task] {
		return tasks.filter({$0.type == .parent})
	}
	func priorityTask(unsortedTasks: [Task], priorityLevel: PriorityLevel) -> [Task] {
		return unsortedTasks.filter({$0.priority == priorityLevel && !$0.isCompleted})
	}
	func returnUncompleted() -> [Task] {
		return self.totalTasks.filter({!$0.isCompleted})
	}
	func completedTasks(tasks: [Task]) -> [Task] {
		return tasks.filter({$0.isCompleted})
	}
	
	func sortTasks(priority: PriorityLevel) -> [Task] {
		var startDate = Date()
		var dayDist = -1
		
		switch (priority) {
		case .high:
			dayDist = 1 // startDate is today
			break
		case .medium:
			dayDist = 2
			startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)! // Start after .high date
			break
		case .low:
			dayDist = 3
		default:
			break
		}
		
		let endDate = Calendar.current.date(byAdding: .day, value: dayDist, to: startDate)!
		
		// Sorts the tasks that the user already defined as high priority
		var priorityTasks: [Task] = self.priorityTask(unsortedTasks:  self.uncompletedTasks, priorityLevel: priority)
		
		for task in self.uncompletedTasks {
			if (priority == .low) {
				// Adds work that is >= 3 days later
				if task.dueDate >= endDate {
					priorityTasks.append(task)
				}
			} else {
				if (priority == .high) {
					// Adds overdue work
					if task.dueDate <= startDate{
						priorityTasks.append(task)
					}
				}
				if (startDate...endDate).contains(task.dueDate){
					priorityTasks.append(task)
				}
			}
		}
		return priorityTasks
	}
}
