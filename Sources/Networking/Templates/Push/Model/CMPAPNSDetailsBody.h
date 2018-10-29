//
//  APNSDetailsBody.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 30/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPAPNSDetails.h"
#import "CMPJSONEncoding.h"

@interface CMPAPNSDetailsBody : NSObject <CMPJSONEncoding>

@property (nonatomic, strong, nullable) CMPAPNSDetails *apns;

- (instancetype)initWithAPNSDetails:(CMPAPNSDetails *)apnsDetails;

@end
