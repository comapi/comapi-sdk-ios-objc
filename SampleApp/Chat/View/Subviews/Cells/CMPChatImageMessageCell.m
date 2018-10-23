//
//  CMPChatImageMessageCell.m
//  SampleApp
//
//  Created by Dominik Kowalski on 16/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPChatImageMessageCell.h"
#import "NSDate+CMPUtility.h"

CGFloat const kMaxImageViewSize = 250;

@interface CMPChatImageMessageCell ()

@property (nonatomic, strong) NSLayoutConstraint *bubbleHeight;
@property (nonatomic, strong) NSLayoutConstraint *bubbleWidth;

@end

@implementation CMPChatImageMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.bubbleView = [UIView new];
        self.contentImageView = [UIImageView new];
        self.dateLabel = [UILabel new];
        self.loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [self configure];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.dateLabel.text = nil;
    self.contentImageView.image = nil;
}

- (void)configure {
//    [self customizeWithOwnership:CMPMessageOwnershipSelf];
    [self layout];
//    [self constrainWithOwnership:CMPMessageOwnershipSelf];
}

- (void)customizeWithOwnership:(CMPMessageOwnership)ownership {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    
    self.bubbleView.backgroundColor = ownership == CMPMessageOwnershipSelf ? UIColor.whiteColor : UIColor.blackColor;
    self.bubbleView.layer.cornerRadius = 15;
    self.bubbleView.layer.masksToBounds = YES;
    self.bubbleView.layer.shadowColor = UIColor.blackColor.CGColor;
    self.bubbleView.layer.shadowOffset = CGSizeMake(0, 4);
    self.bubbleView.layer.shadowRadius = 4;
    self.bubbleView.layer.shadowOpacity = 0.14;
    self.bubbleView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.bubbleView.layer.borderWidth = 1.0;
    self.bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.backgroundColor = UIColor.grayColor;
    self.contentImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.loader.hidesWhenStopped = YES;
    self.loader.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.dateLabel.textColor = ownership == CMPMessageOwnershipSelf ? UIColor.whiteColor : UIColor.blackColor;
    self.dateLabel.textAlignment = ownership == CMPMessageOwnershipSelf ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.dateLabel.font = [UIFont systemFontOfSize:11];
    self.dateLabel.numberOfLines = 0;
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layout {
    [self.contentView addSubview:self.bubbleView];
    [self.contentView addSubview:self.dateLabel];
    
    [self.bubbleView addSubview:self.contentImageView];
    
    [self.contentImageView addSubview:self.loader];
}

- (void)constrainWithOwnership:(CMPMessageOwnership)ownership {
    _bubbleWidth = nil;
    _bubbleHeight = nil;
    [NSLayoutConstraint deactivateConstraints:[self.contentView constraints]];
    [NSLayoutConstraint deactivateConstraints:[self.dateLabel constraints]];
    [NSLayoutConstraint deactivateConstraints:[self.bubbleView constraints]];
    [NSLayoutConstraint deactivateConstraints:[self.contentImageView constraints]];
    [NSLayoutConstraint deactivateConstraints:[self.loader constraints]];
    
    NSLayoutConstraint *dateTop = [self.dateLabel.topAnchor constraintEqualToAnchor:self.dateLabel.superview.topAnchor constant:2];
    NSLayoutConstraint *dateHeight = [self.dateLabel.heightAnchor constraintGreaterThanOrEqualToConstant:10];
    NSLayoutConstraint *dateSide;
    if (ownership == CMPMessageOwnershipSelf) {
        dateSide = [self.dateLabel.trailingAnchor constraintEqualToAnchor:self.dateLabel.superview.trailingAnchor constant:-18];
    } else {
        dateSide = [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.dateLabel.superview.leadingAnchor constant:18];
    }
    
    [NSLayoutConstraint activateConstraints:@[dateTop, dateSide, dateHeight]];
    
    NSLayoutConstraint *bubbleTop = [self.bubbleView.topAnchor constraintEqualToAnchor:self.dateLabel.bottomAnchor constant:4];
    NSLayoutConstraint *bubbleBottom = [self.bubbleView.bottomAnchor constraintEqualToAnchor:self.bubbleView.superview.bottomAnchor constant:-8];
    _bubbleWidth = [self.bubbleView.widthAnchor constraintEqualToConstant:100];
    _bubbleHeight = [self.bubbleView.heightAnchor constraintEqualToConstant:100];
    NSLayoutConstraint *bubbleSide;
    if (ownership == CMPMessageOwnershipSelf) {
        bubbleSide = [self.bubbleView.trailingAnchor constraintEqualToAnchor:self.bubbleView.superview.trailingAnchor constant:-14];
    } else {
        bubbleSide = [self.bubbleView.leadingAnchor constraintEqualToAnchor:self.bubbleView.superview.leadingAnchor constant:14];
    }
    
    [NSLayoutConstraint activateConstraints:@[bubbleTop, bubbleBottom, bubbleSide, _bubbleWidth, _bubbleHeight]];
    
    NSLayoutConstraint *contentViewTop = [self.contentImageView.topAnchor constraintEqualToAnchor:self.contentImageView.superview.topAnchor];
    NSLayoutConstraint *contentViewLeading = [self.contentImageView.leadingAnchor constraintEqualToAnchor:self.contentImageView.superview.leadingAnchor];
    NSLayoutConstraint *contentViewBottom = [self.contentImageView.bottomAnchor constraintEqualToAnchor:self.contentImageView.superview.bottomAnchor];
    NSLayoutConstraint *contentViewTrailing = [self.contentImageView.trailingAnchor constraintEqualToAnchor:self.contentImageView.superview.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[contentViewTop, contentViewLeading, contentViewBottom, contentViewTrailing]];
    
    NSLayoutConstraint *loaderCenterX = [self.loader.centerXAnchor constraintEqualToAnchor:self.loader.superview.centerXAnchor];
    NSLayoutConstraint *loaderCenterY = [self.loader.centerYAnchor constraintEqualToAnchor:self.loader.superview.centerYAnchor];
    
    [NSLayoutConstraint activateConstraints:@[loaderCenterX, loaderCenterY]];
}

- (void)configureWithMessage:(CMPMessage *)message ownership:(CMPMessageOwnership)ownership downloader:(CMPImageDownloader *)downloader {
    NSArray<CMPMessagePart *> *parts = message.parts;
    NSString *sentOn = [message.context.sentOn ISO8061String];
    CMPMessageParticipant *participant = message.context.from;
    if (sentOn && participant) {
        self.dateLabel.text = sentOn;
        
    }
    
    [self customizeWithOwnership:ownership];
    [self constrainWithOwnership:ownership];
    
    [self.loader startAnimating];
    if (parts) {
        [parts enumerateObjectsUsingBlock:^(CMPMessagePart * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.url) {
                __weak typeof(self) weakSelf = self;
                [downloader downloadFromURL:obj.url completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"%@", error.localizedDescription);
                    } else {
                        weakSelf.contentImageView.image = image;
                        [weakSelf.loader stopAnimating];
                        self.bubbleWidth.constant = 200;
                        [UIView animateWithDuration:0.3 animations:^{
                            [weakSelf.bubbleView layoutIfNeeded];
                        }];
                    }
                }];
            }
        }];
    }
}

@end

