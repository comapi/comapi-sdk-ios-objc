//
//  CMPChatImageMessageCell.h
//  SampleApp
//
//  Created by Dominik Kowalski on 16/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseCell.h"
#import "CMPViewConfiguring.h"
#import "CMPMessage.h"
#import "CMPImageDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPChatImageMessageCell : CMPBaseCell <CMPViewConfiguring>

@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIActivityIndicatorView *loader;

- (void)configureWithMessage:(CMPMessage *)message ownership:(CMPMessageOwnership)ownership downloader:(CMPImageDownloader *)downloader;

@end

NS_ASSUME_NONNULL_END
