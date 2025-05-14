//
//  RoomsViewModel.swift
//  Hotel
//
//  Created by Karen Khachatryan on 13.10.24.
//

import UIKit

class RoomsViewModel {
    static let shared = RoomsViewModel()
    @Published var rooms: [RoomModel] = []
    
    func fetchRooms() {
        CoreDataManager.shared.fetchRooms { [weak self] rooms, error in
            guard let self = self else { return }
            self.rooms = rooms
        }
    }
}
