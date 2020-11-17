//
//  ChatViewController.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MessageKit
import Photos
import InputBarAccessoryView

class ChatViewController: MessagesViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithoutSearch
    var model: ChatInput!
    var chatBar: ChatInputBar? {
        return messageInputBar as? ChatInputBar
    }
    
    lazy var attachmentManager: AttachmentManager = { [unowned self] in
        let manager = AttachmentManager()
        manager.delegate = self
        return manager
    }()
    
    private var photoLibraryAuthorizationStatus: PHAuthorizationStatus!
    private var cameraAuthorizationStatus: AVAuthorizationStatus!
    private let imagePicker = UIImagePickerController()
    private let attachDialogue = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    private var attachedItems: [LibraryImage] = []
    private var isKeyboardVisible: Bool {
            return messageInputBar.inputTextView.isFirstResponder
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        messageInputBar = ChatInputBar()
        messageInputBar.delegate = self
        messageInputBar.inputPlugins.append(attachmentManager)
    }
    
    @objc
    func hideKeyboardIfNeeded() {
        if messageInputBar.inputTextView.isFirstResponder {
            navigationController?.view.endEditing(true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        model.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    }
    
    func setup() {
        messagesCollectionView.contentInset = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 0.0, right: 12.0)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardIfNeeded))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        messagesCollectionView.backgroundColor = .clear
        showMessageTimestampOnSwipeLeft = false
        view.backgroundColor = .white
        navigationItem.setRightBarButtonItems([UIBarButtonItem.init(image: R.image.info(), style: .plain, target: self, action: #selector(showChatInfo))], animated: true)
        
        imagePicker.delegate = self
        attachDialogue.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { [weak self] _ in
            self?.openGallery()
        }))
        
        attachDialogue.addAction(UIAlertAction(title: "Библиотека", style: .default, handler: { [weak self] _ in
            self?.openLibrary()
        }))
        
        attachDialogue.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
            self?.openCamera()
        }))
        
        attachDialogue.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
    }
    
    func showDeniedPhotoMessage() {
        showMessage(text: "Отройте доступ к фото в найстройках приложения")
    }
    
    func showDeniedCameraMessage() {
        showMessage(text: "Отройте доступ к камере в найстройках приложения")
    }
    
    func requestPhotoLibraryAuthorization() {
        PHPhotoLibrary.requestAuthorization {[weak self] status in
            self?.photoLibraryAuthorizationStatus = status
            switch status {
            case .authorized, .limited:
                self?.openGallery()
            case .denied:
                self?.showDeniedPhotoMessage()
            default: break
            }
        }
    }
    
    func requestCameraUsageAuthorization() {
        AVCaptureDevice.requestAccess(for: .video) {[weak self] isGranted in
            if isGranted {
                self?.openCamera()
            } else {
                self?.showDeniedCameraMessage()
            }
        }
    }
    
    @objc func showChatInfo() {
        
    }
}
    
