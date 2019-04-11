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

#import "CMPMessagePartCell.h"

#import "CMPImagePartView.h"
#import "CMPTextPartView.h"
#import "CMPPartType.h"

@interface CMPMessagePartCell ()

@property (nonatomic, strong) NSMutableArray<UIView *> *partViews;

@end

@implementation CMPMessagePartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.dateLabel = [UILabel new];
        self.profileLabel = [UILabel new];
        self.statusLabel = [UILabel new];
        self.partViews = [NSMutableArray new];
        
        [self configureSelf];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self reset];
}

- (void)reset {
    for (UIView *v in self.contentView.subviews) {
        [NSLayoutConstraint deactivateConstraints:v.constraints];
        [v removeFromSuperview];
    }
    self.profileLabel.text = nil;
    self.dateLabel.text = nil;
    self.statusLabel.text = nil;
}

- (void)configureSelf {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
}

- (CMPPartType)partTypeForMessagePart:(CMPMessagePart *)messagePart {
    if ([messagePart.type isEqualToString:@"text/plain"]) {
        return CMPPartTypeText;
    } else if ([messagePart.type isEqualToString:@"comapi/upl"]) {
        return CMPPartTypeUpload;
    } else if ([messagePart.type isEqualToString:@"image/jpg"] || [messagePart.type isEqualToString:@"image/jpeg"]) {
        return CMPPartTypeJPG;
    } else if ([messagePart.type isEqualToString:@"image/png"]) {
        return CMPPartTypePNG;
    }
    
    return CMPPartTypeText;
}

- (UIView *)generatePartsView:(NSArray<CMPMessagePart *> *)parts {
    self.partViews = [NSMutableArray new];
    UIView *view = [UIView new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    for (int i = 0; i < parts.count; i++) {
        UIView *partView;
        CMPPartType type = [self partTypeForMessagePart:parts[i]];
        if (type == CMPPartTypeText) {
            partView = [[CMPTextPartView alloc] init];
        } else if (type == CMPPartTypePNG || type == CMPPartTypeJPG || type == CMPPartTypeUpload) {
            partView = [[CMPImagePartView alloc] init];
        } else {
            partView = [UIView new];
        }
        [view addSubview:partView];
        NSLayoutConstraint *top;
        if (i == 0) {
            top = [partView.topAnchor constraintEqualToAnchor:view.topAnchor constant:0];
        } else {
            top = [partView.topAnchor constraintEqualToAnchor:((UIView *)self.partViews[i - 1]).bottomAnchor constant:0];
        }
        NSLayoutConstraint *leading = [partView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:0];
        NSLayoutConstraint *trailing = [partView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:0];
        NSLayoutConstraint *bottom;
        if (i == parts.count - 1) {
            bottom = [partView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor];
        }
        
        NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray new];
        [constraints addObject:leading];
        [constraints addObject:trailing];
        [constraints addObject:top];
        
        if (bottom) {
            [constraints addObject:bottom];
        }
        
        [NSLayoutConstraint activateConstraints:constraints];
        [self.partViews addObject:(UIView *)partView];
    }
    
    return view;
}

- (void)configureProfileLabel:(NSString *)profile ownership:(CMPMessageOwnership)ownership {
    self.profileLabel.textColor = ownership == CMPMessageOwnershipSelf ? UIColor.whiteColor : UIColor.blackColor;
    self.profileLabel.textAlignment = ownership == CMPMessageOwnershipSelf ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.profileLabel.font = [UIFont systemFontOfSize:13];
    self.profileLabel.numberOfLines = 0;
    self.profileLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.profileLabel.text = profile;
    
    [self.contentView addSubview:self.profileLabel];
    
    NSLayoutConstraint *top = [self.profileLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8];
    NSLayoutConstraint *centerX = [self.profileLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor];
    
    [NSLayoutConstraint activateConstraints:@[top, centerX]];
}

- (void)configureDateLabel:(NSDate *)date ownership:(CMPMessageOwnership)ownership {
    self.dateLabel.textColor = ownership == CMPMessageOwnershipSelf ? UIColor.whiteColor : UIColor.blackColor;
    self.dateLabel.textAlignment = ownership == CMPMessageOwnershipSelf ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.dateLabel.font = [UIFont systemFontOfSize:11];
    self.dateLabel.numberOfLines = 0;
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateLabel.text = [date ISO8061String];
    
    [self.contentView addSubview:self.dateLabel];
    
    NSLayoutConstraint *top = [self.dateLabel.topAnchor constraintEqualToAnchor:self.profileLabel.bottomAnchor constant:8];
    NSLayoutConstraint *side;
    if (ownership == CMPMessageOwnershipSelf) {
        side = [self.dateLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-22];
    } else {
        side = [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:22];
    }
    
    [NSLayoutConstraint activateConstraints:@[top, side]];
}

