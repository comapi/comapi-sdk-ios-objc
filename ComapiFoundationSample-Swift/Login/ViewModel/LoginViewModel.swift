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

import UIKit


class LoginViewModel: NSObject {
    
    struct LoginError: Error {
        var localizedDescription: String {
            return "Missing login information"
        }
    }
    
    var loginInfo: LoginBundle
    var client: ComapiClient!
    
    override init() {
        if let info = Bundle.main.infoDictionary,
            let apiSpace = info["API_SPACE"] as? String,
            let issuer = info["ISSUER"] as? String,
            let audience = info["AUDIENCE"] as? String,
            let secret = info["SECRET"] as? String {
            
            loginInfo = LoginBundle(apiSpaceId: apiSpace, profileId: "", issuer: issuer, audience: audience, secret: secret)
        } else {
            loginInfo = LoginBundle()
        }
        
        super.init()
    }
    
    private func saveLocally() {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: loginInfo)
        UserDefaults.standard.set(encodedData, forKey: "loginInfoSwift")
        UserDefaults.standard.synchronize()
    }
    
    func configure(completion: @escaping (Error?) -> ()) {
        if !loginInfo.isValid() {
            completion(LoginError())
            return
        }
        
        guard let info = Bundle.main.infoDictionary,
            let scheme = info["SERVER_SCHEME"] as? String,
            let host = info["SERVER_HOST"] as? String,
            let port = info["SERVER_PORT"] as? String else { return }
        
        let apiConfig = APIConfiguration(scheme: scheme, host: host, port: UInt(port)!)
        
        let config = ComapiConfig()
            .setAuthDelegate(self)
            .setLogLevel(.verbose)
            .setApiSpaceID(loginInfo.apiSpaceId!)
            .setApi(apiConfig)
        
        client = Comapi.initialise(with: config)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.configurator.client = client
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

