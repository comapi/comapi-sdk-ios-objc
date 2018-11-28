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
import CMPComapiFoundation

class CreateConversationViewController: BaseViewController {

    var conversationView: CreateConversationView { return view as! CreateConversationView }
    
    let viewModel: CreateConversationViewModel
    
    init(viewModel: CreateConversationViewModel) {
        
        self.viewModel = viewModel
        
        super.init()
        
        navigation()
        delegates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CreateConversationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getProfiles(success: { [weak self] (profiles) in
            self?.reload()
        }) { (error) in
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForLoadingNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromLoadingNotification()
    }

    override func navigation() {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    override func delegates() {
        conversationView.tableView.delegate = self
        conversationView.tableView.dataSource = self
        
        conversationView.didTapClose = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        conversationView.didTapCreate = { [weak self] in
            guard let `self` = self else { return }
            self.viewModel.createConversation(isPublic: false, success: { (alreadyExists, conversation) in
                let nav = self.presentingViewController as! UINavigationController
                self.dismiss(animated: true) {
                    if let vc = nav.viewControllers.first(where: { $0 is ConversationViewController }) as? ConversationViewController {
                        vc.viewModel.getAllConverstations(success: { [weak self] in
                            vc.reload()
                        }) { error in
                            print(error)
                        }
                    }
                }
            }, failure: { error in
                print(error)
            })
        }
    }
    
    func reload() {
        conversationView.tableView.reloadData()
    }
    
    func reload(row: Int) {
        conversationView.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
}

extension CreateConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as? TitleInputCell {
                cell.setup(inputType: .keyboard, with: "Name", value: "", topSeparator: false, bottomSeparator: true)
                cell.didChangeText = { [weak self] text in
                    self?.viewModel.newConversation.name = text
                }
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as? TitleInputCell {
                cell.setup(inputType: .keyboard, with: "Description", value: "", topSeparator: false, bottomSeparator: true)
                cell.didChangeText = { [weak self] text in
                    self?.viewModel.newConversation.conversationDescription = text
                }
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
}
