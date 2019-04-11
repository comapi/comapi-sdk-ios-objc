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
        
        self.viewModel.getMessages(success: { [weak self] in
            self?.reload()
            self?.scrollToLastIndex()
            self?.viewModel.markAllRead()
        }) { (error) in
            print(error ?? "")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.shouldReloadAttachments?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromKeyboardNotifications()
        unregisterFromLoadingNotification()
    }
    
    override func delegates() {
        chatView.tableView.delegate = self
        chatView.tableView.dataSource = self
        chatView.attachmentsView.collectionView.delegate = self
        chatView.attachmentsView.collectionView.dataSource = self
        
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
            self?.viewModel.send(message: text, completion: { (error) in
                if let err = error {
                    print(err.localizedDescription)
                }
                self?.viewModel.shouldReloadAttachments?()
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
        
        chatView.didTapNewMessageView = { [weak self] in
            self?.scrollToLastIndex()
            self?.chatView.toggleNewMessageView(show: false, completion: nil)
        }
        
        viewModel.didTakeNewPhoto = { [weak self] image in
            self?.viewModel.showPhotoCropController(image: image, presenter: { (vc) in
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        }
        
        viewModel.shouldReloadAttachments = { [weak self] in
            guard let `self` = self else { return }
            self.chatView.inputMessageView.sendButton.isEnabled = self.viewModel.attachments.count > 0
            self.chatView.toggleAttachments(show: self.viewModel.attachments.count > 0) {
                self.chatView.reloadAttachments()
            }
        }
        
        viewModel.shouldReloadMessages = { [weak self] showNewMessage in
            guard let `self` = self else { return }
            if !showNewMessage {
                self.reload(showNewMessageView: false)
                self.scrollToLastIndex()
            } else {
                self.reload(showNewMessageView: true)
            }
        }
        viewModel.shouldReloadMessageAtIndex = { [weak self] idx in
            guard let `self` = self else { return }
            if idx > self.viewModel.messages.count - 1 || idx < 0 {
                return
            }
            let indices = [IndexPath(row: idx, section: 0)]
            UIView.performWithoutAnimation {
                let loc = self.chatView.tableView.contentOffset
                self.chatView.tableView.reloadRows(at: indices, with: .none)
                self.chatView.tableView.contentOffset = loc
            }
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
    
    func reload(showNewMessageView: Bool = false) {
        chatView.tableView.reloadData()
        if (showNewMessageView) {
            if chatView.tableView.contentOffset.y < self.chatView.tableView.contentSize.height {
                self.chatView.toggleNewMessageView(show: true, completion: nil)
            }
        }
    }
    
    func scrollToLastIndex() {
        if viewModel.messages.count == 0 {
            return;
        }

        let index = viewModel.messages.count > 0 ? viewModel.messages.count - 1 : 0;
        chatView.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .bottom, animated: false)
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ChatMessagePartCell {
            if let fromID = msg.context?.from?.id, let profileID = viewModel.client.profileID {
                let isMine = fromID == profileID
                cell.configure(with: msg, ownership: isMine ? .me : .other, downloader: viewModel.downloader)
                
                return cell
            }
        }

        return UITableViewCell()
    }
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.attachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AttachmentsCell {
            cell.configure(with: viewModel.attachments[indexPath.row])
            cell.didTapDelete = { [weak self] in
                self?.viewModel.attachments.remove(at: indexPath.row)
                self?.viewModel.shouldReloadAttachments?()
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}
