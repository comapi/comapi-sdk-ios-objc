//
//  CMPChatTextMessageCell.m
//  SampleApp
//
//  Created by Dominik Kowalski on 16/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPChatTextMessageCell.h"
#import "NSDate+CMPUtility.h"

@interface CMPChatTextMessageCell ()

@property (nonatomic, copy, readonly) NSDictionary<NSAttributedStringKey, id> *selfAttributes;
@property (nonatomic, copy, readonly) NSDictionary<NSAttributedStringKey, id> *otherAttributes;

@end

@implementation CMPChatTextMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.bubbleView = [UIView new];
        self.textView = [UITextView new];
        self.dateLabel = [UILabel new];

        _selfAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18],
                            NSForegroundColorAttributeName : UIColor.blackColor};
        _otherAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18],
                             NSForegroundColorAttributeName : UIColor.whiteColor};
        
        [self configure];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.dateLabel.text = nil;
    self.textView.text = nil;
}

- (void)configure {
    [self customizeWithOwnership:CMPMessageOwnershipSelf];
    [self layout];
    [self constrainWithOwnership:CMPMessageOwnershipSelf];
}

- (void)customizeWithOwnership:(CMPMessageOwnership)ownership {
//    selectionStyle = .none
//    backgroundColor = .clear
//    contentView.backgroundColor = .clear
//case bubbleView:
//    bubbleView.backgroundColor = state == .me ? .white : .black
//    bubbleView.layer.cornerRadius = 15
//    bubbleView.layer.masksToBounds = true
//    bubbleView.layer.shadowColor = UIColor.black.cgColor
//    bubbleView.layer.shadowOffset = CGSize(width: 0, height: 4)
//    bubbleView.layer.shadowRadius = 4
//    bubbleView.layer.shadowOpacity = 0.14
//case textView:
//    textView.isScrollEnabled = false
//    textView.backgroundColor = .clear
//    textView.isEditable = false
//case dateLabel:
//    dateLabel.textColor = state == .me ? .white : .black
//    dateLabel.textAlignment = state == .me ? .right : .left
//    dateLabel.font = UIFont.systemFont(ofSize: 11)
//    dateLabel.numberOfLines = 0
    
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
    self.bubbleView.translatesAutoresizingMaskIntoConstraints = NO;

    self.textView.scrollEnabled = NO;
    self.textView.backgroundColor = UIColor.clearColor;
    self.textView.editable = NO;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;

    self.dateLabel.textColor = ownership == CMPMessageOwnershipSelf ? UIColor.whiteColor : UIColor.blackColor;
    self.dateLabel.textAlignment = ownership == CMPMessageOwnershipSelf ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.dateLabel.font = [UIFont systemFontOfSize:11];
    self.dateLabel.numberOfLines = 0;
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;

}

- (void)layout {
    [self.contentView addSubview:self.bubbleView];
    [self.contentView addSubview:self.dateLabel];
    
    [self.bubbleView addSubview:self.textView];
}

//view.snp.remakeConstraints {
//    switch view {
//    case dateLabel:
//        $0.top.equalToSuperview().offset(2)
//        $0.width.lessThanOrEqualTo(250)
//        if state == .me {
//            $0.trailing.equalToSuperview().offset(-18)
//        } else {
//            $0.leading.equalToSuperview().offset(18)
//        }
//    case bubbleView:
//        $0.bottom.equalToSuperview().offset(-8)
//        $0.top.equalTo(dateLabel.snp.bottom).offset(4)
//        $0.width.lessThanOrEqualTo(250)
//        if !statusViewHidden && state == .me {
//            return
//        } else if state == .me {
//            $0.trailing.equalToSuperview().offset(-14)
//        } else if state == .other {
//            $0.leading.equalToSuperview().offset(14)
//        }
//    case textView:
//        $0.edges.equalToSuperview().inset(UIEdgeInsetsMake(4, 4, 4, 4))
//    case statusView:
//        if state == .me && !statusViewHidden {
//            $0.leading.equalTo(bubbleView.snp.trailing).offset(4)
//            $0.bottom.equalTo(bubbleView.snp.bottom)
//            $0.trailing.equalToSuperview().offset(-4)
//            $0.size.equalTo(statusView.size)
//        }
//    default:
//        break
//    }
//}

