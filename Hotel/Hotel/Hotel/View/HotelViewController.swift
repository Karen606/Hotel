//
//  HotelViewController.swift
//  Hotel
//
//  Created by Karen Khachatryan on 12.10.24.
//

import UIKit
import PhotosUI
import Combine
import FSPagerView

class HotelViewController: UIViewController {
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var infoTextView: BaseTextView!
    @IBOutlet weak var rulesTextView: BaseTextView!
    @IBOutlet weak var servicesStackView: UIStackView!
    @IBOutlet weak var saveButton: UIButton!
    private let viewModel = HotelViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerKeyboardNotifications()
        subscribe()
        viewModel.fetchHotel()
    }

    func setupUI() {
        self.setNavigationBar(title: "Informations")
        
        infoTextView.placeholder = "Brief information about the hotel"
        rulesTextView.placeholder = "Guest Accommodation rules"
        let attributedString = NSMutableAttributedString(string: "Save", attributes: [
            .font: UIFont.interRegular(size: 12) as Any,
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        pagerView.layer.cornerRadius = 6
        pagerView.layer.borderWidth = 0.5
        pagerView.layer.borderColor = UIColor.black.withAlphaComponent(0.7).cgColor
        pagerView.layer.masksToBounds = true
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.contentMode = .center
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.itemSize = CGSize(width: 79, height: 75)
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pageControl.contentHorizontalAlignment = .center
        pageControl.setFillColor(.white, for: .selected)
        pageControl.setFillColor(.baseGray, for: .normal)
        saveButton.setAttributedTitle(attributedString, for: .normal)
        nameTextField.delegate = self
        infoTextView.baseDelegate = self
        rulesTextView.baseDelegate = self
        tapGesture.delegate = self
    }
    
    func subscribe() {
        viewModel.$hotelModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hotelModel in
                guard let self = self else { return }
                if self.viewModel.isEditing {
                    nameTextField.text = hotelModel.name
                    infoTextView.text = hotelModel.brefInformation
                    rulesTextView.text = hotelModel.rules
                    if let services = hotelModel.services {
                        self.servicesStackView.arrangedSubviews.forEach { serviceTextField in
                            self.servicesStackView.removeArrangedSubview(serviceTextField)
                            serviceTextField.isHidden = true
                        }
                        for services in services {
                            let servicesTextField = BaseTextField()
                            servicesTextField.placeholder = "Services"
                            servicesTextField.text = services
                            servicesTextField.delegate = self
                            servicesTextField.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                servicesTextField.heightAnchor.constraint(equalToConstant: 26)
                            ])
                            self.servicesStackView.addArrangedSubview(servicesTextField)
                        }
                    }
                }
                self.pageControl.numberOfPages = hotelModel.photos?.count ?? 0
                let size = (self.viewModel.isAppenedImage || hotelModel.photos?.count ?? 0 > 1) ? self.pagerView.bounds.size : CGSize(width: 79, height: 75)
                self.pagerView.itemSize = size
                self.pagerView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func choosePhoto() {
        let actionSheet = UIAlertController(title: "Select Image", message: "Choose a source", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.requestCameraAccess()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.requestPhotoLibraryAccess()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view // Your source view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.handleTap()
    }
    
    @IBAction func clickedAddServices(_ sender: UIButton) {
        let servicesTextField = BaseTextField()
        servicesTextField.attributedPlaceholder = NSAttributedString(
            string: "Services",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayTitle, NSAttributedString.Key.font: UIFont.interItalicLight(size: 12) as Any]
        )
        servicesTextField.delegate = self
        servicesStackView.addArrangedSubview(servicesTextField)
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
        var services: [String] = []
        servicesStackView.arrangedSubviews.forEach { serviceTextField in
            if let serviceTextField = serviceTextField as? BaseTextField {
                if serviceTextField.checkValidation() {
                    services.append(serviceTextField.text ?? "")
                }
            }
        }
        viewModel.hotelModel.services = services
        viewModel.saveHotel { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension HotelViewController: UITextFieldDelegate, BaseTextViewDelegate {
    func didChancheSelection(_ textView: UITextView) {
        switch textView {
        case infoTextView:
            viewModel.hotelModel.brefInformation = textView.text
        case rulesTextView:
            viewModel.hotelModel.rules = textView.text
        default:
            break
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nameTextField {
            viewModel.hotelModel.name = textField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

extension HotelViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return viewModel.hotelModel.photos?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if let data = viewModel.hotelModel.photos?[index] {
            cell.imageView?.image = UIImage(data: data)
        }
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        choosePhoto()
    }
        
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
}


extension HotelViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func requestCameraAccess() {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openCamera()
                }
            }
        case .authorized:
            openCamera()
        case .denied, .restricted:
            showSettingsAlert()
        @unknown default:
            break
        }
    }
    
    private func requestPhotoLibraryAccess() {
        let photoStatus = PHPhotoLibrary.authorizationStatus()
        switch photoStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                guard let self = self else { return }
                if status == .authorized {
                    self.openPhotoLibrary()
                }
            }
        case .authorized:
            openPhotoLibrary()
        case .denied, .restricted:
            showSettingsAlert()
        case .limited:
            break
        @unknown default:
            break
        }
    }
    
    private func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    private func openPhotoLibrary() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(title: "Access Needed", message: "Please allow access in Settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            image = originalImage
        }
        if let imageData = image?.jpegData(compressionQuality: 1.0) {
            let data = imageData as Data
            viewModel.addImage(data: data)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension HotelViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(HotelViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                scrollView.contentInset = .zero
            } else {
                let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

extension HotelViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(view.hitTest(touch.location(in: view), with: nil)?.isDescendant(of: pagerView) == true)
    }
}
