//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import SwiftUI
import UIKit

@main
struct MovieAppApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
       @State private var showRetryAlert = false
    @State private var showBugReportSheet = false
       @StateObject var router = AppRouter()
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .alert(isPresented: $showRetryAlert) {
                                    Alert(
                                        title: Text("Please Give Us a Second Chance"),
                                        message: Text("We’d love to hear your feedback before you uninstall."),
                                        primaryButton: .default(Text("Send Feedback")) {
                                            // Present feedback form or email composer
                                        },
                                        secondaryButton: .cancel(Text("Maybe Later"))
                                    )
                                }
                                .onReceive(NotificationCenter.default.publisher(for: .retryShortcut)) { _ in
                                    showRetryAlert = true
                                }
                                .sheet(isPresented: $showBugReportSheet) {
                                                    BugReportView()
                                                }
                                                .onReceive(NotificationCenter.default.publisher(for: .reportBugShortcut)) { _ in
                                                    showBugReportSheet = true
                                                }
        }
    }
}



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        switch shortcutItem.type {
        case "com.yourapp.retry":
            NotificationCenter.default.post(name: .retryShortcut, object: nil)
            completionHandler(true)
        case "com.yourapp.reportBug":
            NotificationCenter.default.post(name: .reportBugShortcut, object: nil)
            completionHandler(true)
        default:
            completionHandler(false)
        }
    }
}


extension Notification.Name {
    static let retryShortcut = Notification.Name("retryShortcut")
    static let reportBugShortcut = Notification.Name("reportBugShortcut")
}


// Simple router
class AppRouter: ObservableObject {
    enum Destination { case home, favorites, support }
    @Published var destination: Destination = .home

    func navigate(to dest: Destination) {
        destination = dest
    }
}
