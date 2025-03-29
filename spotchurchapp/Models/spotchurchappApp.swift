//
//  spotchurchappApp.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 3/17/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true;
    }
}


@main
struct spotchurchappApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
