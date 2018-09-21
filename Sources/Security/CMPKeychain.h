//
//  CMPKeychain.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 22/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPKeychain : NSObject

+ (BOOL)saveItem:(id)item forKey:(NSString *)key;
+ (id)loadItemForKey:(NSString *)key;
+ (BOOL)deleteItemForKey:(NSString *)key;


@end
