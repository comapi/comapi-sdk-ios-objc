//
//  GrayButtonWithWhiteText.swift
//  Befriend
//
//  Created by Dominik Kowalski on 11/05/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class GrayButtonWithWhiteText: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customize() {
        backgroundColor = UIColor.white
        titleLabel?.numberOfLines = 0
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        setTitleColor(.gray, for: UIControl.State())
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.14
        layer.cornerRadius = 4
    }
}
