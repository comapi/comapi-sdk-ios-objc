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

#import "CMPComapiClient.h"

#import "CMPRequestManager.h"
#import "CMPRequestPerformer.h"
#import "CMPAPIConfiguration.h"
#import "CMPSocketManager.h"
#import "CMPSession.h"
#import "CMPSessionAuth.h"
#import "CMPSessionManager.h"
#import "CMPSetAPNSDetailsTemplate.h"
#import "CMPAPNSDetails.h"
#import "CMPAPNSDetailsBody.h"
#import "CMPLogger.h"

@interface CMPComapiClient ()

@property (nonatomic, copy) NSString *apiSpaceID;

@property (nonatomic, strong) CMPRequestManager *requestManager;
@property (nonatomic, strong) CMPSessionManager *sessionManager;
@property (nonatomic, strong) CMPSocketManager *socketManager;
@property (nonatomic, strong) CMPAPIConfiguration *apiConfiguration;

@property (nonatomic, strong) id<CMPRequestPerforming> requestPerformer;

@end

@implementation CMPComapiClient

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration {
    self = [self initWithApiSpaceID:apiSpaceID authenticationDelegate:delegate apiConfiguration:configuration requestPerformer:[[CMPRequestPerformer alloc] init]];
    return self;
}

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration requestPerformer:(id<CMPRequestPerforming>)requestPerformer {
    self = [super init];
    
    if (self) {
        _state = CMPSDKStateInitialising;
        
        self.apiConfiguration = configuration;
        self.apiSpaceID = apiSpaceID;
        self.requestPerformer = requestPerformer;
        
        self.requestManager = [[CMPRequestManager alloc] initWithRequestPerformer:self.requestPerformer];
        self.requestManager.delegate = self;
        
        self.sessionManager = [[CMPSessionManager alloc] initWithApiSpaceID:apiSpaceID authenticationDelegate:delegate requestManager:self.requestManager sessionDelegate:self];
        
        self.socketManager = [[CMPSocketManager alloc] initWithApiSpaceID:apiSpaceID apiConfiguration:configuration socketDelegate:self];
        
        [self.sessionManager bindClient:self];
        [self.socketManager bindClient:self];
        [self.sessionManager bindSocketManager:self.socketManager];
        
        _services = [[CMPServices alloc] initWithApiSpaceID:apiSpaceID apiConfiguration:configuration requestManager:self.requestManager sessionAuthProvider:self.sessionManager];
        
        _state = CMPSDKStateInitilised;
    }
    
    return self;
}

- (NSData *)getFileLogs {
    return [[CMPLogger shared] getFileLogs];
}

- (void)addEventDelegate:(id<CMPEventDelegate>)delegate {
    [self.socketManager addEventDelegate:delegate];
}

- (void)removeEventDelegate:(id<CMPEventDelegate>)delegate {
    [self.socketManager removeEventDelegate:delegate];
}

- (void)addStateDelegate:(id<CMPStateDelegate>)delegate {
    [_stateDelegates addDelegate:delegate];
}

- (void)removeStateDelegate:(id<CMPStateDelegate>)delegate {
    [_stateDelegates removeDelegate:delegate];
}

- (NSString *)getProfileID {
    return self.sessionManager.sessionAuth.session.profileID;
}

- (BOOL)isSessionSuccessfullyCreated {
    return [self.sessionManager isSessionValid];
}

- (CMPAPNSDetailsBody *)createPushDetailsWithApnsToken:(NSString *)apnsToken {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *environment = @"";
    
    #if DEBUG
        environment = @"development";
    #else
        environment = @"production";
    #endif
    
    CMPAPNSDetails *details = [[CMPAPNSDetails alloc] initWithBundleID:bundleID environment:environment token:apnsToken];
    CMPAPNSDetailsBody *pushDetails = [[CMPAPNSDetailsBody alloc] initWithAPNSDetails:details];
    return pushDetails;
}

