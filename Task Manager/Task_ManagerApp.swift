//
//  Task_ManagerApp.swift
//  Task Manager
//
//  Created by Manuchim Oliver on 18/03/2023.
//

import SwiftUI

@main
struct Task_ManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
