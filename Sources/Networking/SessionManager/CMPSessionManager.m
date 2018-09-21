//
//  SessionManager.m
//  CMPComapiFoundation
//
//  Created by Dominik Kowalski on 14/08/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPSessionManager.h"
#import "CMPSession.h"
#import "CMPServices.h"

NSString * const authTokenKeychainItemNamePrefix = @"ComapiSessionToken_";
NSString * const sessionDetailsUserDefaultsPrefix = @"ComapiSessionDetails_";

@interface CMPSessionManager ()

@property (nonatomic, strong, nullable) CMPComapiClient *client;
@property (nonatomic, strong) CMPRequestManager *requestManager;

@property (nonatomic, weak, nullable) id<CMPAuthenticationDelegate> authenticationDelegate;
@property (nonatomic, copy, nullable) void(^didFinishAuthentication)(void);
@property (nonatomic, copy, nullable) void(^didFailAuthentication)(NSError *);

@property (nonatomic, strong, nonnull) NSString* apiSpaceID;
@property (nonatomic, strong, nonnull) NSString* tokenKey;
@property (nonatomic, strong, nonnull) NSString* detailsKey;

- (void)loadSessionInfo;
- (void)saveSessionInfo;

@end

@implementation CMPSessionManager

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate requestManager:(CMPRequestManager *)requestManager {
    self = [super init];
    
    if (self) {
        self.apiSpaceID = apiSpaceID;
        self.authenticationDelegate = delegate;
        self.requestManager = requestManager;
        self.tokenKey = [NSString stringWithFormat:@"%@%@", authTokenKeychainItemNamePrefix, self.apiSpaceID];
        self.detailsKey = [NSString stringWithFormat:@"%@%@", sessionDetailsUserDefaultsPrefix, self.apiSpaceID];
        
        [self loadSessionInfo];
    }
    
    return self;
}

- (BOOL)isSessionValid {
    if (self.sessionAuth != nil && self.sessionAuth.session != nil && self.sessionAuth.session.expiresOn != nil) {
        return self.sessionAuth.session.isActive && [self.sessionAuth.session.expiresOn compare:[NSDate date]] == NSOrderedDescending;
    }
    
    return false;
}

- (void)bindClient:(CMPComapiClient *)client {
    self.client = client;
}

- (void)loadSessionInfo {
    if ([CMPKeychain loadItemForKey:self.tokenKey] == nil || [[NSUserDefaults standardUserDefaults] objectForKey:self.detailsKey] == nil) {
        self.sessionAuth = nil;
        return;
    }
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:self.detailsKey];
    CMPSession *session = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *token = [CMPKeychain loadItemForKey:self.tokenKey];
    if (token && session) {
        CMPSessionAuth *sessionAuth = [[CMPSessionAuth alloc] initWithToken:token session:session];
        self.sessionAuth = sessionAuth;
        [self.requestManager updateToken:token];
    }
}

- (void)saveSessionInfo {
    if (!self.sessionAuth) {
        return;
    }
    
    [CMPKeychain saveItem:self.sessionAuth.token forKey:self.tokenKey];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.sessionAuth.session];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:self.detailsKey];
    }
}

// MARK: - CMPAuthChallengeHandler

- (void)authenticationFailedWithError:(nonnull NSError *)error {
    [self.requestManager tokenUpdateFailed];
    if (self.didFailAuthentication) {
        self.didFailAuthentication(error);
    }
    self.client.state = CMPSDKStateSessionOff;
}

- (void)authenticationFinishedWithSessionAuth:(nonnull CMPSessionAuth *)sessionAuth {
    logWithLevel(CMPLogLevelInfo, @"Authorization finished with sessionAuth:", sessionAuth, nil);
    
    self.sessionAuth = sessionAuth;
    [self saveSessionInfo];
    [self.requestManager updateToken:sessionAuth.token];
    
    NSTimeInterval secondsTillTokenExpiry = sessionAuth.session.expiresOn.timeIntervalSinceNow;
    logWithLevel(CMPLogLevelInfo, @"secondsTillTokenExpiry:", @(secondsTillTokenExpiry), nil);
    
    __weak CMPSessionManager *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secondsTillTokenExpiry * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (weakSelf.sessionAuth.session.id == sessionAuth.session.id) {
            [weakSelf authenticateWithSuccess:nil failure:nil];
        }
    });
    
    if (self.didFinishAuthentication) {
        self.didFinishAuthentication();
    }
    
    self.client.state = CMPSDKStateSessionActive;
}

- (void)handleAuthenticationChallenge:(nonnull CMPAuthenticationChallenge *)challenge {
    __weak CMPSessionManager *weakSelf = self;
    [self.authenticationDelegate clientWith:self.client didReceiveAuthenticationChallenge:challenge completion:^(NSString * _Nullable token) {
        if (token) {
            NSString *authenticationID = challenge.authenticationID != nil ? challenge.authenticationID : @"";
            [weakSelf.client.services.session continueAuthenticationWithToken:token forAuthenticationID:authenticationID challengeHandler:self];
        } else {
            [weakSelf authenticationFailedWithError:[CMPErrors authenticationErrorWithStatus :CMPAuthenticationErrorMissingTokenStatusCode underlyingError:nil]];
        }
    }];
}

// MARK: - CMPSessionAuthProvider

- (void)authenticateWithSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure {
    if (self.client) {
        self.client.state = CMPSDKStateSessionStarting;
        self.didFinishAuthentication = success;
        self.didFailAuthentication = failure;
        [self.client.services.session startAuthenticationWithChallengeHandler:self];
    }
}

@end
