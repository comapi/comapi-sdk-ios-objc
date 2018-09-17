//
//  CMPTestMocks.m
//  comapi_ios_sdk_objective_c_tests
//
//  Created by Dominik Kowalski on 13/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPTestMocks.h"



@implementation CMPTestMocks

+ (NSString *)mockApiSpaceID {
    return @"MOCK_API_SPACE_ID";
}

+ (NSURL *)mockBaseURL {
    return [NSURL URLWithString:@"http://192.168.99.100:8000"];
}

@end

@implementation CMPResourceLoader

+ (NSBundle *)bundle {
    return [NSBundle bundleForClass:CMPTestMocks.class];
}

+ (NSURL *)urlForFile:(NSString *)file extension:(NSString *)extension {
    return [[CMPResourceLoader bundle] URLForResource:file withExtension:extension];
}

+ (NSData *)loadJSONWithName:(NSString *)JSON {
    return [NSData dataWithContentsOfURL:[CMPResourceLoader urlForFile:JSON extension:@"json"]];
}

//private let bundle = Bundle(for: RequestManagerProtocolTests.self)
//
//private func url(for filename: String, extension: String) -> URL {
//
//    return bundle.url(forResource: filename, withExtension: `extension`)!
//}
//
//func loadJSON(jsonName: String) -> Data {
//    print(jsonName)
//    return try! Data(contentsOf: url(for: "\(jsonName)", extension: "json"))
//}
//
//func loadFile(fileName: String, extension: String) -> Data {
//    print(fileName)
//    return try! Data(contentsOf: url(for: fileName, extension: `extension`))
//}

@end
//let mockBaseURL = URL(string: "http://192.168.99.100:8000")!
//let mockAPISpaceID = "MOCK_API_SPACE_ID"
//
//struct GenericError: Error {
//
//}
//let genericError = GenericError()
//
////MARK:Mocked HTTPURLResponse
//

//
////MARK:RequestDelegate
//
//final class MockRequestPerformer: RequestPerforming {
//    var receivedRequests: [URLRequest] = []
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
//}
//
////MARK:AuthenticationDelegate
//
//let mockAuthenticationDelegate = MockAuthenticationDelegate(tokenForCallback: "Token")
//
//final class MockAuthenticationDelegate: AuthenticationDelegate {
//    var tokenForCallback: String?
//
//    init(tokenForCallback: String?) {
//        self.tokenForCallback = tokenForCallback
//    }
//
//    func client(_ client: ComapiClient,
//                didReceiveAuthenticationChallenge authenticationChallenge: AuthenticationChallenge,
//                completion continueWithToken: @escaping (String?) -> Void) {
//
//        DispatchQueue.main.async {
//            continueWithToken(self.tokenForCallback)
//        }
//    }
//}
//
//// MARK: Loading resources
//
//private let bundle = Bundle(for: RequestManagerProtocolTests.self)
//
//private func url(for filename: String, extension: String) -> URL {
//
//    return bundle.url(forResource: filename, withExtension: `extension`)!
//}
//
//func loadJSON(jsonName: String) -> Data {
//    print(jsonName)
//    return try! Data(contentsOf: url(for: "\(jsonName)", extension: "json"))
//}
//
//func loadFile(fileName: String, extension: String) -> Data {
//    print(fileName)
//    return try! Data(contentsOf: url(for: fileName, extension: `extension`))
//}
//
////MARK:Comparing collections
//
//public func ==(lhs: [AnyHashable: Any], rhs: [AnyHashable: Any] ) -> Bool {
//    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
//}
//
//public func ==(lhs: [Any], rhs: [Any] ) -> Bool {
//    return NSArray(array: lhs).isEqual(to: rhs)
//}
//
//func isJSON(inData lhsJSONData: Data, equalToJSONInData rhsJSONData: Data) -> Bool {
//    let lhsJSON = try! JSONSerialization.jsonObject(with: lhsJSONData, options: []) as! NSObject
//    let rhsJSON = try! JSONSerialization.jsonObject(with: rhsJSONData, options: []) as! NSObject
//
//    switch (lhsJSON, rhsJSON) {
//        case (let lhs as [AnyHashable : Any], let rhs as [AnyHashable : Any]): return lhs == rhs
//        case (let lhs as [Any], let rhs as [Any]): return lhs == rhs
//        default: return false
//    }
//}
//
////MARK:RequestTemplate tests helpers
//
//struct RequestTemplateExpectations {
//    var scheme: String
//    var host: String
//    var port: Int
//    var pathComponents: [String]
//    var query: [String: String]?
//
//    var httpHeaders: Set<HTTPHeader>?
//    var httpBody: Data?
//    var httpMethod: HTTPMethod
//}
//
//extension RequestTemplate {
//    func test(with expectations: RequestTemplateExpectations) {
//
//        expect(self.scheme) == expectations.scheme
//        expect(self.host) == expectations.host
//        expect(self.port) == expectations.port
//        expect(self.pathComponents) == expectations.pathComponents
//
//        if let query = expectations.query {
//            expect(self.query) == query
//        } else {
//            expect(self.query).to(beNil())
//        }
//
//        if let httpHeaders = expectations.httpHeaders {
//            expect(self.httpHeaders) == httpHeaders
//        } else {
//            expect(self.httpHeaders).to(beNil())
//        }
//
//        if let httpBody = expectations.httpBody {
//            print(httpBody.count)
//            expect(self.httpBody) == httpBody
//        } else {
//            expect(self.httpBody).to(beNil())
//        }
//
//        expect(self.httpMethod) == expectations.httpMethod
//
//        // test if creating urlRequest fails
//        _ = try! self.urlRequest()
//    }
//}
