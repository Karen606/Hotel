//
//  RoomModel.swift
//  Hotel
//
//  Created by Karen Khachatryan on 13.10.24.
//

import Foundation

struct RoomModel {
    var id: UUID?
    var photo: Data?
    var price: Double?
    var type: String?
    var size: String?
    var bed: String?
    var facilities: [String]?
}
