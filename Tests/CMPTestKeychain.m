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

#import "CMPComapiTest.h"

@interface CMPTestKeychain : CMPComapiTest

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
