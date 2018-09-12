//
//  CMPQueryBuilder.m
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 11/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPQueryBuilder.h"


@implementation CMPQueryElements

- (instancetype)initWithKey:(NSString *)key element:(CMPQueryElement)element value:(NSString *)value {
    self = [super init];
    
    if (self) {
        self.key = key;
        self.element = element;
        self.value = value;
    }
    
    return self;
}

@end

@implementation CMPQueryBuilder

+ (NSString *)valueForQueryElement:(CMPQueryElement)element {
    switch (element) {
        case CMPQueryElementEqual:
            return @"=";
        case CMPQueryElementUnequal:
            return @"!=";
        case CMPQueryElementGreaterThan:
            return @"=>";
        case CMPQueryElementLessThan:
            return @"=<";
        case CMPQueryElementGreaterOrEqualThan:
            return @"=>=";
        case CMPQueryElementLessOrEqualThan:
            return @"=<=";
        case CMPQueryElementStartsWith:
            return @"=^";
        case CMPQueryElementEndsWith:
            return @"=$";
        case CMPQueryElementContains:
            return @"=~";
        case CMPQueryElementInArray:
            return @"[]=";
        case CMPQueryElementNotInArray:
            return @"[]=!";
        case CMPQueryElementAnd:
            return @"&";
        case CMPQueryElementBegin:
            return @"?";
    }
}

+ (NSString *)buildQueryWithElements:(NSArray<CMPQueryElements *> *)elements {
    __block NSString *query = @"";
    
    [elements enumerateObjectsUsingBlock:^(CMPQueryElements * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *begin = ![query isEqualToString:@""] ? [CMPQueryBuilder valueForQueryElement:CMPQueryElementAnd] : [CMPQueryBuilder valueForQueryElement:CMPQueryElementBegin];
         query = [query stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@", begin, obj.key, [CMPQueryBuilder valueForQueryElement:obj.element], obj.value.description]];
    }];
    
    return query;
}

@end
