//
//  CMPKeychain.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 22/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPKeychain.h"
#import <Security/Security.h>

@implementation CMPKeychain

+ (BOOL)isStatusOK:(OSStatus)status {
    return status == noErr;
}

+ (NSMutableDictionary *)queryForKey:(NSString *)key {
    return [@{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
              (__bridge id)kSecAttrService : key,
              (__bridge id)kSecAttrAccount : key,
              (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAfterFirstUnlock
              } mutableCopy];
}

+ (BOOL)saveItem:(id)item forKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self queryForKey:key];

    [self deleteItemForKey:key];
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:item] forKey:(__bridge id)kSecValueData];
    return [self isStatusOK:SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL)];
}

+ (id)loadItemForKey:(NSString *)key {
    id object = nil;
    
    NSMutableDictionary *keychainQuery = [self queryForKey:key];
    
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    
    if ([self isStatusOK:SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData)]) {
        @try {
            object = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {
            NSLog(@"Unarchiving for key %@ failed with exception %@", key, exception.name);
            object = nil;
        }
        @finally {}
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    
    return object;
}

+ (BOOL)deleteItemForKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self queryForKey:key];
    return [self isStatusOK:SecItemDelete((__bridge CFDictionaryRef)keychainQuery)];
}

@end
