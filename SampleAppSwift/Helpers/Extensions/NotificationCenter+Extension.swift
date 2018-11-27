//
//  NotificationCenter+Extension.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 04/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import Foundation

extension NotificationCenter {
    
    static func post(notification: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: notification, object: object)
    }
    
}
