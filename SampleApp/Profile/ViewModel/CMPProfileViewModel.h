//
//  CMPProfileViewModel.h
//  SampleApp
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPProfileViewModel : NSObject

@property (nonatomic, copy) NSMutableArray<NSString *> *profiles;

- (instancetype)init;

@end
