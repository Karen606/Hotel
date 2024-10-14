//
//  BookRoomViewModel.swift
//  Hotel
//
//  Created by Karen Khachatryan on 15.10.24.
//

import Foundation

class BookRoomViewModel {
    static let shared = BookRoomViewModel()
    @Published var room: RoomModel?
    @Published var bookRoomModel = BookRoomModel()
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        guard let id = room?.id else { return }
        bookRoomModel.roomId = id
        CoreDataManager.shared.saveBookRoom(bookRoomModel: bookRoomModel) { error in
            completion(error)
        }
    }
    
    func reset() {
        bookRoomModel = BookRoomModel()
    }
    
    func clear() {
        room = nil
        bookRoomModel = BookRoomModel()
    }
}
