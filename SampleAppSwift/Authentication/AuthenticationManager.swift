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

import JWT

class JWTokenGenerator {
    
    struct AuthHeaders {
        static let HeaderType = "JWT"
    }
    
    static func generate(tokenFor nonce: String, profileId: String, issuer: String, audience: String, secret: String) -> String {
        let now = Date()
        let exp = Calendar.current.date(byAdding: .day, value: 30, to: now)!
        
        let base64SecretKey = secret.data(using: .utf8)!
        
        let headers = ["typ" : NSString.init(string: AuthHeaders.HeaderType)] as [AnyHashable : Any]
        
        let claims = ["nonce" : NSString.init(string: nonce),
                      "sub" : NSString.init(string: profileId),
                      "iss" : NSString.init(string: issuer),
                      "aud" : NSString.init(string: audience),
                      "iat" : NSNumber(value: now.timeIntervalSince1970),
                      "exp" : NSNumber(value: exp.timeIntervalSince1970)] as [AnyHashable : Any]
        
        let algorithm = JWTAlgorithmFactory.algorithm(byName: "HS256")
        
        let e = JWTBuilder.encodePayload(claims)!
        
        let h = e.headers(headers)!
        let s = h.secretData(base64SecretKey)!
        let b = s.algorithm(algorithm)!
        let token = b.encode
        
        print(token!)
        return token!
    }
}
