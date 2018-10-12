//
//  CMPConversationsView.h
//  SampleApp
//
//  Created by Dominik Kowalski on 12/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPConversationsView : CMPBaseView <CMPViewConfiguring>

@property (nonatomic, strong) UITableView *tableView;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
