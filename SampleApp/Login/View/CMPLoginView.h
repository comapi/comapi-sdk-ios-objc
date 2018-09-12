//
//  CMPLoginView.h
//  SampleApp
//
//  Created by Dominik Kowalski on 04/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseView.h"
#import "CMPGrayButtonWithWhiteText.h"
#import "CMPTitledInputCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPLoginView : CMPBaseView <CMPViewConfiguring>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CMPGrayButtonWithWhiteText *loginButton;
@property (nonatomic, copy, nullable) void(^didTapLoginButton)(void);

- (instancetype)init;
- (void)animateOnKeyboardChangeNotification:(NSNotification *)notification completion:(void(^ _Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
