//
//  BookingTableViewCell.swift
//  Hotel
//
//  Created by Karen Khachatryan on 15.10.24.
//

import UIKit

protocol BookingTableViewDelegate: AnyObject {
    func removeBooking(id: UUID)
}

class BookingTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: ShadowView!
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var dateView: BottomRoundedView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    private var id: UUID?
    weak var delegate: BookingTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.font = .seversMedium(size: 14)
        typeLabel.font = .seversDemiBold(size: 12)
        sizeLabel.font = .seversMedium(size: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        roomImageView.image = nil
        dateLabel.text = nil
        id = nil
    }
    
    func setupData(booking: BookRoomModel) {
        self.id = booking.id
        if let data = booking.photo {
            roomImageView.image = UIImage(data: data)
        }
        dateLabel.text = "\(booking.startDate?.toString() ?? "")\n\(booking.endDate?.toString() ?? "")"
        typeLabel.text = booking.roomType
        sizeLabel.text = "\(booking.roomSize ?? "0")m², \(booking.roomBed ?? "")"

        let color = (BookingsViewModel.shared.type == .current) ? UIColor.baseBlue.withAlphaComponent(0.35) : .black.withAlphaComponent(0.25)
        dateView.backgroundColor = color
        bgView.backgroundColor = color
    }
    
    @IBAction func clickedRemove(_ sender: UIButton) {
        if let id = id {
            delegate?.removeBooking(id: id)
        }
    }
}
