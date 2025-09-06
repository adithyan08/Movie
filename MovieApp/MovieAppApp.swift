//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import SwiftUI

@main
struct MovieAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}
