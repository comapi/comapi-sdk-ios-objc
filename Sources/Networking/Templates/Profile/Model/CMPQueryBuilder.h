//
//  CMPQueryBuilder.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 11/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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
} NS_SWIFT_NAME(QueryElement);

NS_SWIFT_NAME(QueryElements)
@interface CMPQueryElements: NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic) CMPQueryElement element;
@property (nonatomic, strong) NSString *value;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithKey:(NSString *)key element:(CMPQueryElement)element value:(NSString *)value;

@end

NS_SWIFT_NAME(QueryBuilder)
@interface CMPQueryBuilder : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (NSString *)buildQueryWithElements:(NSArray<CMPQueryElements *> *)elements;

@end

NS_ASSUME_NONNULL_END
