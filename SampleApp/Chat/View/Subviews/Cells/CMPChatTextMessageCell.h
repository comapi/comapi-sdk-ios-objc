//
//  CMPChatTextMessageCell.h
//  SampleApp
//
//  Created by Dominik Kowalski on 16/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseCell.h"
#import "CMPMessage.h"
#import "CMPViewConfiguring.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPChatTextMessageCell : CMPBaseCell <CMPViewConfiguring>

@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *dateLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;

- (void)configureWithMessage:(CMPMessage *)message ownership:(CMPMessageOwnership)ownership;

@end

NS_ASSUME_NONNULL_END
