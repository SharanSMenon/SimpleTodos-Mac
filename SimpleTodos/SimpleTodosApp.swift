//
//  SimpleTodosApp.swift
//  SimpleTodos
//
//  Created by Sharan Sajiv Menon on 8/2/21.
//

import SwiftUI

@main
struct SimpleTodosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
