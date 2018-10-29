//
//  CMPBroadcastDelegate.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 12/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBroadcastDelegate.h"

@interface CMPBroadcastDelegate<__covariant Delegate> ()

@property (nonatomic, strong) NSHashTable<Delegate> *delegates;

@end

@implementation CMPBroadcastDelegate

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.delegates = [NSHashTable weakObjectsHashTable];
    }
    
    return self;
}

- (void)addDelegate:(id)delegate {
    [self.delegates addObject:delegate];
}

- (void)removeDelegate:(id)delegate {
    [self.delegates removeObject:delegate];
}

- (void)invokeDelegatesWithBlock:(void (^)(id delegate))block {
    NSEnumerator *enumerator = [self.delegates objectEnumerator];
    id value;
    
    while ((value = [enumerator nextObject])) {
        block(value);
    }
}

@end
