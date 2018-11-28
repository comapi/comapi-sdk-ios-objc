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

class ChatViewController: BaseViewController {
    
    var chatView: ChatView { return view as! ChatView }
    
    let viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel) {
        
        self.viewModel = viewModel
        
        super.init()
        
        navigation()
        delegates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ChatView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
        registerForLoadingNotification()
        
        viewModel.queryEvents(success: { [weak self] in
            self?.viewModel.getMessages(success: { [weak self] in
                self?.reload()
            }) { (error) in
                print(error ?? "")
            }
        }) { (error) in
            print(error ?? "")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromKeyboardNotifications()
        unregisterFromLoadingNotification()
    }
    
    override func delegates() {
        chatView.tableView.delegate = self
        chatView.tableView.dataSource = self
        
        keyboardWillShow = { [weak self] notification in
            self?.chatView.animateOnKeyboardChange(notification: notification, completion: nil)
        }
        
        keyboardWillHide = { [weak self] notification in
            self?.chatView.animateOnKeyboardChange(notification: notification, completion: nil)
        }
        
        loadingWillPerform = { [weak self] notif in
            self?.showLoader()
        }
        
        loadingWillStop = { [weak self] notif in
            self?.hideLoader()
        }
        
        chatView.didTapSendButton = { [weak self] text in
            self?.viewModel.sendText(message: text, success: {
                self?.reload()
            }, failure: { error in
                self?.reload()
            })
        }
        
        chatView.didTapUploadButton = { [weak self] in
            self?.viewModel.showPhotoSourceActionSheetController(presenter: { (vc) in
                self?.navigationController?.present(vc, animated: true, completion: nil)
            }, alertPresenter: { (vc) in
                self?.navigationController?.present(vc, animated: true, completion: nil)
            }, pickerPresenter: { (vc) in
                self?.navigationController?.present(vc, animated: true, completion: nil)
            })
        }
        
        viewModel.didTakeNewPhoto = { [weak self] image in
            self?.viewModel.showPhotoCropController(image: image, presenter: { (vc) in
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        }
        
        viewModel.didReceiveMessage = { [weak self] in
            self?.reload()
        }
        
        viewModel.didReadMessage = { messageRead in
            
        }
    }
    
    override func navigation() {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        backButton.setImage(UIImage(named: "back"), for: UIControl.State())
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)

        let backBarButton = UIBarButtonItem(customView: backButton)

        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        rightButton.setImage(UIImage(named: "add"), for: UIControl.State())
        rightButton.addTarget(self, action: #selector(addParticipant), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.title = viewModel.conversation.name
    }
    
    func reload() {
        chatView.tableView.reloadData()
    }
    
    @objc func addParticipant() {
        let vm = AddParticipantViewModel(client: viewModel.client, conversationId: viewModel.conversation.id)
        let vc = AddParticipantViewController(viewModel: vm)
        present(vc, animated: true, completion: nil)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = viewModel.messages[indexPath.row]
        
        if let _ = msg.parts?.first?.url {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ChatImageMessageCell {
                
                if let fromID = msg.context?.from?.id, let profileID = viewModel.client.profileID {
                    let isMine = fromID == profileID
                    if indexPath.row == viewModel.messages.count - 1 {
                        cell.configure(with: viewModel.messages[indexPath.row], state: isMine ? .me : .other, downloader: viewModel.downloader, statusViewHidden: false)
                    } else {
                        cell.configure(with: viewModel.messages[indexPath.row], state: isMine ? .me : .other, downloader: viewModel.downloader)
                    }
                }
                
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as? ChatTextMessageCell {
                let msg = viewModel.messages[indexPath.row]
                if let fromID = msg.context?.from?.id, let profileID = viewModel.client.profileID {
                    let isMine = fromID == profileID
                    if indexPath.row == viewModel.messages.count - 1 {
                        cell.configure(with: viewModel.messages[indexPath.row], state: isMine ? .me : .other, statusViewHidden: false)
                    } else {
                        cell.configure(with: viewModel.messages[indexPath.row], state: isMine ? .me : .other)
                    }
                }
                
                return cell
            }
        }

        return UITableViewCell()
    }
}