- (void)setPushToken:(NSString *)deviceToken completion:(void (^)(BOOL, NSError *))completion {
    CMPSetAPNSDetailsTemplate *(^builder)(NSString *) = ^(NSString *token) {
        self.sessionManager.cachedPushDetails = [self createPushDetailsWithApnsToken:deviceToken];
        NSString *sessionId = self.sessionManager.sessionAuth.session.id != nil ? self.sessionManager.sessionAuth.session.id : @"";
        return [[CMPSetAPNSDetailsTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID token:token sessionID:sessionId body:self.sessionManager.cachedPushDetails];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSNumber *> * result) {
        completion([result.object boolValue], result.error);
    }];
}

- (nullable NSURL *)linkForActionIdentifier:(NSString *)actionIdentifier actions:(NSArray<NSDictionary<NSString *, id> *> *)actions {
    if ([actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]) {
        for (NSDictionary<NSString *, id> *action in actions) {
            if ([action[@"action"] isEqualToString:CMPPushNotificationKeyDirectClick]) {
                NSString *link = action[@"link"];
                NSURL *URL = [NSURL URLWithString:link];
                if (!URL) {
                    logWithLevel(CMPLogLevelError, [NSString stringWithFormat:@"Malformed url string - %@", link], nil);
                }
                return URL;
            }
        }
    } else {
        for (NSDictionary<NSString *, id> *action in actions) {
            if ([action[@"action"] isEqualToString:actionIdentifier]) {
                NSString *link = action[@"link"];
                NSURL *URL = [NSURL URLWithString:link];
                if (!URL) {
                    logWithLevel(CMPLogLevelError, [NSString stringWithFormat:@"Malformed url string - %@", link], nil);
                }
                return URL;
            }
        }
    }
    
    return nil;
}

- (void)handleNotificationResponse:(UNNotificationResponse *)notificationResponse completion:(void (^)(BOOL, NSDictionary * _Nonnull))completion {
    //NSString *actionIdentifier = notificationResponse.actionIdentifier;
    NSDictionary *userInfo = notificationResponse.notification.request.content.userInfo;
    if ([userInfo objectForKey:@"dd_deepLink"]) {
        //NSString *corelationId = notificationResponse.notification.request.content.userInfo[@"dd_deepLink"][@"corelationId"];
        NSString *url = notificationResponse.notification.request.content.userInfo[@"dd_deepLink"][@"url"];
        NSURL *link = [NSURL URLWithString:url];
        if ([UIApplication.sharedApplication canOpenURL:link]) {
            [UIApplication.sharedApplication openURL:link options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    logWithLevel(CMPLogLevelError, [NSString stringWithFormat:@"Couldn't open URL - %@", link], nil);
                }
                if (completion) {
                    completion(success, userInfo);
                }
                return;
            }];
        } else {
            logWithLevel(CMPLogLevelError, [NSString stringWithFormat:@"Cannot open URL - %@", link], nil);
            if (completion) {
                completion(NO, userInfo);
            }
            return;
        }
    } else {
        logWithLevel(CMPLogLevelInfo, @"Deep Link URL not found", nil);
        if (completion) {
            completion(NO, userInfo);
        }
        return;
    }
}

- (void)requestManagerNeedsToken:(CMPRequestManager *)requestManager {
    [self.sessionManager authenticateWithSuccess:nil failure:nil];
}

#pragma mark - CMPSessionDelegate

- (void)didStartSession {
    [self.stateDelegates invokeDelegatesWithBlock:^(id<CMPStateDelegate> _Nonnull delegate) {
        [delegate didStartSessionWithProfileID:self.profileID];
    }];
}

- (void)didEndSessionWithError:(NSError *)error {
    [self.stateDelegates invokeDelegatesWithBlock:^(id<CMPStateDelegate> _Nonnull delegate) {
        [delegate didEndSessionWithError:error];
    }];
}

#pragma mark - CMPSocketDelegate

- (void)didConnectSocket {
    [self.stateDelegates invokeDelegatesWithBlock:^(id<CMPStateDelegate> _Nonnull delegate) {
        [delegate didConnectSocket];
    }];
}

- (void)didDisconnectSocketWithError:(NSError *)error {
    [self.stateDelegates invokeDelegatesWithBlock:^(id<CMPStateDelegate> _Nonnull delegate) {
        [delegate didDisconnectSocketWithError:error];
    }];
}

@end
