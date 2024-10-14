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
                    let roomModel = RoomModel(id: result.id, photo: result.photo, price: result.price, facilities: result.facilities)
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
                bookRoom.id = bookRoomModel.roomId
                bookRoom.startDate = bookRoomModel.startDate
                bookRoom.endDate = bookRoomModel.endDate
                bookRoom.numberOfGuests = bookRoomModel.numberOfGuests
                bookRoom.name = bookRoomModel.name
                bookRoom.surname = bookRoomModel.surname
                bookRoom.email = bookRoomModel.email
                bookRoom.phoneNumber = bookRoomModel.phoneNumber
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
}
