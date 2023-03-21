//
//  HomeView.swift
//  Task Manager
//
//  Created by Manuchim Oliver on 18/03/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject var taskModel: TaskViewModel = .init()
    @Namespace var animation
    @Environment(\.self) var env
    
    // - fetch Tasks
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack (alignment: .leading, spacing: 8) {
                    Text("Welcome back 👋")
                        .font(.callout)
                    
                    Text("Your tasks")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
                
                CustomBar()
                    .padding(.top, 5)
                
                // - Task View goes here
                // - Renders all the tasks nicely
                TaskView()
            }
            .padding(.horizontal)
        }
        .overlay(alignment: .bottom) {
            Button {
                taskModel.openTaskEdit.toggle()
            } label: {
                Label {
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(env.colorScheme == .dark ? .black : .white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(env.colorScheme == .dark ? .white : .black, in: Capsule())
            }
            .frame(maxWidth: .infinity)
        }
        .fullScreenCover(isPresented: $taskModel.openTaskEdit) {
            taskModel.resetTaskData()
        } content: {
            AddNewTaskView()
                .environmentObject(taskModel)
        }
    }
    
    @ViewBuilder
    func CustomBar()-> some View {
        let tabs = ["Today", "Upcoming", "Complete", "Missed"]
        
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self){ tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(env.colorScheme == .light ? taskModel.currentTab == tab ? .white : .black : taskModel.currentTab == tab ? .black : .white)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background{
                        if taskModel.currentTab == tab {
                            Capsule()
                                .fill(env.colorScheme == .dark ? .white : .black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation{taskModel.currentTab = tab}
                    }
            }
        }
    }
    
    @ViewBuilder
    func TaskView() -> some View {
        LazyVStack(spacing: 20){
            DynamicFilteredView(currentTab: taskModel.currentTab) { (task: Task) in
                TaskRowView(task: task)
            }
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func TaskRowView(task: Task) -> some View {
        VStack (alignment: .leading, spacing: 10) {
            HStack {
                Text(task.type ?? "")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.3))
                    }
                
                Spacer()
                
                
                HStack(spacing: 25){
                    if !task.isCompleted {
                        Button {
                            taskModel.editTask = task
                            taskModel.openTaskEdit = true
                            taskModel.setupTask()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    
                    
                    Button {
                        env.managedObjectContext.delete(task)
                        try? env.managedObjectContext.save()
                        env.dismiss()
                    } label: {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
            }
            
            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.vertical, 10)
            
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !task.isCompleted && taskModel.currentTab != "Missed" {
                    HStack(spacing: 15){
                        Text("Incomplete")
                        Button {
                            task.isCompleted = true
                            try? env.managedObjectContext.save()
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                } else {
                    HStack(spacing: 10) {
                        Text("Completed")
                        Button {
                            
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
