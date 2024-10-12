//
//  BaseTextViewDelegate.swift
//  Hotel
//
//  Created by Karen Khachatryan on 12.10.24.
//


import UIKit

protocol BaseTextViewDelegate: AnyObject {
    func didChancheSelection(_ textView: UITextView)
}

class BaseTextView: UITextView {
    
    private var customPadding = UIEdgeInsets(top: 8, left: 8, bottom: 4, right: 8)
    weak var baseDelegate: BaseTextViewDelegate?
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayTitle
        label.font = .interItalicLight(size: 12)
        label.numberOfLines = 0
        return label
    }()
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
        }
    }
    
    override var text: String! {
        didSet {
            togglePlaceholderVisibility()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = customPadding
        placeholderLabel.frame.origin = CGPoint(x: customPadding.left + 5, y: customPadding.top)
        placeholderLabel.frame.size.width = frame.width - (customPadding.left + customPadding.right + 10)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPlaceholder()
        self.layer.borderColor = UIColor.grayTitle.cgColor
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 0.5
        self.delegate = self
        self.font = .interRegular(size: 14)
        self.textColor = .baseGray
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        addSubview(placeholderLabel)
        placeholderLabel.isHidden = !text.isEmpty
        togglePlaceholderVisibility()
    }
    
    private func togglePlaceholderVisibility() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}

extension BaseTextView: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        baseDelegate?.didChancheSelection(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        togglePlaceholderVisibility()
    }
}
