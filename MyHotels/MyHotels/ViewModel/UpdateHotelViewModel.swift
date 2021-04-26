//
//  UpdateHotelViewModel.swift
//  MyHotels
//
//  Created by BhumeshwerKatre on 17/04/21.
//

import Foundation
import UIKit
struct UpdateHotelViewModel {
    var dataSource: [HotelEntryModel]!
    var headers: [String] = [Constants.hotelInfoHeadertitle, Constants.photosHeadertitle]
    var hotelData: Hotel?
    var photos: [HotelPhoto] = []
    var currentUpdateImageIndex: Int = -1
    var reloadSection: ((Int)->())?

    var title: String {
        return hotelData != nil ? Constants.updateTitle : Constants.addHotelTitle
    }
    var isValidEntry: Bool {
        guard let name = self.dataSource[0].value, name.isEmpty, let dateOfStay = self.dataSource[2].value, dateOfStay.isEmpty else {
            return true
        }

        return false
    }
    init(hotelData: Hotel?) {
        self.hotelData = hotelData
        prepateUIModels()
    }
    private mutating func prepateUIModels() {
        dataSource = [HotelEntryModel(placeHolder: Constants.hotelName, value: hotelData?.name ?? "", inputType: .name),
                      HotelEntryModel(placeHolder: Constants.address, value: hotelData?.address ?? "", inputType: .address),
                      HotelEntryModel(placeHolder: Constants.dateOfStay, value: hotelData?.dateOfStay ?? "", inputType: .dateInput),
                      HotelEntryModel(placeHolder: Constants.roomRate, value: hotelData?.getRate ?? "", inputType: .rate),
                      HotelEntryModel(placeHolder: Constants.rating, value: hotelData?.getRating ?? "", inputType: .rating)]
   
        self.photos.append(HotelPhoto(name: "<image_name>", path: "<image_path>", image: UIImage(named: "add-photo")!))
        if let hotelInfo = hotelData, hotelInfo.photos.count > 0 {
            self.photos.append(contentsOf: hotelInfo.photos)
        }
    }
    mutating func getHotelRecord() -> Hotel {
        if self.photos.count > 0 {
            self.photos.remove(at: 0)
        }
        let hotelInfo: Hotel = Hotel(id: Utility.randomStringWithLength(len: 9),
                                     name: self.dataSource[0].value ?? "",
                                     address: self.dataSource[1].value ?? "",
                                     dateOfStay: self.dataSource[2].value ?? "",
                                     rate: self.dataSource[3].value ?? "",
                                     rating: self.dataSource[4].value ?? "",
                                     photos: self.photos,
                                     lastUpdateDate: self.dataSource[0].getLastupdateDate(Date()))
        return hotelInfo
    }
    func getNumberOfSection() -> Int {
        return headers.count
    }
    func getHeaderTitleAtSection(_ section: Int) -> String {
        return headers[section]
    }
    func getNumberOfRowsAtSection(_ section: Int) -> Int {
        if section == 0 {
            return self.dataSource.count
        }
        return 1
    }
    func getCellViewModelForIndexPath(_ indexPath: IndexPath) -> HotelEntryModel {
        return dataSource[indexPath.row]
    }
    mutating func checkPlaceHolderAndUpdateRate(_ rate: String, model: HotelEntryModel) {
        if let index = dataSource.firstIndex(where: { $0.placeHolder == model.placeHolder}) {
            var model = dataSource[index]
            model.value = rate
            if model.placeHolder == Constants.roomRate {
                var rate = rate.replacingOccurrences(of: "$", with: "")
                rate = rate.replacingOccurrences(of: ",", with: "")
                model.value = rate
                model.dispalyValue = Utility.getFormatterRate(model.value ?? "")
            }
            dataSource[index] = model
        }
    }
    mutating func createPhotoRecordWithImage(_ image: UIImage) {
        let photo = HotelPhoto(name: "<image-name>", path: "<image-path>", image: image)
        if currentUpdateImageIndex > 0 {
            photos[currentUpdateImageIndex] = photo
        } else {
           photos.append(photo)
        }
        self.reloadSection?(1)
    }
}

