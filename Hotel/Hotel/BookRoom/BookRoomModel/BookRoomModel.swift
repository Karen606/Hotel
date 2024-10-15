//
//  BookRoomModel.swift
//  Hotel
//
//  Created by Karen Khachatryan on 15.10.24.
//

import Foundation

struct BookRoomModel {
    var id: UUID?
    var roomId: UUID?
    var photo: Data?
    var startDate: Date?
    var endDate: Date?
    var numberOfGuests: String?
    var name: String?
    var surname: String?
    var email: String?
    var phoneNumber: String?
}
