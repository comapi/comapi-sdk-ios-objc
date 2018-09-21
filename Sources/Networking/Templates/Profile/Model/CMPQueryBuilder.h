//
//  CMPQueryBuilder.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CMPQueryElement) {
    CMPQueryElementEqual,
    CMPQueryElementUnequal,
    CMPQueryElementGreaterThan,
    CMPQueryElementLessThan,
    CMPQueryElementGreaterOrEqualThan,
    CMPQueryElementLessOrEqualThan,
    CMPQueryElementStartsWith,
    CMPQueryElementEndsWith,
    CMPQueryElementContains,
    CMPQueryElementInArray,
    CMPQueryElementNotInArray,
    CMPQueryElementAnd,
    CMPQueryElementBegin
};

@interface CMPQueryElements: NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic) CMPQueryElement element;
@property (nonatomic, strong) NSString *value;

- (instancetype)initWithKey:(NSString *)key element:(CMPQueryElement)element value:(NSString *)value;

@end

@interface CMPQueryBuilder : NSObject

+ (NSString *)buildQueryWithElements:(NSArray<CMPQueryElements *> *)elements;

@end
