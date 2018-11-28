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
