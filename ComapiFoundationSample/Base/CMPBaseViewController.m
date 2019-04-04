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

#import "CMPBaseViewController.h"

NSString * const kCMPLoadingBeginNotification = @"WillBeginLoading";
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingWillBePerformed:) name:kCMPLoadingBeginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingWillBeFinished:) name:kCMPLoadingStopNotification object:nil];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)unregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardWillBeShown:(NSNotification *)notification {
    if (self.keyboardWillShow) {
        self.keyboardWillShow(notification);
    }
}

-(void)keyboardShown:(NSNotification *)notification {
    if (self.keyboardDidShow) {
        self.keyboardDidShow(notification);
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    if (self.keyboardWillHide) {
        self.keyboardWillHide(notification);
    }
}

-(void)keyboardHidden:(NSNotification *)notification {
    if (self.keyboardDidHide) {
        self.keyboardDidHide(notification);
    }
}

@end
