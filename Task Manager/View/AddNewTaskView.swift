//
//  AddnewTaskView.swift
//  Task Manager
//
//  Created by Manuchim Oliver on 18/03/2023.
//

import SwiftUI

struct AddNewTaskView: View {
    @EnvironmentObject var taskModel: TaskViewModel
    @Namespace var animation
    
    @Environment(\.self) var env
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Task Details")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        env.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(env.colorScheme == .dark ? .white : .black)
                    }
                }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Choose a color")
                    .font(.callout)
                    .foregroundColor(.gray)
                
                let colors: [String] = ["Yellow","Green","Blue","Purple","Red","Orange"]
                
                HStack(spacing: 15) {
                    ForEach(colors, id: \.self) {color in
                        Circle()
                            .fill(Color(color))
                            .frame(width: 25, height: 25)
                            .background{
                                if taskModel.taskColor == color {
                                    Circle()
                                        .strokeBorder(.gray)
                                        .padding(-3)
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                taskModel.taskColor = color
                            }
                    }
                }
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            //change this to leading to align the view to the left
            .padding(.top, 20)
            
            Divider()
                .padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Deadline")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
                
                Text(taskModel.taskDeadline.formatted(date: .abbreviated, time: .omitted) + ", " + taskModel.taskDeadline.formatted(date: .omitted, time: .shortened))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .bottomTrailing){
                Button {
                    taskModel.showDatePicker.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(env.colorScheme == .dark ? .white : .black)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Title")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
                
                TextField("Enter a task title", text: $taskModel.taskTitle)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                    .padding(.top)
                    .font(.callout)
            }
            .padding(.top)
            Divider()
           
            /// - Sample task types
            let taskTypes: [String] = ["Basic", "Urgent", "Important"]
            VStack(alignment: .leading, spacing: 12) {
                Text("Priority")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
                
                HStack (spacing: 12) {
                    ForEach(taskTypes, id: \.self) { type in
                        Text(type)
                            .font(.callout)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(env.colorScheme == .light ? taskModel.taskType == type ? .white : .black : taskModel.taskType == type ? .black : .white)
                            .background{
                                if taskModel.taskType == type {
                                    Capsule()
                                        .fill(env.colorScheme == .dark ? .white : .black)
                                        .matchedGeometryEffect(id: "TYPE", in: animation)
                                } else {
                                    Capsule()
                                        .strokeBorder(env.colorScheme == .dark ? .white : .black)
                                }
                            }
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation{taskModel.taskType = type}
                            }
                    }
                }
                .padding(.top, 8)
            }
            .padding(.vertical, 10)
            
            Divider()
            
            Button {
                /// - Close view if task is successfully added
                if taskModel.addTask(context: env.managedObjectContext) {
                    env.dismiss()
                }
            } label : {
                Text("Save Task")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(env.colorScheme == .dark ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(env.colorScheme == .dark ? .white : .black)
                    }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 10)
            .disabled(taskModel.taskTitle == "")
            .opacity(taskModel.taskTitle == "" ? 0.6 : 1)
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .overlay {
            ZStack{
                if taskModel.showDatePicker {
                   Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture{
                            taskModel.showDatePicker = false
                        }
                    
                    DatePicker.init("", selection: $taskModel.taskDeadline, in: Date.now...Date.distantFuture)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                        .background(env.colorScheme == .light ? .white : .black, in: RoundedRectangle(cornerRadius: 12))
                        .padding()
                }
            }
            .animation(.easeInOut, value: taskModel.showDatePicker)
        }
    }
}

struct AddnewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTaskView()
            .environmentObject(TaskViewModel())
    }
}
