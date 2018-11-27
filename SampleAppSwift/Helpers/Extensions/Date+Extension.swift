//
//  Date+Extension.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 03/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import Foundation

extension Date {
    func ISO8601String() -> String? {
        let formatter = ISO8601DateFormatter()
        //formatter.formatOptions = [.withFractionalSeconds]
        return formatter.string(from: self)
    }
}
