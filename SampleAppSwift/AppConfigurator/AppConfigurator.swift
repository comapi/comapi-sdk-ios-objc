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

import CMPComapiFoundation

class AppConfigurator: NSObject {
    let window: UIWindow
    
    var client: ComapiClient?
    var loginInfo: LoginBundle?
    
    weak var appDelegate: AppDelegate?
    
    init(window: UIWindow) {
        self.window = window
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        super.init()
        
        Comapi.initialise(with: ComapiConfig(apiSpaceID: "", authenticationDelegate: self))
    }
    
    func checkForLoginInfo() -> LoginBundle? {
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "loginInfo") as? Data, let bundle = NSKeyedUnarchiver.unarchiveObject(with: data) as? LoginBundle {
            return bundle
        }
        return nil
    }
    
    func start() {
        if let loginInfo = checkForLoginInfo(), loginInfo.isValid() {
            self.loginInfo = loginInfo
            let config = ComapiConfig(apiSpaceID: loginInfo.apiSpaceId!, authenticationDelegate: self)
            client = Comapi.initialise(with: config)
            client?.services.session.startSession(completion: { [weak self] in
                guard let `self` = self else { return }
                let rootController = ConversationViewController(viewModel: ConversationViewModel(client: self.client!))
                let navController = UINavigationController(rootViewController: rootController)
                
                self.window.makeKeyAndVisible()
                self.window.rootViewController = navController
            }) { (error) in
                fatalError("error starting session")
            }
        } else {
            let rootController = LoginViewController(viewModel: LoginViewModel())
            let navController = UINavigationController(rootViewController: rootController)
            
            window.makeKeyAndVisible()
            window.rootViewController = navController
        }
    }
    
    func restart() {
        UserDefaults.standard.set(nil, forKey: "loginInfo")
        let rootController = LoginViewController(viewModel: LoginViewModel())
        let navController = UINavigationController(rootViewController: rootController)
        
        window.makeKeyAndVisible()
        window.rootViewController = navController
    }
}

extension AppConfigurator: AuthenticationDelegate {
    func client(_ client: ComapiClient, didReceive challenge: AuthenticationChallenge, completion continueWithToken: @escaping (String?) -> Void) {
        guard  let profileId = loginInfo?.profileId, let issuer = loginInfo?.issuer, let audience = loginInfo?.audience, let secret = loginInfo?.secret else {
            print("missing token info, returning...")
            return
        }
        let token = JWTokenGenerator.generate(tokenFor: challenge.nonce, profileId: profileId, issuer: issuer, audience: audience, secret: secret)
        continueWithToken(token)
    }
}
