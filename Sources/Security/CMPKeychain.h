//
//  CMPKeychain.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 22/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Keychain)
@interface CMPKeychain : NSObject

+ (BOOL)saveItem:(id)item forKey:(NSString *)key;
+ (id)loadItemForKey:(NSString *)key;
+ (BOOL)deleteItemForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
