//
//  RoomsListViewController.swift
//  Hotel
//
//  Created by Karen Khachatryan on 14.10.24.
//

import UIKit
import Combine

class RoomsListViewController: UIViewController {

    @IBOutlet weak var roomsTableView: UITableView!
    private let viewModel = RoomsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchRooms()
    }
    
    func setupUI() {
        self.setNavigationBar(title: "Rooms")
        roomsTableView.delegate = self
        roomsTableView.dataSource = self
        roomsTableView.register(UINib(nibName: "RoomTableViewCell", bundle: nil), forCellReuseIdentifier: "RoomTableViewCell")
    }
    
    func subscribe() {
        viewModel.$rooms
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rooms in
                guard let self = self else { return }
                self.roomsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension RoomsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTableViewCell", for: indexPath) as! RoomTableViewCell
        cell.setupData(room: viewModel.rooms[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookRoomVC = BookRoomViewController(nibName: "BookRoomViewController", bundle: nil)
        BookRoomViewModel.shared.room = viewModel.rooms[indexPath.row]
        self.navigationController?.pushViewController(bookRoomVC, animated: true)
    }
    
}
