//
//  CMPPhotoCropViewController.m
//  SampleApp
//
//  Created by Dominik Kowalski on 19/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPPhotoCropViewController.h"
#import "CMPChatViewController.h"

@implementation CMPPhotoCropViewController

- (instancetype)initWithViewModel:(CMPPhotoCropViewModel *)viewModel {
    self = [super init];
    
    if (self) {
        _viewModel = viewModel;
        
        [self delegates];
        [self navigation];
    }
    
    return self;
}

- (void)loadView {
    self.view = [[CMPPhotoCropView alloc] initWithViewModel:_viewModel];
}
    

- (CMPPhotoCropView *)photoCropView {
    return (CMPPhotoCropView *)self.view;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)delegates {
    
    __weak typeof(self) weakSelf = self;
    self.photoCropView.didTapBottomButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.photoCropView.didTapTopButton = ^{
        UIImage *image = [weakSelf.photoCropView.cropView crop];
        if (image) {
            NSData * data = [weakSelf.viewModel prepareCroppedImage:image];
            if (data) {
                CMPChatViewController *vc = (CMPChatViewController *)weakSelf.navigationController.viewControllers[weakSelf.navigationController.viewControllers.count - 2];
                if (vc) {
                    CMPContentData *contentData = [[CMPContentData alloc] initWithData:data type:@"image/jpg" name:nil];
                    [vc.viewModel uploadContent:contentData completion:^(CMPContentUploadResult * _Nullable result, NSError * _Nullable error) {
                        if (error) {
                            NSLog(@"%@", error.localizedDescription);
                        }
                        [vc.viewModel sendImageWithUploadResult:result completion:^(NSError * _Nullable error) {
                            if (error) {
                                NSLog(@"%@", error.localizedDescription);
                            }
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                }
            }
        }
    };
}

- (void)navigation {
    self.navigationItem.hidesBackButton = YES;
    self.hidesBottomBarWhenPushed = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Adjust";
}

@end
