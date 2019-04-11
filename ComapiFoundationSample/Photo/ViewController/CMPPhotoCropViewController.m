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
            if (image) {
                NSData * data = [weakSelf.viewModel prepareCroppedImage:image];
                if (data) {
                    CMPChatViewController *vc = (CMPChatViewController *)weakSelf.navigationController.viewControllers[weakSelf.navigationController.viewControllers.count - 2];
                    [vc.viewModel addImageAttachment:[UIImage imageWithData:data]];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
//                if (vc) {
//                    CMPContentData *contentData = [[CMPContentData alloc] initWithData:data type:@"image/jpg" name:nil];
//                    [vc.viewModel uploadContent:contentData completion:^(CMPContentUploadResult * _Nullable result, NSError * _Nullable error) {
//                        if (error) {
//                            NSLog(@"%@", error.localizedDescription);
//                        }
//                        [vc.viewModel sendImageWithUploadResult:result completion:^(NSError * _Nullable error) {
//                            if (error) {
//                                NSLog(@"%@", error.localizedDescription);
//                            }
//                            [weakSelf.navigationController popViewControllerAnimated:YES];
//                        }];
//                    }];
//                }
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
