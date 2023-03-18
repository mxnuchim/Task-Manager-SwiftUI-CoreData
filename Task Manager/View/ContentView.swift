//
//  ContentView.swift
//  Task Manager
//
//  Created by Manuchim Oliver on 18/03/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        NavigationView{
            HomeView()
                .navigationTitle("Tasks")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
