//
//  CMPBaseService.h
//  comapi-ios-sdk-objective-c
//
//  Created by Dominik Kowalski on 22/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPAPIConfiguration.h"
#import "CMPRequestManager.h"

@interface CMPBaseService : NSObject

@property (nonatomic, strong) NSString *apiSpaceID;
@property (nonatomic, strong) CMPAPIConfiguration *apiConfiguration;
@property (nonatomic, strong) CMPRequestManager *requestManager;

@end

/*
 public class ServiceBase: Service {
 internal let apiSpaceId: String
 internal let apiConfiguration: APIConfiguration
 internal let requestManager: RequestManager
 internal var sessionAuthProvider: SessionAuthProvider
 
 init(apiSpaceId: String,
 apiConfiguration: APIConfiguration,
 requestManager: RequestManager,
 sessionAuthProvider: SessionAuthProvider){
 self.apiSpaceId = apiSpaceId
 self.apiConfiguration = apiConfiguration
 self.requestManager = requestManager
 self.sessionAuthProvider = sessionAuthProvider
 }
 }
 */
