//
//  NotificationsManager.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 13.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation
import UserNotifications

class LocalPushNotificationsManager {
    
    let shared = LocalPushNotificationsManager()
    
    private init(){}
    
    static func subscribe() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = PushNotificationsConstants.title
        content.body = PushNotificationsConstants.body
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(PushNotificationsConstants.timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Error")
            }
        }
    }
    
    static func unSubscribe() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
}
