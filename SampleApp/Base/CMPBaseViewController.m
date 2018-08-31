//
//  CMPBaseViewController.m
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseViewController.h"

NSString * const kCMPLoadingStopNotification = @"WillStopLoading";
NSString * const kCMPLoadingStopNotification = @"WillStopLoading";

@interface CMPBaseViewController ()

- (void)loadingWillBePerformed:(NSNotification *)notification;
- (void)loadingWillBeFinished:(NSNotification *)notification;

- (void)keyboardWillBeShown:(NSNotification *)notification;
- (void)keyboardShown:(NSNotification *)notification;
- (void)keyboardWillBeHidden:(NSNotification *)notification;
- (void)keyboardHidden:(NSNotification *)notification;

@end

@implementation CMPBaseViewController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    return self;
}

- (void)dealloc {
    [self unregisterFromLoadingNotifications];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)registerForLoadingNotifcations {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingWillBePerformed) name:kCMPLoadingBeginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingWillBeFinished) name:kCMPLoadingStopNotification object:nil];
}

- (void)unregisterFromLoadingNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCMPLoadingBeginNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCMPLoadingStopNotification object:nil];
}

-(void)loadingWillBePerformed:(NSNotification *)notification {
    self.loadingWillPerform(notification);
}

- (void)loadingWillBeFinished:(NSNotification *)notification {
    self.loadingWillStop(notification);
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden) name:UIKeyboardDidHideNotification object:nil];
}

- (void)unregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardWillBeShown:(NSNotification *)notification {
    self.keyboardWillShow(notification);
}

-(void)keyboardShown:(NSNotification *)notification {
    self.keyboardDidShow(notification);
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.keyboardWillHide(notification);
}

-(void)keyboardHidden:(NSNotification *)notification {
    self.keyboardDidHide(notification);
}

@end
