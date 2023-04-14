//
//  HomepageView.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import SwiftUI

struct HomepageView: View {
	var body: some View {
		ScrollView {
			Widget(tasksCount: 1, title: "Due Tomorrow:", taskTitles: ["Homework", "Coffee", "Now"], widgetColor: Color.indigo)
				.padding()
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