- (void)configureStatusLabel:(CMPMessage *)message participants:(NSArray<CMPConversationParticipant *> *)participants ownership:(CMPMessageOwnership)ownership {
    self.statusLabel.textColor = ownership == CMPMessageOwnershipSelf ? UIColor.whiteColor : UIColor.blackColor;
    self.statusLabel.textAlignment = ownership == CMPMessageOwnershipSelf ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.statusLabel.font = [UIFont systemFontOfSize:9];
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary<NSString *, CMPMessageStatus *> *statuses = message.statusUpdates;

    if (statuses == nil || statuses.count == 0) {
        self.statusLabel.text = @"sent";
    } else {
        for (CMPConversationParticipant *p in participants) {
            if (![p.id isEqualToString:message.context.from.id]) {
                if (message.statusUpdates[p.id] != nil) {
                    CMPMessageDeliveryStatus status = message.statusUpdates[p.id].status;
                    switch (status) {
                        case CMPMessageDeliveryStatusDelivered:
                            self.statusLabel.text = @"delivered";
                            break;
                        case CMPMessageDeliveryStatusRead:
                            self.statusLabel.text = @"read";
                            break;
                    }
                    break;
                }
            }
        }
    }

    [self.contentView addSubview:self.statusLabel];
    
    if (_partViews && _partViews.count > 0) {
        NSLayoutConstraint *top = [self.statusLabel.topAnchor constraintEqualToAnchor:((UIView *)self.partViews.lastObject).bottomAnchor];
        NSLayoutConstraint *bottom = [self.statusLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8];
        bottom.priority = 999;
        NSLayoutConstraint *side;
        if (ownership == CMPMessageOwnershipSelf) {
            side = [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-22];
        } else {
            side = [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:22];
        }
        
        [NSLayoutConstraint activateConstraints:@[top, bottom, side]];
    }
}

- (void)configurePartsView:(CMPMessage *)message ownership:(CMPMessageOwnership)ownership downloader:(CMPImageDownloader *)downloader {
    UIView *partsView = [self generatePartsView:message.parts];
    
    [self.contentView addSubview:partsView];
    
    NSLayoutConstraint *top = [partsView.topAnchor constraintEqualToAnchor:self.dateLabel.bottomAnchor constant:4];
    NSLayoutConstraint *side;
    NSLayoutConstraint *bottom;
    if (ownership == CMPMessageOwnershipSelf) {
        side = [partsView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:0];
        [NSLayoutConstraint activateConstraints:@[top, side]];
    } else {
        side = [partsView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:0];
        bottom = [partsView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8];
        [NSLayoutConstraint activateConstraints:@[top, bottom, side]];
    }
}

- (void)configureWithMessage:(CMPMessage *)message participants:(NSArray<CMPConversationParticipant *> *)participants ownership:(CMPMessageOwnership)ownership downloader:(CMPImageDownloader *)downloader {
    [self configureProfileLabel:message.context.from.id ownership:ownership];
    [self configureDateLabel:message.context.sentOn ownership:ownership];
    [self configurePartsView:message ownership:ownership downloader:downloader];
    
    if (ownership == CMPMessageOwnershipSelf) {
        [self configureStatusLabel:message participants:participants ownership:ownership];
    }
    
    for (int i = 0; i < message.parts.count; i++) {
        if ([_partViews[i] isKindOfClass:CMPTextPartView.class]) {
            [(id<CMPMessagePartConfigurable>)_partViews[i] configureWithMessagePart:message.parts[i] ownership:ownership];
        } else if ([_partViews[i] isKindOfClass:CMPImagePartView.class]) {
            [(id<CMPMessagePartConfigurable>)_partViews[i] configureWithMessagePart:message.parts[i] ownership:ownership downloader:downloader];
        }
    }
}

- (void)configureWithMessage:(CMPMessage *)message profileID:(NSString *)profileID ownership:(CMPMessageOwnership)ownership downloader:(CMPImageDownloader *)downloader {
    
}


@end
