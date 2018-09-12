//
//  CMPProfileView.h
//  SampleApp
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseView.h"

@interface CMPProfileView : CMPBaseView <CMPViewConfiguring>

@property (nonatomic, strong) UITableView *tableView;

- (instancetype)init;

@end