- (void)constrainWithOwnership:(CMPMessageOwnership)ownership {
    [NSLayoutConstraint deactivateConstraints:[self.contentView constraints]];
    [NSLayoutConstraint deactivateConstraints:[self.dateLabel constraints]];
    [NSLayoutConstraint deactivateConstraints:[self.bubbleView constraints]];
    [NSLayoutConstraint deactivateConstraints:[self.textView constraints]];
    
    NSLayoutConstraint *dateTop = [self.dateLabel.topAnchor constraintEqualToAnchor:self.dateLabel.superview.topAnchor constant:2];
    NSLayoutConstraint *dateWidth = [self.dateLabel.widthAnchor constraintLessThanOrEqualToConstant:200];
    NSLayoutConstraint *dateHeight = [self.dateLabel.heightAnchor constraintGreaterThanOrEqualToConstant:10];
    NSLayoutConstraint *dateSide;
    if (ownership == CMPMessageOwnershipSelf) {
        dateSide = [self.dateLabel.trailingAnchor constraintEqualToAnchor:self.dateLabel.superview.trailingAnchor constant:-18];
    } else {
        dateSide = [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.dateLabel.superview.leadingAnchor constant:18];
    }
    
    [NSLayoutConstraint activateConstraints:@[dateTop, dateWidth, dateSide, dateHeight]];
    
    
    NSLayoutConstraint *bubbleTop = [self.bubbleView.topAnchor constraintEqualToAnchor:self.dateLabel.bottomAnchor constant:4];
    NSLayoutConstraint *bubbleWidth = [self.bubbleView.widthAnchor constraintLessThanOrEqualToConstant:200];
    NSLayoutConstraint *bubbleHeight = [self.bubbleView.heightAnchor constraintGreaterThanOrEqualToConstant:40];
    NSLayoutConstraint *bubbleBottom = [self.bubbleView.bottomAnchor constraintEqualToAnchor:self.bubbleView.superview.bottomAnchor constant:-8];
    NSLayoutConstraint *bubbleSide;
    if (ownership == CMPMessageOwnershipSelf) {
        bubbleSide = [self.bubbleView.trailingAnchor constraintEqualToAnchor:self.bubbleView.superview.trailingAnchor constant:-14];
    } else {
        bubbleSide = [self.bubbleView.leadingAnchor constraintEqualToAnchor:self.bubbleView.superview.leadingAnchor constant:14];
    }
    
    [NSLayoutConstraint activateConstraints:@[bubbleTop, bubbleWidth, bubbleHeight, bubbleBottom, bubbleSide]];
    
    
    NSLayoutConstraint *textViewTop = [self.textView.topAnchor constraintEqualToAnchor:self.textView.superview.topAnchor constant:4];
    NSLayoutConstraint *textViewLeading = [self.textView.leadingAnchor constraintEqualToAnchor:self.textView.superview.leadingAnchor constant:4];
    NSLayoutConstraint *textViewBottom = [self.textView.bottomAnchor constraintEqualToAnchor:self.textView.superview.bottomAnchor constant:-4];
    NSLayoutConstraint *textViewTrailing = [self.textView.trailingAnchor constraintEqualToAnchor:self.textView.superview.trailingAnchor constant:-4];
    
    [NSLayoutConstraint activateConstraints:@[textViewTop, textViewLeading, textViewBottom, textViewTrailing]];
}

- (void)configureWithMessage:(CMPMessage *)message ownership:(CMPMessageOwnership)ownership {
    NSArray<CMPMessagePart *> *parts = message.parts;
    NSString *sentOn = [message.context.sentOn ISO8061String];
    CMPMessageParticipant *participant = message.context.from;
    if (parts && sentOn && participant) {
        self.dateLabel.text = sentOn;
        
        [parts enumerateObjectsUsingBlock:^(CMPMessagePart * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type) {
                if ([obj.type isEqualToString:@"text/plain"]) {
                    if (obj.data) {
                        self.textView.attributedText = [[NSAttributedString alloc] initWithString:obj.data attributes:ownership == CMPMessageOwnershipSelf ? self->_selfAttributes : self->_otherAttributes];
                    }
                }
            }
        }];
    }
    
    [self customizeWithOwnership:ownership];
    [self constrainWithOwnership:ownership];
}

@end
