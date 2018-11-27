//
//  TimeInterval+Extension.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 02/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import Foundation

extension Int {
    func seconds() -> TimeInterval {
        return TimeInterval(self)
    }
    
    func minutes() -> TimeInterval {
        return 60.seconds() * TimeInterval(self)
    }
    
    func hours() -> TimeInterval {
        return 60.minutes() * 60.seconds() * TimeInterval(self)
    }
    
    func days() -> TimeInterval {
        return 24.hours() * 60.minutes() * 60.seconds() * TimeInterval(self)
    }
}
