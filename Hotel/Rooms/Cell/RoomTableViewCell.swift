//
//  RoomTableViewCell.swift
//  Hotel
//
//  Created by Karen Khachatryan on 13.10.24.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var bgView: ShadowView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var priceNightLabel: UILabel!
    @IBOutlet weak var imageViewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var labelConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceLabel.font = .seversMedium(size: 22)
        infoLabel.font = .seversMedium(size: 12)
        typeLabel.font = .seversDemiBold(size: 12)
        sizeLabel.font = .seversMedium(size: 10)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        roomImageView.image = nil
    }
    
    func setupData(room: RoomModel) {
        if let data = room.photo {
            roomImageView.image = UIImage(data: data)
        }
        priceLabel.text = "\(room.price?.formattedToString() ?? "")$"
        typeLabel.text = room.type
        sizeLabel.text = "\(room.size ?? "0")m², \(room.bed ?? "")"
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
        priceNightLabel.attributedText = combinedAttributedString
        infoLabel.text = room.facilities?.joined(separator: "\n")
    }
    
    @IBAction func clickedShowDetails(_ sender: UIButton) {
        sender.isSelected.toggle()
        labelConst.isActive = sender.isSelected
        imageViewBottomConst.isActive = !sender.isSelected
        priceLabel.isHidden = sender.isSelected
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        if let tableView = self.superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
