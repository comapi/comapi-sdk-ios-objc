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

#import <Foundation/Foundation.h>

//! Project version number for CMPComapiFoundation.
FOUNDATION_EXPORT double CMPComapiFoundationVersionNumber NS_SWIFT_NAME(ComapiFoundationVersionNumber);

//! Project version string for CMPComapiFoundation.
FOUNDATION_EXPORT const unsigned char CMPComapiFoundationVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CMPComapiFoundation/PublicHeader.h>

#import "CMPComapiFoundation.h"
#import "CMPComapiClient.h"
#import "CMPComapi.h"
#import "CMPAPIConfiguration.h"
#import "CMPComapiConfig.h"
#import "CMPLogConfig.h"
#import "CMPConstants.h"
#import "CMPErrors.h"
#import "CMPLog.h"
#import "CMPLogger.h"
#import "CMPLogLevel.h"
#import "CMPFileDestination.h"
#import "CMPLoggingDestination.h"
#import "CMPXcodeConsoleDestination.h"
#import "CMPAuthenticationDelegate.h"
#import "CMPHTTPHeader.h"
#import "CMPJSONConstructable.h"
#import "CMPJSONDecoding.h"
#import "CMPJSONEncoding.h"
#import "CMPJSONRepresentable.h"
#import "CMPRequestManager.h"
#import "CMPRequestPerformer.h"
#import "CMPRequestPerforming.h"
#import "CMPBaseService.h"
#import "CMPServices.h"
#import "CMPMessagingService.h"
#import "CMPProfileService.h"
#import "CMPSessionService.h"
#import "CMPAuthChallengeHandler.h"
#import "CMPSessionAuthProvider.h"
#import "CMPSessionDelegate.h"
#import "CMPSessionManager.h"
#import "CMPEventDelegate.h"
#import "CMPEventParser.h"
#import "CMPEvent.h"
#import "CMPConversationEvents.h"
#import "CMPConversationMessageEvents.h"
#import "CMPProfileEvents.h"
#import "CMPSocketEvents.h"
#import "CMPAddConversationTemplate.h"
#import "CMPAddParticipantsTemplate.h"
#import "CMPContentUploadTemplate.h"
#import "CMPDeleteConversationTemplate.h"
#import "CMPEventQueryTemplate.h"
#import "CMPGetConversationsTemplate.h"
#import "CMPGetConversationTemplate.h"
#import "CMPGetMessagesTemplate.h"
#import "CMPGetParticipantsTemplate.h"
#import "CMPRemoveParticipantsTemplate.h"
#import "CMPSendMessagesTemplate.h"
#import "CMPSendStatusUpdateTemplate.h"
#import "CMPUpdateConversationTemplate.h"
#import "CMPContentData.h"
#import "CMPContentUploadResult.h"
#import "CMPConversation.h"
#import "CMPConversationParticipant.h"
#import "CMPConversationScope.h"
#import "CMPConversationUpdate.h"
#import "CMPGetMessagesResult.h"
#import "CMPMessage.h"
#import "CMPMessageAlert.h"
#import "CMPMessageAlertPlatforms.h"
#import "CMPMessageContext.h"
#import "CMPMessageDeliveryStatus.h"
#import "CMPMessagePart.h"
#import "CMPMessageParticipant.h"
#import "CMPMessageStatus.h"
#import "CMPMessageStatusUpdate.h"
#import "CMPNewConversation.h"
#import "CMPOrphanedEvent.h"
#import "CMPRole.h"
#import "CMPRoleAttributes.h"
#import "CMPRoles.h"
#import "CMPSendableMessage.h"
#import "CMPSendMessagesResult.h"
#import "CMPGetProfileTemplate.h"
#import "CMPPatchProfileTemplate.h"
#import "CMPQueryProfilesTemplate.h"
#import "CMPUpdateProfileTemplate.h"
#import "CMPProfile.h"
#import "CMPQueryBuilder.h"
#import "CMPSetAPNSDetailsTemplate.h"
#import "CMPAPNSDetails.h"
#import "CMPAPNSDetailsBody.h"
#import "CMPHTTPRequestTemplate.h"
#import "CMPRequestTemplate.h"
#import "CMPRequestTemplateResult.h"
#import "CMPResult.h"
#import "CMPAuthorizeSessionTemplate.h"
#import "CMPDeleteSessionTemplate.h"
#import "CMPStartNewSessionTemplate.h"
#import "CMPAuthenticationChallenge.h"
#import "CMPAuthorizeSessionBody.h"
#import "CMPSession.h"
#import "CMPSessionAuth.h"
#import "CMPSocketTemplate.h"
#import "CMPURLResult.h"
#import "CMPBroadcastDelegate.h"
#import "CMPSocketDelegate.h"
#import "CMPSocketManager.h"
#import "CMPKeychain.h"
#import "CMPUtilities.h"
#import "NSData+CMPUtility.h"
#import "NSDate+CMPUtility.h"
#import "NSDateFormatter+CMPUtility.h"
#import "NSString+CMPUtility.h"
#import "NSURLRequest+CMPUtility.h"
#import "NSURLResponse+CMPUtility.h"





