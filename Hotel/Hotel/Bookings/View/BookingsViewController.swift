//
//  BookingsViewController.swift
//  Hotel
//
//  Created by Karen Khachatryan on 15.10.24.
//

import UIKit
import Combine

class BookingsViewController: UIViewController {

    @IBOutlet weak var currentBookingButton: SectionButton!
    @IBOutlet weak var archiveBookingButton: SectionButton!
    @IBOutlet weak var bookingsTableView: UITableView!
    private let viewModel = BookingsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        self.setNavigationBar(title: "Bookings")
        bookingsTableView.delegate = self
        bookingsTableView.dataSource = self
        bookingsTableView.register(UINib(nibName: "BookingTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingTableViewCell")
    }
    
    func subscribe() {
        viewModel.$bookings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookings in
                guard let self = self else { return }
                self.currentBookingButton.isSelected = self.viewModel.type == .current
                self.archiveBookingButton.isSelected = self.viewModel.type == .archive
                self.bookingsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func clickedCurrentBookings(_ sender: SectionButton) {
        viewModel.chooseBookingType(type: .current)
    }
    
    @IBAction func clickedArchiveBookings(_ sender: SectionButton) {
        viewModel.chooseBookingType(type: .archive)
    }
}

extension BookingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.bookings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTableViewCell", for: indexPath) as! BookingTableViewCell
        cell.setupData(booking: viewModel.bookings[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension BookingsViewController: BookingTableViewDelegate {
    func removeBooking(id: UUID) {
        viewModel.removeBooking(id: id) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                viewModel.fetchData()
            }
        }
    }
}
