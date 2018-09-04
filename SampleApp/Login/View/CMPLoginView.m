//
//  CMPLoginView.m
//  SampleApp
//
//  Created by Dominik Kowalski on 04/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLoginView.h"
#import "CMPTitledInputCell.h"

@implementation CMPLoginView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.tableView = [UITableView new];
        self.loginButton = [[CMPGrayButtonWithWhiteText alloc] init];
        
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
    self.backgroundColor = UIColor.grayColor;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = UIColor.grayColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerClass:[CMPTitledInputCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.loginButton setTitle:@"Login" forState:0];
    [self.loginButton addTarget:self action:@selector(loginTapped) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self addSubview:self.tableView];
    [self addSubview:self.loginButton];
}

- (void)constrain {
    NSLayoutConstraint *tableTop = [self.tableView.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *tableBottom = [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    NSLayoutConstraint *tableLeading = [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *tableTrailing = [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[tableTop, tableBottom, tableLeading, tableTrailing]];
    
    NSLayoutConstraint *loginLeading = [self.loginButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16];
    NSLayoutConstraint *loginTrailing = [self.loginButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16];
    NSLayoutConstraint *loginBottom = [self.loginButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-16];
    NSLayoutConstraint *loginHeight = [self.loginButton.heightAnchor constraintEqualToConstant:44];
    
    [NSLayoutConstraint activateConstraints:@[loginLeading, loginTrailing, loginBottom, loginHeight]];
}

- (void)loginTapped {
    self.didTapLoginButton();
}

- (void)animateOnKeyboardChangeNotification:(NSNotification *)notification completion:(void (^)(void))completion {
    NSDictionary *info = notification.userInfo;
    if (!info) { return; }
    NSString *name = notification.name;
    NSInteger curve = (UIViewAnimationCurve)info[UIKeyboardAnimationCurveUserInfoKey];
    double duration = [(NSNumber *)info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endFrame = [(NSValue *)info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration delay:0.0 options:curve animations:^{
        if ([name isEqualToString:UIKeyboardWillShowNotification]) {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, endFrame.size.height + 16, 0);
        } else {
            self.tableView.contentInset = UIEdgeInsetsZero;
        }
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        completion();
    }];
}

@end
