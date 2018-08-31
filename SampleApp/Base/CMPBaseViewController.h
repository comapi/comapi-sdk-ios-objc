//
//  CMPBaseViewController.h
//  SampleApp
//
//  Created by Dominik Kowalski on 31/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kCMPLoadingBeginNotification;
extern NSString * const kCMPLoadingStopNotification;

@interface CMPBaseViewController : UIViewController

@property (nonatomic, nullable, copy) void(^loadingWillPerform)(NSNotification *);
@property (nonatomic, nullable, copy) void(^loadingWillStop)(NSNotification *);

@property (nonatomic, nullable, copy) void(^keyboardWillShow)(NSNotification *);
@property (nonatomic, nullable, copy) void(^keyboardDidShow)(NSNotification *);
@property (nonatomic, nullable, copy) void(^keyboardWillHide)(NSNotification *);
@property (nonatomic, nullable, copy) void(^keyboardDidHide)(NSNotification *);

- (instancetype)init;

- (void)showLoader;
- (void)hideLoader;
- (void)back;

- (void)registerForLoadingNotifcations;
- (void)registerForKeyboardNotifications;
- (void)unregisterFromKeyboardNotifications;
- (void)unregisterFromLoadingNotifications;

- (void)dismissKeyboard;



@end

NS_ASSUME_NONNULL_END
