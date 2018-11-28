//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "CMPOrphanedEvent.h"
#import "NSString+CMPUtility.h"

@implementation CMPOrphanedEvent

- (instancetype)initWithID:(NSString *)ID messageID:(nullable NSString *)messageID eventID:(NSString *)eventID conversationID:(NSString *)conversationID profileID:(NSString *)profileID name:(NSString *)name updatedBy:(NSString *)updatedBy createdOn:(NSDate *)createdOn {
    self = [super init];
    
    if (self) {
        self.id = ID;
        self.messageID = messageID;
        self.eventID = eventID;
        self.conversationID = conversationID;
        self.profileID = profileID;
        self.name = name;
        self.updatedBy = updatedBy;
        self.createdOn = createdOn;
    }
    
    return self;
}

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.messageID forKey:@"messageId"];
    [dict setValue:self.conversationID forKey:@"conversationId"];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.createdOn forKey:@"createdOn"];
    
    return dict;
}

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"payload.messageId"] && [JSON[@"payload.messageId"] isKindOfClass:NSString.class]) {
            self.messageID = JSON[@"payload.messageId"];
        }
        if (JSON[@"payload.conversationId"] && [JSON[@"payload.conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"payload.conversationId"];
        }
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"createdOn"] && [JSON[@"createdOn"] isKindOfClass:NSString.class]) {
            self.createdOn = [(NSString *)JSON[@"createdOn"] asDate];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPOrphanedEvent alloc] initWithJSON:json];
}

@end
