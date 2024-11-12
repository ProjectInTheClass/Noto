//
//  noto_AppApp.swift
//  noto-App
//
//  Created by 진혁의 Macbook Pro on 11/8/24.
//

import SwiftUI
import SwiftData

@main
struct noto_AppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
            FontTest_ContentView()
            StyleTest_ContentView()
        }
        .modelContainer(sharedModelContainer)
      
    }
}
