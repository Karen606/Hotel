//
//  BaseTextField.swift
//  Hotel
//
//  Created by Karen Khachatryan on 12.10.24.
//

import UIKit

class BaseTextField: UITextField {
    private var padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 14)
    private let bottomLabel = UILabel()
    private var heightConst: CGFloat = 0
    private var isValidate: Bool = true {
        didSet {
            bottomLabel.isHidden = isValidate
            if let view = self.superview {
                if heightConst == 0 {
                    heightConst = view.constraints.first?.constant ?? 0
                }
                view.constraints.first?.constant = isValidate ? heightConst : heightConst + bottomLabel.bounds.height + 8
            }
        }
    }
    var heightForError: CGFloat {
        get {
            isValidate ? self.bounds.height : self.bounds.height + bottomLabel.bounds.height + 8
        }
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func checkValidation() -> Bool {
        if let text = text?.trimmingCharacters(in: .whitespaces), text.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func showError(error: String? = "required field") {
        if let error = error {
            bottomLabel.text = error
            bottomLabel.frame.size.width = self.bounds.width - 32
            bottomLabel.sizeToFit()
            if isValidate {
                isValidate = false
            }
            return
        }
        bottomLabel.sizeToFit()
        if !isValidate {
            isValidate = true
        }
    }
    
    func commonInit() {
        bottomLabel.font = UIFont.systemFont(ofSize: 12)
        bottomLabel.textColor = .red
        bottomLabel.backgroundColor = .clear
        bottomLabel.isHidden = true
        bottomLabel.sizeToFit()
        bottomLabel.frame.origin = CGPoint(x: 16, y: self.bounds.height + 4)
        bottomLabel.numberOfLines = 0
        addSubview(bottomLabel)
        self.font = .interRegular(size: 14)
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.5741509795, green: 0.5741508603, blue: 0.5741509199, alpha: 1).cgColor
        self.textColor = .baseGray
        self.backgroundColor = .clear
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayTitle, NSAttributedString.Key.font: UIFont.interItalicLight(size: 12)!]
        )
    }
}

extension UITextView {
    func checkValidation() -> Bool {
        if let text = text?.trimmingCharacters(in: .whitespaces), text.isEmpty {
            return false
        } else {
            return true
        }
    }
}

class DateTextField: UITextField {
    private let bottomLabel = UILabel()
    private var heightConst: CGFloat = 0
    private var isValidate: Bool = true {
        didSet {
            bottomLabel.isHidden = isValidate
            if let view = self.superview {
                if heightConst == 0 {
                    heightConst = view.constraints.first?.constant ?? 0
                }
                view.constraints.first?.constant = isValidate ? heightConst : heightConst + bottomLabel.bounds.height + 8
            }
        }
    }
    var heightForError: CGFloat {
        get {
            isValidate ? self.bounds.height : self.bounds.height + bottomLabel.bounds.height + 8
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func checkValidation() -> Bool {
        if let text = text?.trimmingCharacters(in: .whitespaces), text.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func showError(error: String? = "required field") {
        if let error = error {
            bottomLabel.text = error
            bottomLabel.frame.size.width = self.bounds.width - 32
            bottomLabel.sizeToFit()
            if isValidate {
                isValidate = false
            }
            return
        }
        bottomLabel.sizeToFit()
        if !isValidate {
            isValidate = true
        }
    }
    
    func commonInit() {
        bottomLabel.font = UIFont.systemFont(ofSize: 12)
        bottomLabel.textColor = .red
        bottomLabel.backgroundColor = .clear
        bottomLabel.isHidden = true
        bottomLabel.sizeToFit()
        bottomLabel.frame.origin = CGPoint(x: 16, y: self.bounds.height + 4)
        bottomLabel.numberOfLines = 0
        addSubview(bottomLabel)
        self.font = .interRegular(size: 14)
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.5741509795, green: 0.5741508603, blue: 0.5741509199, alpha: 1).cgColor
        self.textColor = .baseGray
        self.backgroundColor = .clear
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayTitle, NSAttributedString.Key.font: UIFont.interItalicLight(size: 12)!]
        )
    }
}

extension UITextField {
    func setupRightViewIcon(_ image: UIImage) {
        let icon = UIImageView(frame:CGRect(x: 0, y: 0, width: 26, height: 26))
        icon.image = image
        icon.contentMode = .center
        let iconContainerView: UIView = UIView(frame:CGRect(x: 0, y: 0, width: 26, height: 26))
        iconContainerView.isUserInteractionEnabled = false
        iconContainerView.addSubview(icon)
        rightView = iconContainerView
        rightViewMode = .always
    }
    
    func setupLeftViewIcon(_ image: UIImage) {
        let icon = UIImageView(frame:CGRect(x: 0, y: 0, width: 26, height: 26))
        icon.image = image
        icon.contentMode = .center
        let iconContainerView: UIView = UIView(frame:CGRect(x: 0, y: 0, width: 26, height: 26))
        iconContainerView.isUserInteractionEnabled = false
        iconContainerView.addSubview(icon)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

class EmailTextField: BaseTextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        emailCommonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        emailCommonInit()
    }
    
    private func emailCommonInit() {
        self.delegate = self
        self.keyboardType = .default
    }
    
    func isValidEmail() {
        self.showError(error: (self.text.isValidEmail()) ? nil : "Please enter a valid email address")
    }
}
