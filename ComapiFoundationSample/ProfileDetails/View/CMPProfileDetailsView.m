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

#import "CMPProfileDetailsView.h"
#import "CMPTitledInputCell.h"

@implementation CMPProfileDetailsView

- (instancetype)initWithState:(CMPProfileState)state {
    self = [super init];
    
    if (self) {
        self.container = [UIView new];
        self.closeButton = [UIButton new];
        self.tableView = [UITableView new];
        self.updateButton = [UIButton new];
        self.state = state;
        
        [self configureWithState:state];
    }
    
    return self;
}

- (void)configureWithState:(CMPProfileState)state {
    [self customizeWithState:state];
    [self layoutWithState:state];
    [self constrainWithState:state];
}

- (void)customizeWithState:(CMPProfileState)state {
    self.userInteractionEnabled = YES;
    self.backgroundColor = UIColor.clearColor;
    
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerClass:CMPTitledInputCell.class forCellReuseIdentifier:@"cell"];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.container.backgroundColor = UIColor.grayColor;
    self.container.layer.borderColor = UIColor.whiteColor.CGColor;
    self.container.layer.borderWidth = 1.0;
    self.container.layer.cornerRadius = 4.0;
    self.container.layer.shadowColor = UIColor.blackColor.CGColor;
    self.container.layer.shadowRadius = 4.0;
    self.container.layer.shadowOpacity = 0.6;
    self.container.layer.shadowOffset = CGSizeMake(0, 4);
    self.container.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.updateButton setTitle:@"Update" forState:UIControlStateNormal];
    [self.updateButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.updateButton addTarget:self action:@selector(updateTapped) forControlEvents:UIControlEventTouchUpInside];
    self.updateButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    switch (state) {
        case CMPProfileStateSelf: {
            break;
        }
        case CMPPRofileStateOther: {
            break;
        }
    }
}

- (void)layoutWithState:(CMPProfileState)state {
    switch (state) {
        case CMPProfileStateSelf: {
            [self addSubview:self.container];
            
            [self.container addSubview:self.tableView];
            [self.container addSubview:self.closeButton];
            [self.container addSubview:self.updateButton];
            break;
        }
        case CMPPRofileStateOther: {
            [self addSubview:self.container];
            
            [self.container addSubview:self.tableView];
            [self.container addSubview:self.closeButton];
            break;
        }
    }
}

- (void)constrainWithState:(CMPProfileState)state {
    NSLayoutConstraint *containerTop;
    NSLayoutConstraint *containerBottom;
    if (@available(iOS 11.0, *)) {
        containerTop = [self.container.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:100];
        containerBottom = [self.container.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor constant:-100];
    } else {
        containerTop = [self.container.topAnchor constraintEqualToAnchor:self.topAnchor constant:100];
        containerBottom = [self.container.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-100];
    }
    
    NSLayoutConstraint *containerLeft = [self.container.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16];
    NSLayoutConstraint *containerRight = [self.container.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16];
    
    [NSLayoutConstraint activateConstraints:@[containerTop, containerLeft, containerBottom, containerRight]];
    
    NSLayoutConstraint *closeButtonTop = [self.closeButton.topAnchor constraintEqualToAnchor:self.container.topAnchor constant:16];
    NSLayoutConstraint *closeButtonLeft = [self.closeButton.leadingAnchor constraintEqualToAnchor:self.container.leadingAnchor constant:16];
    NSLayoutConstraint *closeButtonHeight = [self.closeButton.heightAnchor constraintEqualToConstant:36];
    NSLayoutConstraint *closeButtonWidth = [self.closeButton.widthAnchor constraintEqualToConstant:36];
    
    [NSLayoutConstraint activateConstraints:@[closeButtonTop, closeButtonLeft, closeButtonHeight, closeButtonWidth]];
    
    NSLayoutConstraint *tableViewTop = [self.tableView.topAnchor constraintEqualToAnchor:self.closeButton.bottomAnchor constant:16];
    NSLayoutConstraint *tableViewLeft = [self.tableView.leadingAnchor constraintEqualToAnchor:self.container.leadingAnchor constant:16];
    NSLayoutConstraint *tableViewBottom = [self.tableView.bottomAnchor constraintEqualToAnchor:self.container.bottomAnchor];
    NSLayoutConstraint *tableViewRight = [self.tableView.trailingAnchor constraintEqualToAnchor:self.container.trailingAnchor constant:-16];
    
    [NSLayoutConstraint activateConstraints:@[tableViewTop, tableViewLeft, tableViewBottom, tableViewRight]];
    
    switch (state) {
        case CMPProfileStateSelf: {
            NSLayoutConstraint *updateButtonHeight = [self.updateButton.heightAnchor constraintEqualToConstant:40];
            NSLayoutConstraint *updateButtonLeft = [self.updateButton.leadingAnchor constraintEqualToAnchor:self.container.leadingAnchor constant:32];
            NSLayoutConstraint *updateButtonBottom = [self.updateButton.bottomAnchor constraintEqualToAnchor:self.container.bottomAnchor constant:-8];
            NSLayoutConstraint *updateButtonRight = [self.updateButton.trailingAnchor constraintEqualToAnchor:self.container.trailingAnchor constant:-32];
            
            [NSLayoutConstraint activateConstraints:@[tableViewBottom, updateButtonHeight, updateButtonLeft, updateButtonBottom, updateButtonRight]];
            break;
        }
        case CMPPRofileStateOther: {
            break;
        }
    }
}

- (void)closeTapped {
    if (self.didTapClose) {
        self.didTapClose();
    }
}

- (void)updateTapped {
    if (self.didTapUpdate) {
        self.didTapUpdate();
    }
}

@end
