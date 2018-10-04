//
//  CMPEventParser.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//

#import "CMPEventParser.h"

@implementation CMPEventParser

+ (NSArray<CMPEvent *> *)parseEvents:(NSArray<NSDictionary<NSString *,id> *> *)events {
    NSMutableArray<CMPEvent *> *parsedEvents = [NSMutableArray new];
    [events enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    
    return [NSArray arrayWithArray:parsedEvents];
}

@end
