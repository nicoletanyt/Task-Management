//
//  ContentView.swift
//  Task-Management
//
//  Created by NICOLE TAN YITONG stu on 9/4/23.
//

import SwiftUI

struct ContentView: View {
	
	@StateObject var taskManager = TaskManager()
	@StateObject var user = User()
	
	@State var isSidebarActive = true // Sidebar is shown on default
	@State var isCreateNew = false
	
	var body: some View {
		VStack {
			NavigationView {
				if !user.focusMode {
					SideBar()
				}
				VStack {
					FocusModeView()
				}
			}
			.environmentObject(taskManager)
			.environmentObject(user)
			.onChange(of: user.focusMode, perform: { _  in
				// Dismisses the sidebar if it's active while focus mode is on
				if isSidebarActive && user.focusMode || !isSidebarActive && !user.focusMode {
					toggleSidebar()
				}
			})
			.toolbar {
				if !user.focusMode {
					ToolbarItem(placement: .navigation) {
						Button {
							toggleSidebar()
						} label: {
							Image(systemName: "sidebar.leading")
						}
					}
				}
				ToolbarItem(placement: .primaryAction) {
					//Adds new task
					Button {
						isCreateNew = true
					} label: {
						Image(systemName: "plus")
					}
					.keyboardShortcut("n", modifiers: [.shift, .command])
				}
			}
			.sheet(isPresented: $isCreateNew) {
				NewTaskView()
					.environmentObject(taskManager)
			}
		}
	}
	
	private func toggleSidebar() {
		isSidebarActive.toggle()
#if os(iOS)
#else
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
#endif
	}
}

struct SideBar: View {
	@EnvironmentObject var taskManager: TaskManager
	@EnvironmentObject var user: User
	
	var body: some View {
		List {
			NavigationLink {
				MainTaskView()
					.navigationTitle("All Tasks")
			} label: {
				HStack {
					Image(systemName: "list.bullet")
					Text("All Tasks")
				}
			}
			Divider()
			NavigationLink {
				FocusModeView()
					.navigationTitle("Focus Mode")
			} label: {
				HStack {
					Image(systemName: "sparkles")
					Text("Focus Mode")
				}
			}
			Divider()
			NavigationLink {
				SettingsView()
					.navigationTitle("Settings")
			} label: {
				HStack {
					Image(systemName: "gearshape.fill")
					Text("Settings")
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
