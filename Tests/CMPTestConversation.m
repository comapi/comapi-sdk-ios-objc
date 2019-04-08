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

#import <XCTest/XCTest.h>
#import "CMPConversation.h"
#import "CMPResourceLoader.h"
#import "CMPConversationParticipant.h"
#import "CMPConversationUpdate.h"
#import "NSString+CMPUtility.h"
#import "NSDate+CMPUtility.h"

@interface CMPTestConversation : XCTestCase

@end

@implementation CMPTestConversation

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testConversation {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"Conversation"];
    CMPConversation *c = [CMPConversation decodeWithData:data];
    NSData *encodedData = [c encode];
    
    NSError *err;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:encodedData options:0 error:&err];
    if (err) {
        XCTFail();
    }

    XCTAssertEqualObjects(json[@"id"], @"support");
    XCTAssertEqualObjects(json[@"name"], @"Support");
    XCTAssertEqualObjects(json[@"description"], @"The Support Channel");
    XCTAssertEqual([json[@"roles"][@"owner"][@"canSend"] boolValue], YES);
    XCTAssertEqual([json[@"roles"][@"owner"][@"canAddParticipants"] boolValue], YES);
    XCTAssertEqual([json[@"roles"][@"owner"][@"canRemoveParticipants"] boolValue], YES);
    XCTAssertEqual([json[@"roles"][@"participant"][@"canSend"] boolValue], YES);
    XCTAssertEqual([json[@"roles"][@"participant"][@"canAddParticipants"] boolValue], YES); 
    XCTAssertEqual([json[@"roles"][@"participant"][@"canRemoveParticipants"] boolValue], YES);
    XCTAssertEqual([json[@"isPublic"] boolValue], NO);
    XCTAssertEqualObjects(json[@"updatedOn"], @"2016-09-26T09:39:44.089Z");
}

- (void)testConversationParticipant {
    NSData *data = [CMPResourceLoader loadJSONWithName:@"ConversationParticipant"];
    CMPConversationParticipant *c = [CMPConversationParticipant decodeWithData:data];
    NSData *encodedData = [c encode];
    
    NSError *err;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:encodedData options:0 error:&err];
    if (err) {
        XCTFail();
    }
    
    XCTAssertEqualObjects(json[@"id"], @"participantID");
    XCTAssertEqualObjects(json[@"role"], @"owner");
    
    c = [[CMPConversationParticipant alloc] initWithID:@"id" role:CMPRoleParticipant];
    
    XCTAssertEqualObjects(c.id, @"id");
    XCTAssertEqual(c.role, CMPRoleParticipant);
}

- (void)testConversationUpdate {
    CMPRoleAttributes *owner = [[CMPRoleAttributes alloc] initWithCanSend:YES canAddParticipants:YES canRemoveParticipants:YES];
    CMPRoleAttributes *participant = [[CMPRoleAttributes alloc] initWithCanSend:YES canAddParticipants:YES canRemoveParticipants:YES];
    CMPRoles *roles = [[CMPRoles alloc] initWithOwnerAttributes:owner participantAttributes:participant];
    CMPConversationUpdate *c = [[CMPConversationUpdate alloc] initWithID:@"id" name:@"name" description:@"desc" roles:roles isPublic:[NSNumber numberWithBool:YES]];
    
    XCTAssertEqualObjects(c.id, @"id");
    XCTAssertEqualObjects(c.name, @"name");
    XCTAssertEqualObjects(c.conversationDescription, @"desc");
    XCTAssertEqual(c.roles.owner.canSend, YES);
    XCTAssertEqual(c.roles.owner.canAddParticipants, YES);
    XCTAssertEqual(c.roles.owner.canRemoveParticipants, YES);
    XCTAssertEqual(c.roles.participant.canSend, YES);
    XCTAssertEqual(c.roles.participant.canAddParticipants, YES);
    XCTAssertEqual(c.roles.participant.canRemoveParticipants, YES);
}


@end
