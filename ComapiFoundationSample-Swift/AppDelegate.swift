//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit
import UserNotifications
import CMPComapiFoundation

let PushRegistrationStatusChangedNotification = "PushRegistrationStatusChangedNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var configurator: AppConfigurator!
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        configurator.client?.handle(notificationResponse: response, completion: { [weak self] (didHandleLink, data) in
            if didHandleLink {
                completionHandler()
            } else {
                if let configured = self?.configurator.client?.isSessionSuccessfullyCreated, configured {
                    if let conversationID = response.notification.request.content.userInfo["conversationId"] as? String {
                        if let root = self?.window?.rootViewController as? UINavigationController, let topVC = root.topViewController, topVC is ChatViewController {
                            (topVC as! ChatViewController).reload()
                            completionHandler()
                        } else {
                            self?.configurator.start { [weak self] loggedIn in
                                if loggedIn {
                                    self?.configurator.client?.services.messaging.getConversation(conversationID: conversationID, completion: { (result) in
                                        if let conversation = result.object, let client = self?.configurator.client {
                                            let vm = ChatViewModel(client: client, conversation: conversation)
                                            let vc = ChatViewController(viewModel: vm)
                                            if let nav = self?.window?.rootViewController as? UINavigationController {
                                                nav.pushViewController(vc, animated: true)
                                                completionHandler()
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        });
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        if #available(iOS 11.0, *) {
            let action1 = UNNotificationAction(identifier: "action1",
                                                    title: "Action 1",
                                                    options: .foreground)
            let action2 = UNNotificationAction(identifier: "action2",
                                                     title: "Action 2",
                                                     options: .foreground)
            let category =
                UNNotificationCategory(identifier: "DEEPLINK",
                                       actions: [action1, action2],
                                       intentIdentifiers: [],
                                       hiddenPreviewsBodyPlaceholder: "",
                                       options: .hiddenPreviewsShowTitle)
            center.setNotificationCategories([category])
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        configurator = AppConfigurator(window: window!)
        configurator.start()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme, scheme == "dotdigital" {
            let alert = UIAlertController(title: "Received link", message: "Received in-app link: \(url.absoluteString)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        configurator.client?.set(pushToken: token, completion: { (success, error) in
            if error != nil || !success {
                print(error!)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: PushRegistrationStatusChangedNotification), object: false)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: PushRegistrationStatusChangedNotification), object: true)
            }
        })
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PushRegistrationStatusChangedNotification), object: false)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}
