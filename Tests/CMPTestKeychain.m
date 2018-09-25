//
//  CMPTestKeychain.m
//  CMPComapiFoundation_tests
//
//  Created by Dominik Kowalski on 18/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPTestMocks.h"
#import "CMPKeychain.h"

@interface CMPTestKeychain : XCTestCase

@property (nonatomic, strong) NSString *testStringKey;
@property (nonatomic, strong) NSString *testNumberKey;
@property (nonatomic, strong) NSString *testPrimitiveKey;

@property (nonatomic, strong) NSString *testString;
@property (nonatomic, strong) NSNumber *testNumber;
@property (nonatomic) BOOL testPrimitive;

@end

@implementation CMPTestKeychain

- (void)setUp {
    [super setUp];
    
    self.testStringKey = @"test_string_key";
    self.testNumberKey = @"test_number_key";
    self.testPrimitiveKey = @"test_primitive_key";
    
    self.testString = @"test_value";
    self.testNumber = @(10);
    self.testPrimitive = YES;
}

- (void)tearDown {
    [CMPKeychain deleteItemForKey:self.testStringKey];
    [CMPKeychain deleteItemForKey:self.testNumberKey];
    [CMPKeychain deleteItemForKey:self.testPrimitiveKey];
    
    [super tearDown];
}

- (void)testSaveItem {
    BOOL stringResult = [CMPKeychain saveItem:self.testString forKey:self.testStringKey];
    BOOL numberResult = [CMPKeychain saveItem:self.testNumber forKey:self.testNumberKey];
    BOOL primitiveResult = [CMPKeychain saveItem:@(self.testPrimitive) forKey:self.testPrimitiveKey];
    
    XCTAssertTrue(stringResult);
    XCTAssertTrue(numberResult);
    XCTAssertTrue(primitiveResult);
}

- (void)testLoadItem {
    BOOL stringResult = [CMPKeychain saveItem:self.testString forKey:self.testStringKey];
    BOOL numberResult = [CMPKeychain saveItem:self.testNumber forKey:self.testNumberKey];
    BOOL primitiveResult = [CMPKeychain saveItem:@(self.testPrimitive) forKey:self.testPrimitiveKey];
    
    XCTAssertTrue(stringResult);
    XCTAssertTrue(numberResult);
    XCTAssertTrue(primitiveResult);
    
    NSString *testString = [CMPKeychain loadItemForKey:self.testStringKey];
    NSNumber *testNumber = [CMPKeychain loadItemForKey:self.testNumberKey];
    BOOL testPrimitive = [(NSNumber *)[CMPKeychain loadItemForKey:self.testPrimitiveKey] boolValue];
    
    XCTAssertNotNil(testString);
    XCTAssertNotNil(testNumber);
    
    XCTAssertEqualObjects(testString, self.testString);
    XCTAssertEqualObjects(testNumber, self.testNumber);
    XCTAssertEqual(testPrimitive, self.testPrimitive);
}

- (void)testDeleteItem {
    BOOL stringSaveResult = [CMPKeychain saveItem:self.testString forKey:self.testStringKey];
    BOOL numberSaveResult = [CMPKeychain saveItem:self.testNumber forKey:self.testNumberKey];
    BOOL primitiveSaveResult = [CMPKeychain saveItem:@(self.testPrimitive) forKey:self.testPrimitiveKey];
    
    XCTAssertTrue(stringSaveResult);
    XCTAssertTrue(numberSaveResult);
    XCTAssertTrue(primitiveSaveResult);
    
    BOOL stringDeleteResult = [CMPKeychain deleteItemForKey:self.testStringKey];
    BOOL numberDeleteResult = [CMPKeychain deleteItemForKey:self.testNumberKey];
    BOOL primitiveDeleteResult = [CMPKeychain deleteItemForKey:self.testPrimitiveKey];
    
    XCTAssertTrue(stringDeleteResult);
    XCTAssertTrue(numberDeleteResult);
    XCTAssertTrue(primitiveDeleteResult);
    
    NSString *testString = [CMPKeychain loadItemForKey:self.testStringKey];
    NSNumber *testNumber = [CMPKeychain loadItemForKey:self.testNumberKey];
    BOOL testPrimitive = [(NSNumber *)[CMPKeychain loadItemForKey:self.testPrimitiveKey] boolValue];
    
    XCTAssertNil(testString);
    XCTAssertNil(testNumber);
    XCTAssertEqual(testPrimitive, NO);
}



@end
