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
    self.photoCropView.didTapTopButton = ^{
        UIImage *image = [weakSelf.photoCropView.cropView crop];
        if (image) {
            NSData * data = [weakSelf.viewModel prepareCroppedImage:image];
            if (data) {
                CMPChatViewController *vc = (CMPChatViewController *)weakSelf.navigationController.viewControllers.lastObject;
                if (vc) {
                    CMPContentData *contentData = [[CMPContentData alloc] initWithData:data type:@"image/jpg" name:nil];
                    [vc.viewModel ];
                }
            }
        }
        
    };
    //if let image = self?.photoCropView.cropView.crop() {
        //                self?.viewModel.prepare(croppedImage: image, completion: { data in
        //                    if let vc = self?.navigationController?.viewControllers.first(where: { $0 is ChatViewController }) as? ChatViewController {
        //                        let contentData = ContentData(data: data, type: "image/jpg", name: nil)
        //                        vc.viewModel.upload(content: contentData, success: { [weak vc] result in
        //                            vc?.viewModel.sendImage(content: result, success: {
        //                                self?.navigationController?.popViewController(animated: true)
        //                            }, failure: { (error) in
        //                                print(error)
        //                            })
        //                        }, failure: { error in
        //                            print(error)
        //                        })
        //                    }
        //                }, failure: {
        //                    print("failed upload")
        //                    self?.navigationController?.popViewController(animated: true)
        //                })
        //            }
    
    
}

- (void)navigation {
    self.navigationItem.hidesBackButton = YES;
    self.hidesBottomBarWhenPushed = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Adjust";
}

@end


////
////  PortfolioPhotoCropViewController.swift
////  BooksyBIZ
////
////  Created by Dominik Kowalski on 01/03/2018.
////  Copyright © 2018 Sensi Soft. All rights reserved.
////
//
//import UIKit
//import ComapiFoundation
//
//class PhotoCropViewController: BaseViewController {
//
//    var photoCropView: PhotoCropView { return view as! PhotoCropView }
//    var viewModel: PhotoCropViewModel
//
//    init(viewModel: PhotoCropViewModel) {
//        self.viewModel = viewModel
//
//        super.init()
//
//        navigation()
//        delegates()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func loadView() {
//        view = PhotoCropView(viewModel: viewModel)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        registerForLoadingNotification()
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
//
//    override func delegates() {
//
//        loadingWillPerform = { [weak self] notif in
//            self?.showLoader()
//        }
//
//        loadingWillStop = { [weak self] notif in
//            self?.hideLoader()
//        }
//
//        photoCropView.didTapTopButton = { [weak self] in
//
//        }
//
//        photoCropView.didTapBottomButton = { [weak self] in
//            self?.navigationController?.popViewController(animated: true)
//        }
//    }
//
//    override func navigation() {
//        navigationItem.hidesBackButton = true
//        hidesBottomBarWhenPushed = true
//        edgesForExtendedLayout = []
//        title = "Adjust"
//    }
//}
