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
	
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


struct MainTaskView_Previews: PreviewProvider {
    static var previews: some View {
        MainTaskView()
    }
}
