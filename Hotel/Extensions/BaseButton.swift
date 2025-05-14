//
//  BaseButton.swift
//  Hotel
//
//  Created by Karen Khachatryan on 15.10.24.
//

import UIKit

class BaseButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? self.backgroundColor?.withAlphaComponent(1) : self.backgroundColor?.withAlphaComponent(0.4)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class SectionButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .baseBlue.withAlphaComponent(1) : #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
