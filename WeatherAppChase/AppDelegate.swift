//
//  AppDelegate.swift
//  WeatherAppChase
//

import SwiftUI

@main
struct WeatherAppChase: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("App will enter foreground")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("App did enter background")
    }
}
