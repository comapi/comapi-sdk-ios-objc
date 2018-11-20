//
//  CMPTestConversation.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 19/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPConversation.h"
#import "CMPResourceLoader.h"
#import "CMPConversationParticipant.h"
#import "CMPConversationUpdate.h"

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
    
    c = [[CMPConversationParticipant alloc] initWithID:@"id" role:@"participant"];
    
    XCTAssertEqualObjects(c.id, @"id");
    XCTAssertEqualObjects(c.role, @"participant");
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
