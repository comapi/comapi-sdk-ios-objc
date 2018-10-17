//
//  CMPChatInputView.m
//  SampleApp
//
//  Created by Dominik Kowalski on 16/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPChatInputView.h"

@implementation CMPChatInputView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.inputTextView = [[CMPPlaceholderTextView alloc] init];
        self.sendButton = [UIButton new];
        self.uploadButton = [UIButton new];
        
        [self configure];
    }
    
    return self;
}

- (void)configure {
    [self customize];
    [self layout];
    [self constrain];
}

- (void)customize {
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowRadius = 4.0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.3;
    self.backgroundColor = UIColor.grayColor;
//    inputTextView.backgroundColor = .clear
//    inputTextView.layer.borderWidth = 1.0
//    inputTextView.layer.borderColor = UIColor.white.cgColor
//    inputTextView.inputAccessoryView = nil
//    inputTextView.isScrollEnabled = false
//    inputTextView.setPlaceholder(text: "New message...")
//    inputTextView.layer.masksToBounds = true
//    inputTextView.layer.cornerRadius = 4
//    inputTextView.clipsToBounds = true
    self.inputTextView.backgroundColor = UIColor.clearColor;
    self.inputTextView.layer.borderWidth = 1.0;
    self.inputTextView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.inputTextView.layer.masksToBounds = YES;
    self.inputTextView.layer.cornerRadius = 4.0;
    self.inputTextView.clipsToBounds = YES;
    self.inputTextView.scrollEnabled = NO;
    self.inputTextView.inputAccessoryView = nil;
    [self.inputTextView setPlaceholderWithText:@"New message..."];
    self.inputTextView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.sendButton.enabled = NO;
    [self.sendButton setTitle:@"Send" forState:0];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.sendButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.sendButton setTitleColor:UIColor.redColor forState:UIControlStateDisabled];
    [self.sendButton addTarget:self action:@selector(sendTapped) forControlEvents:UIControlEventTouchUpInside];
    //[self.sendButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    //[self.sendButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.uploadButton.enabled = YES;
    [self.uploadButton setImage:[UIImage imageNamed:@"photo"] forState:0];
    [self.uploadButton addTarget:self action:@selector(uploadTapped) forControlEvents:UIControlEventTouchUpInside];
    //[self.uploadButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    //[self.uploadButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.uploadButton.translatesAutoresizingMaskIntoConstraints = NO;

}

- (void)layout {
    [self addSubview:self.inputTextView];
    [self addSubview:self.sendButton];
    [self addSubview:self.uploadButton];
}

