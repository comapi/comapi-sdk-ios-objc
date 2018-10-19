//
//  CMPPhotoCropViewController.h
//  SampleApp
//
//  Created by Dominik Kowalski on 19/10/2018.
//  Copyright © 2018 Comapi. All rights reserved.
//

#import "CMPBaseViewController.h"
#import "CMPPhotoCropView.h"
#import "CMPPhotoCropViewModel.h"
#import "CMPViewControllerConfiguring.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPPhotoCropViewController : CMPBaseViewController <CMPViewControllerConfiguring>

@property (nonatomic, strong, readonly) CMPPhotoCropViewModel *viewModel;

- (instancetype)initWithViewModel:(CMPPhotoCropViewModel *)viewModel;
- (CMPPhotoCropView *)photoCropView;

@end

NS_ASSUME_NONNULL_END

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
//            if let image = self?.photoCropView.cropView.crop() {
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
