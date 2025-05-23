//
//  CoreDataManager.swift
//  Hotel
//
//  Created by Karen Khachatryan on 13.10.24.
//


import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Hotel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveHotel(hotelModel: HotelModel, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Hotel> = Hotel.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let hotel: Hotel
                if let existingHotel = results.first {
                    hotel = existingHotel
                } else {
                    hotel = Hotel(context: backgroundContext)
                }
                hotel.brefInformation = hotelModel.brefInformation
                hotel.name = hotelModel.name
                hotel.photo = hotelModel.photos
                hotel.rules = hotelModel.rules
                hotel.services = hotelModel.services
                
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchHotel(completion: @escaping (HotelModel?, Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Hotel> = Hotel.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let hotel = results.first {
                    let hotelModel = HotelModel(photos: hotel.photo, name: hotel.name, brefInformation: hotel.brefInformation, rules: hotel.rules, services: hotel.services)
                    DispatchQueue.main.async {
                        completion(hotelModel, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }

    func saveRoom(roomModel: RoomModel, completion: @escaping (Error?) -> Void) {
        let id = roomModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Room> = Room.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let room: Room

                if let existingRoom = results.first {
                    room = existingRoom
                } else {
                    room = Room(context: backgroundContext)
                    room.id = id
                }
                room.photo = roomModel.photo
                room.price = roomModel.price ?? 0
                room.type = roomModel.type
                room.size = roomModel.size
                room.bed = roomModel.bed
                room.facilities = roomModel.facilities
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchRooms(completion: @escaping ([RoomModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Room> = Room.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var roomsModel: [RoomModel] = []
                for result in results {
                    let roomModel = RoomModel(id: result.id, photo: result.photo, price: result.price, type: result.type, size: result.size, bed: result.bed, facilities: result.facilities)
                    roomsModel.append(roomModel)
                }
                completion(roomsModel, nil)
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func saveBookRoom(bookRoomModel: BookRoomModel, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            do {
                let bookRoom = BookRoom(context: backgroundContext)
                bookRoom.id = bookRoomModel.id
                bookRoom.roomID = bookRoomModel.roomId
                bookRoom.startDate = bookRoomModel.startDate
                bookRoom.endDate = bookRoomModel.endDate
                bookRoom.numberOfGuests = bookRoomModel.numberOfGuests
                bookRoom.name = bookRoomModel.name
                bookRoom.surname = bookRoomModel.surname
                bookRoom.email = bookRoomModel.email
                bookRoom.phoneNumber = bookRoomModel.phoneNumber
                bookRoom.photo = bookRoomModel.photo
                bookRoom.roomType = bookRoomModel.roomType
                bookRoom.roomSize = bookRoomModel.roomSize
                bookRoom.roomBed = bookRoomModel.roomBed
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchBookings(completion: @escaping ([BookRoomModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<BookRoom> = BookRoom.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var bookingsModel: [BookRoomModel] = []
                for result in results {
                    let bookingModel = BookRoomModel(id: result.id, roomId: result.roomID, photo: result.photo, startDate: result.startDate, endDate: result.endDate, numberOfGuests: result.numberOfGuests, name: result.name, surname: result.surname, email: result.email, phoneNumber: result.phoneNumber, roomType: result.roomType, roomSize: result.roomSize, roomBed: result.roomBed)
                    bookingsModel.append(bookingModel)
                }
                completion(bookingsModel, nil)
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func removeBooking(id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<BookRoom> = BookRoom.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let bookingToDelete = results.first {
                    backgroundContext.delete(bookingToDelete)
                    
                    do {
                        try backgroundContext.save()
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(error)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Booking with id \(id) not found."])
                        completion(error)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }


}
