//
//  RoomFormViewModel.swift
//  Hotel
//
//  Created by Karen Khachatryan on 14.10.24.
//

import Foundation

class RoomFormViewModel {
    static let shared = RoomFormViewModel()
    var roomModel = RoomModel(id: UUID())
    private init() {}
    
    func saveRoom(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveRoom(roomModel: roomModel) { error in
            completion(error)
        }
    }
    
    func clear() {
        roomModel = RoomModel(id: UUID())
    }
}
