#import "CMPMessageDeliveryStatus.h"

@implementation CMPMessageDeliveryStatusParser

+ (NSString *)parseStatus:(CMPMessageDeliveryStatus)status {
    switch (status) {
        case CMPMessageDeliveryStatusRead:
            return @"read";
        case CMPMessageDeliveryStatusDelivered:
            return @"delivered";
    }
}

@end
