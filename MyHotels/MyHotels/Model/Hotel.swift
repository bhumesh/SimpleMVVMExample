//
//  Hotel.swift
//  MyHotels
//
//  Created by BhumeshwerKatre on 17/04/21.
//

import Foundation
import UIKit
struct HotelPhoto {
    var name: String
    var path: String
    var image: UIImage
}
struct Hotel {
    var id: String // Unique value
    var name: String
    var address: String
    var dateOfStay: String
    var rate: String
    var rating: String
    var photos: [HotelPhoto]
    var lastUpdateDate: String
    
    var getRate: String {
        return "\(rate)"
    }
    var getRating: String {
        return "\(rating)"
    }
}
