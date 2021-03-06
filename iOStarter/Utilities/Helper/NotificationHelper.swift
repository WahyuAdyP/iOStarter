//
//  NotificationHelper.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 7/12/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase
import SwiftyJSON
import AVKit

class NotificationHelper {
    static var shared = NotificationHelper()
    
    private var player: AVAudioPlayer?
    
    // [START setup]
    /// Setup all need for notification first
    func setupNotif(delegate: AppDelegate, application: UIApplication) {
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = delegate
        // [END set_messaging_delegate]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = delegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (_, _) in
                
            })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFcmToken), name: NSNotification.Name.MessagingRegistrationTokenRefreshed, object: nil)
    }
    
    /// Save registration id token
    ///
    /// - Parameter deviceToken: Reg id to send notification in this device
    func register(deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        #if DEBUG
            Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #else
            Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #endif
        
        refreshFcmToken()
    }
    
    /// Update registration id token
    ///
    /// - Parameter notification: Notification sender when token refresh
    @objc func refreshFcmToken() {
        Messaging.messaging().token { (token, error) in
            if let token = token {
                print("Messaging token: \(token)")
                UserSession.shared.setRegid(string: token)
            }
        }
        if let token = Messaging.messaging().fcmToken {
            print("Fcm token \(token)")
            UserSession.shared.setRegid(string: token)
        }
    }
    // [END setup]
    
    /// Sound of notification in foreground
    private func playSound() {
        // Play sound with built in sound from iOS
        // Change sound ID if want change other sound
        // Comment this if want to use custum sound
        AudioServicesPlayAlertSound(SystemSoundID(1007))
        
        // Play customize sound
        // Import sound as usual import and adjust resource name and extension
        // Uncomment hits if want to use custom sound
//        guard let url = Bundle.main.url(forResource: "notification", withExtension: "mp3") else { return }
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            guard let player = player else { return }
//
//            player.play()
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
    }
    
    /// Make action in application with received notification
    ///
    /// - Parameters:
    ///   - data: Received notification data
    ///   - state: Position of application
    func notification(data: [AnyHashable : Any]) {
        if !UserSession.shared.isUserLoggedIn {
            return
        }
        let json = JSON(data)
        print("Hey this is your notification \(json)")
        let title = json["title"].stringValue
        let content = json["content"].stringValue
        let action = json["action"].stringValue
        
        let state = UIApplication.shared.applicationState
        switch state {
        case .active:
            // Make a action when receive notification while application in use/ active
            playSound()
            
            if action == "action" {
                let notify = Notify(title: title, detail: content, image: nil)
                notify.appearance.textAlign = .left
                notify.setTapAction {
                    self.exampleAction()
                }
                notify.show()
            }
        case .inactive:
            // Make a action when application active but no interaction user in application
            self.exampleAction()
        case .background:
            // Make a action when application not use/ inactive/ not in application
            self.exampleAction()
        default:
            break
        }
    }
    
    /// Example action of notification
    func exampleAction() {
        print("Oh, hey you got notification")
    }
    
}
