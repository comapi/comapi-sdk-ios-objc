//
//  CMPBaseCell.h
//  SampleApp
//
//  Created by Dominik Kowalski on 04/09/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CMPMessageOwnership) {
    CMPMessageOwnershipSelf,
    CMPMessageOwnershipOther,
};

@interface CMPBaseCell : UITableViewCell

@end
