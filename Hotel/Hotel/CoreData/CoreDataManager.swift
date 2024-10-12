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
                    completion(hotelModel, nil)
                } else {
                    completion(nil, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
    }


}
