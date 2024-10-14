//
//  ViewController.swift
//  Hotel
//
//  Created by Karen Khachatryan on 12.10.24.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet var sectionsButton: [UIButton]!
    @IBOutlet var BottomSectionsButton: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let infoButton = UIButton(type: .custom)
        infoButton.setImage(UIImage.info, for: .normal)
        infoButton.addTarget(self, action: #selector(clickedInfo), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        sectionsButton.forEach({ $0.titleLabel?.font = .travelsDemiBold(size: 32) })
        BottomSectionsButton.forEach({ $0.titleLabel?.font = .robotoMedium(size: 14)})
    }

    @objc func clickedInfo() {
        self.pushViewController(HotelViewController.self)
    }

    @IBAction func clickedRooms(_ sender: UIButton) {
        self.pushViewController(RoomsViewController.self)
    }
    
    @IBAction func clickedBookRoom(_ sender: UIButton) {
        self.pushViewController(RoomsListViewController.self)
    }
    
    @IBAction func clickedBooking(_ sender: UIButton) {
        self.pushViewController(BookRoomViewController.self)
    }
    @IBAction func clickedSupport(_ sender: UIButton) {
    }
}

