//
//  UIToolbar+Extension.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 03/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

extension UIToolbar {
    static func toolbar(title: String, target: Any, action: Selector) -> UIToolbar {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.gray, for: UIControl.State())
        button.setTitle(title, for: UIControl.State())
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        let barButton = UIBarButtonItem(customView: button)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        toolbar.barTintColor = UIColor.white
        toolbar.items = [spacer, barButton]
        return toolbar
    }
}
