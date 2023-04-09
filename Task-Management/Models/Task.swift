//
//  Task.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import Foundation

struct Task: Identifiable, Equatable {
	var id = UUID()
	var type: TaskType
	var title: String
	var isCompleted: Bool = false
	var dueDate: Date
	var priority: PriorityLevel
	var children: [Task] = []
}

enum PriorityLevel: String, CaseIterable {
	case high, medium, low, NIL
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
}
