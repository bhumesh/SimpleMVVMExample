//
//  HotelEntryModel.swift
//  MyHotels
//
//  Created by BhumeshwerKatre on 17/04/21.
//

import Foundation
enum TextFieldInput: Int {
    case name = 0
    case address
    case dateInput
    case rate
    case rating
}
struct HotelEntryModel {
    let placeHolder: String
    var value: String? {
        didSet {
            self.dispalyValue = value
        }
    }
    var dispalyValue: String?
    let inputType: TextFieldInput
    var inputs: [String] = []
    init(placeHolder: String, value: String? = nil, inputType: TextFieldInput) {
        self.inputType = inputType
        self.placeHolder = placeHolder
        self.value = value
        self.dispalyValue = value
        if inputType == .rating {
            prepareRating()
        }
    }
    mutating func prepareRating() {
        inputs = ["1", "2", "3", "4", "5"]
    }
    func getStringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    func getLastupdateDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd'T'hh:mm:ss.sss"
        return dateFormatter.string(from: date)
    }

    func getFormattedRate(_ rate: String) -> String {
        return Utility.getFormatterRate(rate)
    }
}
