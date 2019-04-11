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

import UIKit

class PhotoCropViewController: BaseViewController {

    var photoCropView: PhotoCropView { return view as! PhotoCropView }
    var viewModel: PhotoCropViewModel
    
    init(viewModel: PhotoCropViewModel) {
        self.viewModel = viewModel

        super.init()
        
        navigation()
        delegates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PhotoCropView(viewModel: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForLoadingNotification()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func delegates() {
        
        loadingWillPerform = { [weak self] notif in
            self?.showLoader()
        }
        
        loadingWillStop = { [weak self] notif in
            self?.hideLoader()
        }
        
        photoCropView.didTapTopButton = { [weak self] in
            if let image = self?.photoCropView.cropView.crop() {
                if let vc = self?.navigationController?.viewControllers.first(where: { $0 is ChatViewController }) as? ChatViewController {
                    vc.viewModel.attachments.append(image)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        photoCropView.didTapBottomButton = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    override func navigation() {
        navigationItem.hidesBackButton = true
        hidesBottomBarWhenPushed = true
        edgesForExtendedLayout = []
        title = "Adjust"
    }
}
