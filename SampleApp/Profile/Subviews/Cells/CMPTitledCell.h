//
//  CMPTitledCell.h
//  SampleApp
//
//  Created by Dominik Kowalski on 12/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseCell.h"
#import "CMPViewConfiguring.h"

@interface CMPTitledCell : CMPBaseCell <CMPViewConfiguring>

@property (nonatomic, strong) UILabel *mainTitleLabel;

- (void)configureWithTitle:(NSString *)title;

@end
