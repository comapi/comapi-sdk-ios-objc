//
//  CMPTestMocks.h
//  comapi_ios_sdk_objective_c_tests
//
//  Created by Dominik Kowalski on 13/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMPAuthenticationDelegate.h"
#import "CMPRequestPerforming.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPTestMocks : NSObject

+ (NSString *)mockAuthenticationToken;
+ (NSString *)mockApiSpaceID;
+ (NSURL *)mockBaseURL;

@end

@interface CMPMockRequestPerformer: NSObject <CMPRequestPerforming>

@property (nonatomic, strong) NSMutableArray<NSURLRequest *> *receivedRequests;

@end

@interface CMPMockAuthenticationDelegate : NSObject <CMPAuthenticationDelegate>

@end

@interface CMPMockUserDefaults : NSObject

+ (NSUserDefaults *)mockUserDefaults;

@end

//var receivedRequests: [URLRequest] = []
//    var completionValues: [(Data?, URLResponse?, Error?)] = [
//                                                             (loadJSON(jsonName: "AuthenticationChallenge"), HTTPURLResponse.mocked(url: mockBaseURL), nil),
//                                                             (loadJSON(jsonName: "SessionAuth"), HTTPURLResponse.mocked(url: mockBaseURL), nil),
//                                                             ]
//
//    func perform(_ urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
//        if self.completionValues.count == 0 {
//            DispatchQueue.main.async {
//                completion(nil, nil, NSError())
//            }
//        }
//        else {
//            let completionValue = self.completionValues.removeFirst()
//            DispatchQueue.main.async {
//                completion(completionValue.0, completionValue.1, completionValue.2)
//            }
//        }
//    }

@interface CMPResourceLoader : NSObject

+ (NSURL *)urlForFile:(NSString *)file extension:(NSString *)extension;
+ (NSData *)loadJSONWithName:(NSString *)JSON;

@end

NS_ASSUME_NONNULL_END
