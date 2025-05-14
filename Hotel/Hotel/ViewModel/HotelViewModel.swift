//
//  HotelViewModel.swift
//  Hotel
//
//  Created by Karen Khachatryan on 12.10.24.
//

import UIKit

class HotelViewModel {
    static let shared = HotelViewModel()
    @Published var hotelModel: HotelModel = HotelModel(photos: [UIImage.imagePlaceholder.pngData() ?? Data()])
    var isEditing = false
    var isAppenedImage = false
    
    private init() {}
    
    func addImage(data: Data) {
        if !isAppenedImage {
            hotelModel.photos?.removeAll()
            isAppenedImage = true
        }
        hotelModel.photos?.append(data)
    }
    
    func saveHotel(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveHotel(hotelModel: hotelModel) { error in
            completion(error)
        }
    }
    
    func fetchHotel() {
        CoreDataManager.shared.fetchHotel { [weak self] hotelModel, error in
            guard let self = self else { return }
            if let hotelModel = hotelModel {
                self.hotelModel = hotelModel
                self.isEditing = true
            } else {
                self.isEditing = false
            }
        }
    }
    
    func clear() {
        hotelModel = HotelModel(photos: [UIImage.imagePlaceholder.jpegData(compressionQuality: 1.0) ?? Data()])

        isEditing = false
    }
}
