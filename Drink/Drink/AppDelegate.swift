//
//  AppDelegate.swift
//  Drink
//
//  Created by 최수훈 on 2023/01/05.
//

import UIKit
import NotificationCenter
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var userNotificationCenter = UNUserNotificationCenter.current()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 알림에 대한 설정하기
        UNUserNotificationCenter.current().delegate = self
        
        let authoriazationOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        userNotificationCenter.requestAuthorization(options: authoriazationOptions) { _, error in
            if let error = error {
                print("Error: notification authorization request \(error.localizedDescription)")
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 여기서 속성 안정하면 안나온다.
        completionHandler([.banner, .list, .badge, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

