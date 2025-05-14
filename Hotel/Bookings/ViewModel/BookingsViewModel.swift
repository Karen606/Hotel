//
//  BookingsViewModel.swift
//  Hotel
//
//  Created by Karen Khachatryan on 15.10.24.
//

import Foundation

class BookingsViewModel {
    static let shared = BookingsViewModel()
    @Published var bookings: [BookRoomModel] = []
    var type: BookingsType = .current
    var data: [BookRoomModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchBookings { [weak self] bookings, error in
            guard let self = self else { return }
            self.data = bookings
            self.filterByType()
        }
    }
    
    func chooseBookingType(type: BookingsType) {
        self.type = type
        filterByType()
    }
    
    func filterByType() {
        if type == .current {
            bookings = data.filter { booking in
                if let endDate = booking.endDate {
                    return endDate >= Date()
                }
                return false
            }
        } else if type == .archive {
            bookings = data.filter { booking in
                if let endDate = booking.endDate {
                    return endDate < Date()
                }
                return false
            }
        }
    }
    
    func removeBooking(id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.removeBooking(id: id) { error in
            completion(error)
        }
    }
    
    func clear() {
        bookings = []
        data = []
        type = .current
    }
}

enum BookingsType {
    case current
    case archive
}