- (void)constrain {
    
    //view.snp.remakeConstraints {
        //            switch view {
        //            case inputTextView:
        //                $0.height.greaterThanOrEqualTo(40)
        //                $0.bottom.equalToSuperview().offset(-8)
        //                $0.top.equalToSuperview().offset(8)
        //            case sendButton:
        //                $0.trailing.equalToSuperview().offset(-8)
        //                $0.centerY.equalToSuperview()
        //                $0.leading.equalTo(inputTextView.snp.trailing).offset(8)
        //            case uploadButton:
        //                $0.leading.equalToSuperview().offset(8)
        //                $0.centerY.equalToSuperview()
        //                $0.trailing.equalTo(inputTextView.snp.leading).offset(-8)
        //            default:
        //                break
        //            }
        //        }
    NSLayoutConstraint *textViewHeight = [self.inputTextView.heightAnchor constraintGreaterThanOrEqualToConstant:40];
    NSLayoutConstraint *textViewBottom = [self.inputTextView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8];
    NSLayoutConstraint *textViewTop = [self.inputTextView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8];
    
    [NSLayoutConstraint activateConstraints:@[textViewHeight, textViewBottom, textViewTop]];
    
    NSLayoutConstraint *sendTrailing = [self.sendButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8];
    NSLayoutConstraint *sendCenterY = [self.sendButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    NSLayoutConstraint *sendLeading = [self.sendButton.leadingAnchor constraintEqualToAnchor:self.inputTextView.trailingAnchor constant:8];
    NSLayoutConstraint *sendWidth = [self.sendButton.widthAnchor constraintGreaterThanOrEqualToConstant:46];
    
    [NSLayoutConstraint activateConstraints:@[sendTrailing, sendWidth, sendCenterY, sendLeading]];
    
    NSLayoutConstraint *uploadTrailing = [self.uploadButton.trailingAnchor constraintEqualToAnchor:self.inputTextView.leadingAnchor constant:-8];
    NSLayoutConstraint *uploadCenterY = [self.uploadButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    NSLayoutConstraint *uploadLeading = [self.uploadButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8];
    NSLayoutConstraint *uploadWidth = [self.uploadButton.widthAnchor constraintEqualToConstant:24];
    
    [NSLayoutConstraint activateConstraints:@[uploadTrailing, uploadCenterY, uploadLeading, uploadWidth]];
}

- (void)sendTapped {
    if (self.didTapSendButton) {
        self.didTapSendButton();
    }
}

- (void)uploadTapped {
    if (self.didTapUploadButton) {
        self.didTapUploadButton();
    }
}

@end

////
////  ChatInputView.swift
////  ComapiChatSDKTestApp
////
////  Created by Dominik Kowalski on 04/07/2018.
////  Copyright © 2018 Dominik Kowalski. All rights reserved.
////
//
//import UIKit
//
//class ChatInputView: BaseView {
//
//    let inputTextView: PlaceholderTextView
//    var sendButton: UIButton
//    var uploadButton: UIButton
//
//    var didTapSendButton: (() -> ())?
//    var didTapUploadButton: (() -> ())?
//
//    override init() {
//        inputTextView = PlaceholderTextView()
//        sendButton = UIButton()
//        uploadButton = UIButton()
//
//        super.init()
//
//        configure()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func configure() {
//        customize(self)
//        customize(sendButton)
//        customize(uploadButton)
//        customize(inputTextView)
//
//        layout(sendButton)
//        layout(uploadButton)
//        layout(inputTextView)
//
//        constrain(sendButton)
//        constrain(uploadButton)
//        constrain(inputTextView)
//    }
//
//    func customize(_ view: UIView) {
//        switch view {
//        case self:
//            layer.shadowColor = UIColor.black.cgColor
//            layer.shadowRadius = 4.0
//            layer.shadowOffset = CGSize(width: 0, height: 0)
//            layer.shadowOpacity = 0.3
//            backgroundColor = .gray
//        case inputTextView:
//            inputTextView.backgroundColor = .clear
//            inputTextView.layer.borderWidth = 1.0
//            inputTextView.layer.borderColor = UIColor.white.cgColor
//            inputTextView.inputAccessoryView = nil
//            inputTextView.isScrollEnabled = false
//            inputTextView.setPlaceholder(text: "New message...")
//            inputTextView.layer.masksToBounds = true
//            inputTextView.layer.cornerRadius = 4
//            inputTextView.clipsToBounds = true
//        case sendButton:
//            sendButton.isEnabled = false
//            sendButton.setTitle("Send", for: UIControlState())
//            sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
//            sendButton.setTitleColor(.white, for: .normal)
//            sendButton.setTitleColor(.red, for: .disabled)
//            sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
//        case uploadButton:
//            uploadButton.isEnabled = true
//            uploadButton.setImage(UIImage(named: "photo"), for: UIControlState())
//            uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
//        default:
//            break
//        }
//    }
//
//    func layout(_ view: UIView) {
//        switch view {
//        default:
//            addSubview(view)
//        }
//    }
//
//    func constrain(_ view: UIView) {
//        view.snp.remakeConstraints {
//            switch view {
//            case inputTextView:
//                $0.height.greaterThanOrEqualTo(40)
//                $0.bottom.equalToSuperview().offset(-8)
//                $0.top.equalToSuperview().offset(8)
//            case sendButton:
//                $0.trailing.equalToSuperview().offset(-8)
//                $0.centerY.equalToSuperview()
//                $0.leading.equalTo(inputTextView.snp.trailing).offset(8)
//            case uploadButton:
//                $0.leading.equalToSuperview().offset(8)
//                $0.centerY.equalToSuperview()
//                $0.trailing.equalTo(inputTextView.snp.leading).offset(-8)
//            default:
//                break
//            }
//        }
//    }
//
//    @objc func sendTapped() {
//        didTapSendButton?()
//    }
//
//    @objc func uploadTapped() {
//        didTapUploadButton?()
//    }
//}
