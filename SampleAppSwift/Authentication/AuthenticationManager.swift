//
//  AuthenticationManager.swift
//  SampleAppSwift
//
//  Created by Dominik Kowalski on 27/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
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
