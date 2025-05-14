//
//  RoomsViewController.swift
//  Hotel
//
//  Created by Karen Khachatryan on 13.10.24.
//

import UIKit
import Combine

class RoomsViewController: UIViewController {

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
    
    @objc func addRoom() {
        let roomFormVC = RoomFormViewController(nibName: "RoomFormViewController", bundle: nil)
        roomFormVC.completion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchRooms()
        }
        self.navigationController?.pushViewController(roomFormVC, animated: true)
    }
}

extension RoomsViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 38))
        let addRoomButton = UIButton(type: .custom)
        addRoomButton.setImage(UIImage.addBig, for: .normal)
        addRoomButton.addTarget(self, action: #selector(addRoom), for: .touchUpInside)
        addRoomButton.frame = CGRect(x: (footerView.frame.width - 38) / 2, y: 0, width: 38, height: 38)
        footerView.addSubview(addRoomButton)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        38
    }
    
}
