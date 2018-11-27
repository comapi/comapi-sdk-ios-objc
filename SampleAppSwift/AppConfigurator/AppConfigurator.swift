//
//  AppConfigurator.swift
//  SampleAppSwift
//
//  Created by Dominik Kowalski on 27/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
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
