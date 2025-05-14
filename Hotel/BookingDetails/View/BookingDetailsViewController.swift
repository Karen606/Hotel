//
//  BookingDetailsViewController.swift
//  Hotel
//
//  Created by Karen Khachatryan on 15.10.24.
//

import UIKit

class BookingDetailsViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageBgView: ShadowView!
    @IBOutlet weak var dateView: BottomRoundedView!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var startDateTextField: DateTextField!
    @IBOutlet weak var endDateTextField: DateTextField!
    @IBOutlet weak var guestNumberTextField: BaseTextField!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var surnameTextField: BaseTextField!
    @IBOutlet weak var emailTextField: EmailTextField!
    @IBOutlet weak var phoneNumberTextField: BaseTextField!
    var bookingModel: BookRoomModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.setNavigationBar(title: "Bookings")
        titleLabels.forEach({ $0.font = .interRegular(size: 14) })
        dateLabel.font = .seversMedium(size: 14)
        typeLabel.font = .seversDemiBold(size: 12)
        sizeLabel.font = .seversMedium(size: 10)
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = #colorLiteral(red: 0.6887677908, green: 0.6887677312, blue: 0.6887677312, alpha: 1).cgColor
        bgView.layer.cornerRadius = 20
        startDateTextField.setupRightViewIcon(UIImage.dateArrow)
        startDateTextField.setupLeftViewIcon(UIImage.calendar)
        endDateTextField.setupRightViewIcon(UIImage.dateArrow)
        endDateTextField.setupLeftViewIcon(UIImage.calendar)
        guard let booking = bookingModel else { return }
        if let data = booking.photo {
            self.photoImageView.image = UIImage(data: data)
        }
        self.typeLabel.text = bookingModel?.roomType
        self.sizeLabel.text = "\(bookingModel?.roomSize ?? "0")m², \(bookingModel?.roomBed ?? "")"
        startDateTextField.text = booking.startDate?.toString()
        endDateTextField.text = booking.endDate?.toString()
        guestNumberTextField.text = booking.numberOfGuests
        nameTextField.text = booking.name
        surnameTextField.text = booking.surname
        emailTextField.text = booking.email
        phoneNumberTextField.text = booking.phoneNumber
        dateLabel.text = "\(booking.startDate?.toString() ?? "")\n\(booking.endDate?.toString() ?? "")"
        let color = (BookingsViewModel.shared.type == .current) ? UIColor.baseBlue.withAlphaComponent(0.35) : .black.withAlphaComponent(0.25)
        dateView.backgroundColor = color
        imageBgView.backgroundColor = color
    }
}
