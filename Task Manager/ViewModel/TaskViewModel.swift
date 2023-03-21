//
//  TaskViewModel.swift
//  Task Manager
//
//  Created by Manuchim Oliver on 18/03/2023.
//

import Foundation
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "Today"
    
    ///- Task Properties
    @Published var openTaskEdit: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Basic"
    @Published var showDatePicker: Bool = false
    
    @Published var editTask: Task?
    
    func addTask(context: NSManagedObjectContext)-> Bool {
        
        //Updating existing Task data in CoreData
        var task: Task!
        if let editTask = editTask {
            task = editTask
        } else {
            task = Task(context: context)
        }
        
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
        if let x = try? context.save() {
            print(x)
            return true
        }
        
        return false
    }
    
    func resetTaskData (){
        taskType = "Basic"
        taskColor = "Yellow"
        taskTitle = ""
        taskDeadline = Date()
    }
    
    func setupTask(){
        if let editTask = editTask {
            taskType = editTask.type ?? "Basic"
            taskColor = editTask.color ?? "Yellow"
            taskTitle = editTask.title ?? ""
            taskDeadline = editTask.deadline ?? Date()
        }
    }
}
