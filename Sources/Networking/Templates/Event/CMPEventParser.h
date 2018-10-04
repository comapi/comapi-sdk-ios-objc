//
//  CMPEventParser.h
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 04/10/2018.
//

#import "CMPEvent.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(EventParser)
@interface CMPEventParser : NSObject

+ (NSArray<CMPEvent *> *)parseEvents:(NSArray<NSDictionary<NSString *, id> *> *)events;

@end

NS_ASSUME_NONNULL_END
