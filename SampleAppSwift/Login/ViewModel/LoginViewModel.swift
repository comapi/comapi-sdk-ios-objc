//
//  LoginViewModel.swift
//  SampleAppSwift
//
//  Created by Dominik Kowalski on 27/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

import UIKit
import CMPComapiFoundation

class LoginViewModel: NSObject {
    
    struct LoginError: Error {
        var localizedDescription: String {
            return "Missing login information"
        }
    }
    
    var loginInfo: LoginBundle
    var client: ComapiClient!
    
    override init() {
        loginInfo = LoginBundle(apiSpaceId: "be466e4b-1340-41fc-826e-20445ab658f1", profileId: "sub", issuer: "local", audience: "local", secret: "secret")
        
        super.init()
    }
    
    private func saveLocally() {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: loginInfo)
        UserDefaults.standard.set(encodedData, forKey: "loginInfo")
        UserDefaults.standard.synchronize()
    }
    
    func configure(completion: @escaping (Error?) -> ()) {
        if !loginInfo.isValid() {
            completion(LoginError())
            return
        }
        
        let config = ComapiConfig(apiSpaceID: loginInfo.apiSpaceId!, authenticationDelegate: self)
        
        client = Comapi.initialise(with: config)
        client.services.session.startSession(completion: { [weak self] in
            self?.saveLocally()
            completion(nil)
        }) { (error) in
            completion(error)
        }
    }
}

extension LoginViewModel: AuthenticationDelegate {
    func client(_ client: ComapiClient, didReceive challenge: AuthenticationChallenge, completion continueWithToken: @escaping (String?) -> Void) {
        let token = JWTokenGenerator.generate(tokenFor: challenge.nonce, profileId: loginInfo.profileId!, issuer: loginInfo.issuer!, audience: loginInfo.audience!, secret: loginInfo.secret!)
        continueWithToken(token)
    }
}

