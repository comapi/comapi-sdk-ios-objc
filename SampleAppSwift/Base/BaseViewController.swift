//
//  BaseViewController.swift
//  ComapiChatSDKTestApp
//
//  Created by Dominik Kowalski on 04/07/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    static let LoadingBeginNotification = "WillPerformLoading"
    static let LoadingStopNotification = "WillStopLoading"
    
    var loadingWillPerform: ((Notification) -> ())?
    var loadingWillStop: ((Notification) -> ())?
    
    var keyboardWillShow: ((Notification) -> ())?
    var keyboardDidShow: ((Notification) -> ())?
    var keyboardWillHide: ((Notification) -> ())?
    var keyboardDidHide: ((Notification) -> ())?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unregisterFromLoadingNotification()
    }
    
    func navigation() {}
    func delegates() {}
    
    func hideLoader() {
        
    }
    
    func showLoader(size: CGFloat = 44, message: String? = nil) {
        
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func registerForLoadingNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadingWillBePerformed), name: Notification.Name(rawValue: BaseViewController.LoadingBeginNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadingWillBeFinished), name: Notification.Name(rawValue: BaseViewController.LoadingStopNotification), object: nil)
    }
    
    func unregisterFromLoadingNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: BaseViewController.LoadingBeginNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: BaseViewController.LoadingStopNotification), object: nil)
    }
    
    @objc func loadingWillBePerformed(notification: Notification) {
        self.loadingWillPerform?(notification)
    }
    
    @objc func loadingWillBeFinished(notification: Notification) {
        self.loadingWillStop?(notification)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    func unregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillBeShown(notification: Notification) {
        self.keyboardWillShow?(notification)
    }
    
    @objc private func keyboardShown(notification: Notification) {
        self.keyboardDidShow?(notification)
    }
    
    @objc private func keyboardWillBeHidden(notification: Notification) {
        self.keyboardWillHide?(notification)
    }
    
    @objc private func keyboardHidden(notification: Notification) {
        self.keyboardDidHide?(notification)
    }
}
