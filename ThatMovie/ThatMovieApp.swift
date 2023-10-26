//
//  ThatMovieApp.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.10.2023.
//

import SwiftUI
import SwiftData

@main
struct ThatMovieApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MovieItem.self,
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
        }
        .modelContainer(sharedModelContainer)
    }
}
