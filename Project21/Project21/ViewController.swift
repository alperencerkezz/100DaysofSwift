//
//  ViewController.swift
//  Project21
//
//  Created by Alperen Çerkez on 6.12.2024.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let remindMeLater = UNNotificationAction(identifier: "remindMeLater", title: "Remind me later", options: [])
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindMeLater], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            let alert = UIAlertController(title: "Notification Received", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
                alert.message = "You opened the notification."
                
            case "show":
                print("Show more information...")
                alert.message = "You chose to see more information."
                
            case "remindMeLater":
                print("Remind me later...")
                scheduleReminder()
                alert.message = "Reminder set for 24 hours later."
                
            default:
                alert.message = "Unknown action taken."
            }
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
        
        completionHandler()
    }
    
    func scheduleReminder() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "This is your reminder to check back later."
        content.categoryIdentifier = "alarm"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false) // 24 hours in seconds.
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func scheduleWeeklyReminders() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests() // Clears old reminders.

        for day in 1...7 {
            let content = UNMutableNotificationContent()
            content.title = "Daily Reminder"
            content.body = "Come back and play!"
            content.categoryIdentifier = "reminder"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(day * 86400), repeats: false) // Days in seconds.
            let request = UNNotificationRequest(identifier: "reminder-\(day)", content: content, trigger: trigger)
            center.add(request)
        }
    }
}
