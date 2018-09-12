//
//  CMPLoginViewModel.h
//  SampleApp
//
//  Created by Dominik Kowalski on 05/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPLoginBundle.h"
#import "CMPComapi.h"
#import "CMPAuthenticationManager.h"

@interface CMPLoginViewModel : NSObject <CMPAuthenticationDelegate>

@property (nonatomic, strong) CMPLoginBundle *loginBundle;
@property (nonatomic, strong) CMPComapiClient *client;

- (void)configureWithCompletion:(void(^)(NSError * _Nullable))completion;
@end


