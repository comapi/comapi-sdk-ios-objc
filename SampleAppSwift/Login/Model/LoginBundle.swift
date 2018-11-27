//
//  LoginBundle.swift
//  SampleAppSwift
//
//  Created by Dominik Kowalski on 27/11/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

import UIKit

class LoginBundle: NSObject, NSCoding {
    
    var apiSpaceId: String?
    var profileId: String?
    var issuer: String?
    var audience: String?
    var secret: String?
    
    init(apiSpaceId: String?, profileId: String?, issuer: String?, audience: String?, secret: String?) {
        self.apiSpaceId = apiSpaceId
        self.profileId = profileId
        self.issuer = issuer
        self.audience = audience
        self.secret = secret
        
        super.init()
    }
    
    func isValid() -> Bool {
        return apiSpaceId != nil && profileId != nil && issuer != nil && audience != nil && secret != nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.apiSpaceId = aDecoder.decodeObject(forKey: "apiSpaceId") as? String
        self.profileId = aDecoder.decodeObject(forKey: "profileId") as? String
        self.issuer = aDecoder.decodeObject(forKey: "issuer") as? String
        self.audience = aDecoder.decodeObject(forKey: "audience") as? String
        self.secret = aDecoder.decodeObject(forKey: "secret") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.apiSpaceId, forKey: "apiSpaceId")
        aCoder.encode(self.profileId, forKey: "profileId")
        aCoder.encode(self.issuer, forKey: "issuer")
        aCoder.encode(self.audience, forKey: "audience")
        aCoder.encode(self.secret, forKey: "secret")
    }
}