extension ChatViewController: ChatOutput {
    func openGallery() {
        DispatchQueue.main.async {
            if self.isKeyboardVisible {
                self.navigationController?.view.endEditing(true)
            }
            
            switch self.photoLibraryAuthorizationStatus {
            case .authorized, .limited:
                self.chatBar?.showGallery()
            case .notDetermined, .none:
                self.requestPhotoLibraryAuthorization()
            case .denied, .restricted:
                self.showDeniedPhotoMessage()
            default: break
            }
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    func closeGallery() {
        chatBar?.hideGallery()
    }
    
    func openLibrary() {
        switch photoLibraryAuthorizationStatus {
        case .authorized, .limited:
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        case .notDetermined, .none:
            requestPhotoLibraryAuthorization()
        case .denied, .restricted:
            showDeniedPhotoMessage()
        default: break
        }
    }
    
    func openCamera() {
        switch cameraAuthorizationStatus {
        case .none: break
        case .some(let status):
            switch status {
            case .notDetermined:
                requestCameraUsageAuthorization()
            case .denied, .restricted:
                self.showDeniedCameraMessage()
            case .authorized:
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            @unknown default: break
            }
        }
    }
    
    func uploadFinished(image: LibraryImage, with result: UploadImageResult) {
        switch result {
        case .success(let response):
            print(response)
        case .failure(let error):
            print(error.localizedDescription)
        }
        
        if let index = attachedItems.firstIndex(of: image) {
            attachmentManager.removeAttachment(at: index)
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        guard let url = info[UIImagePickerController.InfoKey.imageURL.rawValue] as? URL,
              let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage else { return }
        
        let image = LibraryImage(originalImage: pickedImage, url: url, source: .library)
        didSelect(action: .select(image))
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ChatViewController: AttachmentManagerDelegate {
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        let image = attachedItems[index]
        switch image.source {
        case .gallery(let indexPath):
            attachedItems.remove(at: index)
            chatBar?.chatGallery.deselectItem(at: indexPath, animated: false)
        case .library:
            attachedItems.remove(at: index)
        default: break
        }
        chatBar?.updateAppearanceWithAttachments(count: attachedItems.count)
        messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - AttachmentManagerDelegate Helper
    
    func setAttachmentManager(active: Bool) {
        let topStackView = messageInputBar.topStackView
        
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
}

extension ChatViewController: ChatInputBarDelegate {
    func attach() {
        closeGallery()
        present(attachDialogue, animated: true, completion: nil)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        inputBar.inputTextView.text = String()
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(inputBar)
        model.sendMessage(text: text)
        if attachedItems.count > 0 {
            model.upload(images: attachedItems)
            chatBar?.needHideGallery()
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        messagesCollectionView.scrollToBottom(animated: false)
    }
    
    func didSelect(action: ImageSelectionAction) {
        switch action {
        case .select(let image):
            guard attachedItems.contains(image) == false else { return }
            attachedItems.append(image)
            attachmentManager.handleInput(of: image.placeholder)
            chatBar?.updateAppearanceWithAttachments(count: attachedItems.count)
        case .deselect(let image):
            if let index = attachedItems.firstIndex(of: image) {
                attachmentManager.removeAttachment(at: index)
            }
        }
    }
}

extension ChatViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension ChatViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }
      
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Retrieve the view controllers participating in the current transition from the context.
        let fromView = transitionContext.viewController(forKey: .from)!.view!
        let toView = transitionContext.viewController(forKey: .to)!.view!

        // If the view to transition from is this controller's view, the drawer is being presented.
        let isPresentingDrawer = toView != view
//        let isPresentingDrawer = true
        let drawerView = isPresentingDrawer ? toView : fromView

        if isPresentingDrawer {
            // Any presented views must be part of the container view's hierarchy
            transitionContext.containerView.addSubview(drawerView)
        }

        /***** Animation *****/
        
        let drawerSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        // Determine the drawer frame for both on and off screen positions.
        let offScreenDrawerFrame = CGRect(origin: CGPoint(x: 0.0, y: drawerSize.width * -1), size: drawerSize)
        let onScreenDrawerFrame = CGRect(origin: .zero, size: drawerSize)
        
//        drawerView.frame = isPresentingDrawer ? offScreenDrawerFrame : onScreenDrawerFrame
        drawerView.frame = onScreenDrawerFrame
        drawerView.alpha = 0.0
        let animationDuration = transitionDuration(using: transitionContext)
        
        // Animate the drawer sliding in and out.
        UIView.animate(withDuration: animationDuration, animations: {
            drawerView.alpha = 1.0
//            drawerView.frame = isPresentingDrawer ? onScreenDrawerFrame : offScreenDrawerFrame
        }, completion: { (success) in
            // Cleanup view hierarchy
            if !isPresentingDrawer {
                drawerView.removeFromSuperview()
            }
            
            // IMPORTANT: Notify UIKit that the transition is complete.
            transitionContext.completeTransition(success)
        })
    }
}
