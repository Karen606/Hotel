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
    @Published var bookRoomModel = BookRoomModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        guard let id = room?.id else { return }
        bookRoomModel.roomId = id
        bookRoomModel.photo = room?.photo
        CoreDataManager.shared.saveBookRoom(bookRoomModel: bookRoomModel) { error in
            completion(error)
        }
    }
    
    func reset() {
        bookRoomModel = BookRoomModel(id: UUID())
    }
    
    func clear() {
        room = nil
        bookRoomModel = BookRoomModel(id: UUID())
    }
}
