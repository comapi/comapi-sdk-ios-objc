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

class AddParticipantViewController: BaseViewController {

    var addParticipantView: AddParticipantView { return view as! AddParticipantView }
    
    let viewModel: AddParticipantViewModel
    
    init(viewModel: AddParticipantViewModel) {
        
        self.viewModel = viewModel
        
        super.init()
        
        navigation()
        delegates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = AddParticipantView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        addParticipantView.tableView.delegate = self
        addParticipantView.tableView.dataSource = self
        
        addParticipantView.didTapClose = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        addParticipantView.didTapCreate = { [weak self] in
            guard let `self` = self else { return }
            self.viewModel.addParticipant(success: { [weak self] (success) in
                guard let `self` = self else { return }
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                self.viewModel.showAlert(title: "Participant error", error: error!, presenter: { (vc) in
                    self.present(vc, animated: true, completion: nil)
                })
            })
        }
    }
    
    func reload() {
        addParticipantView.tableView.reloadData()
    }
}

extension AddParticipantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as? TitleInputCell {
                cell.setup(inputType: .keyboard, with: "Name", value: "", topSeparator: false, bottomSeparator: true)
                cell.didChangeText = { [weak self] text in
                    self?.viewModel.update(id: text)
                }
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
}
