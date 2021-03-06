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

#import "CMPRoleAttributes.h"

@implementation CMPRoleAttributes

- (instancetype)initWithCanSend:(BOOL)canSend canAddParticipants:(BOOL)canAddParticipants canRemoveParticipants:(BOOL)canRemoveParticipants {
    self = [super init];
    
    if (self) {
        self.canSend = canSend;
        self.canAddParticipants = canAddParticipants;
        self.canRemoveParticipants = canRemoveParticipants;
    }
    
    return self;
}

#pragma mark - CMPJSONEncoding

- (id)json {
    return @{@"canSend" : [NSNumber numberWithBool:self.canSend],
             @"canAddParticipants" : [NSNumber numberWithBool:self.canAddParticipants],
             @"canRemoveParticipants" : [NSNumber numberWithBool:self.canRemoveParticipants]};
}

- (NSData *)encode {
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&error];
    if (error) {
        return nil;
    }
    return json;
}

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"canSend"] && [JSON[@"canSend"] isKindOfClass:NSNumber.class]) {
            self.canSend = ([(NSNumber *)JSON[@"canSend"] boolValue]);
        }
        if (JSON[@"canRemoveParticipants"] && [JSON[@"canRemoveParticipants"] isKindOfClass:NSNumber.class]) {
            self.canRemoveParticipants = ([(NSNumber *)JSON[@"canRemoveParticipants"] boolValue]);
        }
        if (JSON[@"canAddParticipants"] && [JSON[@"canAddParticipants"] isKindOfClass:NSNumber.class]) {
            self.canAddParticipants = ([(NSNumber *)JSON[@"canAddParticipants"] boolValue]);
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPRoleAttributes alloc] initWithJSON:json];
}

@end
