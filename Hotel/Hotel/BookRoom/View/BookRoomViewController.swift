//
//  BookRoomViewController.swift
//  Hotel
//
//  Created by Karen Khachatryan on 14.10.24.
//

import UIKit
import Combine

class BookRoomViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var startDateTextField: DateTextField!
    @IBOutlet weak var endDateTextField: DateTextField!
    @IBOutlet weak var guestNumberTextField: BaseTextField!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var surnameTextField: BaseTextField!
    @IBOutlet weak var emailTextField: EmailTextField!
    @IBOutlet weak var phoneNumberTextField: BaseTextField!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var priceNightLabel: UILabel!
    @IBOutlet weak var imageViewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var labelConst: NSLayoutConstraint!
    @IBOutlet weak var toBookButton: BaseButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet var textFields: [UITextField]!
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let viewModel = BookRoomViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        registerKeyboardNotifications()
    }
    
    func setupUI() {
        setNavigationBar(title: "Book a Rooms")
        titleLabels.forEach({ $0.font = .interRegular(size: 14) })
        resetButton.titleLabel?.font = .interRegular(size: 14)
        toBookButton.titleLabel?.font = .interMedium(size: 20)
        priceLabel.font = .seversMedium(size: 22)
        infoLabel.font = .seversMedium(size: 12)
        startDateTextField.setupRightViewIcon(UIImage.dateArrow)
        startDateTextField.setupLeftViewIcon(UIImage.calendar)
        endDateTextField.setupRightViewIcon(UIImage.dateArrow)
        endDateTextField.setupLeftViewIcon(UIImage.calendar)
        toBookButton.addShadow()
        startDatePicker.locale = NSLocale.current
        startDatePicker.datePickerMode = .date
        startDatePicker.minimumDate = Date()
        startDatePicker.preferredDatePickerStyle = .inline
        startDatePicker.addTarget(self, action: #selector(startDatePickerValueChanged(sender:)), for: .valueChanged)
        endDatePicker.locale = NSLocale.current
        endDatePicker.datePickerMode = .date
        endDatePicker.minimumDate = Date()
        endDatePicker.preferredDatePickerStyle = .inline
        endDatePicker.addTarget(self, action: #selector(endDatePickerValueChanged(sender:)), for: .valueChanged)
        startDateTextField.inputView = startDatePicker
        endDateTextField.inputView = endDatePicker
        textFields.forEach({ $0.delegate = self; $0.layer.borderWidth = 1; $0.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor })
    }
    
    func subscribe() {
        viewModel.$room
            .receive(on: DispatchQueue.main)
            .sink { [weak self] room in
                guard let self = self, let room = room else { return }
                if let data = room.photo {
                    self.roomImageView.image = UIImage(data: data)
                }
                self.priceLabel.text = "\(room.price?.formattedToString() ?? "")$"
                
                let priceText = "price per night "
                let priceValue = "\(room.price?.formattedToString() ?? "")$"

                let priceTextAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.seversMedium(size: 18) as Any
                ]
                let priceValueAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.seversMedium(size: 22) as Any
                ]
                let attributedPriceText = NSAttributedString(string: priceText, attributes: priceTextAttributes)
                let attributedPriceValue = NSAttributedString(string: priceValue, attributes: priceValueAttributes)
                let combinedAttributedString = NSMutableAttributedString()
                combinedAttributedString.append(attributedPriceText)
                combinedAttributedString.append(attributedPriceValue)
                self.priceNightLabel.attributedText = combinedAttributedString
                self.infoLabel.text = room.facilities?.joined(separator: "\n")
            }
            .store(in: &cancellables)
        
        viewModel.$bookRoomModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookRoom in
                guard let self = self else { return }
                self.toBookButton.isEnabled = !(self.textFields.contains(where: { !$0.text.checkValidation() })) && emailTextField.text.isValidEmail()
            }
            .store(in: &cancellables)
    }
    
    @objc func startDatePickerValueChanged(sender: UIDatePicker) {
        startDateTextField.text = sender.date.toString()
        viewModel.bookRoomModel.startDate = sender.date
        self.view.endEditing(true)
    }
    
    @objc func endDatePickerValueChanged(sender: UIDatePicker) {
        endDateTextField.text = sender.date.toString()
        viewModel.bookRoomModel.endDate = sender.date
        self.view.endEditing(true)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.handleTap()
    }
    
    @IBAction func clickedShowMore(_ sender: UIButton) {
        sender.isSelected.toggle()
        labelConst.isActive = sender.isSelected
        imageViewBottomConst.isActive = !sender.isSelected
        priceLabel.isHidden = sender.isSelected
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func clickedReset(_ sender: UIButton) {
        viewModel.reset()
        textFields.forEach({ $0.text = nil })
    }
    
    @IBAction func clickedToBook(_ sender: UIButton) {
        viewModel.save { [weak self] error in
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

extension BookRoomViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case guestNumberTextField:
            viewModel.bookRoomModel.numberOfGuests = textField.text
        case nameTextField:
            viewModel.bookRoomModel.name = textField.text
        case surnameTextField:
            viewModel.bookRoomModel.surname = textField.text
        case emailTextField:
            viewModel.bookRoomModel.email = textField.text
        case phoneNumberTextField:
            viewModel.bookRoomModel.phoneNumber = textField.text
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case startDateTextField, endDateTextField:
            return false
        case guestNumberTextField, phoneNumberTextField:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        default:
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            emailTextField.isValidEmail()
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

extension BookRoomViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(BookRoomViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
