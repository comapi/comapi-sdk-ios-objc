//
//  CMPProfileDetailsViewModel.h
//  SampleApp
//
//  Created by Dominik Kowalski on 19/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPComapiClient.h"
#import "CMPProfile.h"

@interface CMPProfileDetailsViewModel : NSObject

@property (nonatomic, strong, readonly) CMPComapiClient *client;
@property (nonatomic, strong) CMPProfile *profile;
@property (nonatomic, strong) NSString *email;

- (instancetype)initWithClient:(CMPComapiClient *)client profile:(CMPProfile *)profile;

- (void)updateEmail:(NSString *)email completion:(void(^)(NSError * _Nullable))completion;

@end
