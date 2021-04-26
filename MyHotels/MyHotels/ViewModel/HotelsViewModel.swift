//
//  HotelsViewModel.swift
//  MyHotels
//
//  Created by BhumeshwerKatre on 17/04/21.
//

import Foundation
import UIKit
struct HotelsViewModel {
    var dataSource: [Hotel] = []
    var reloadTableView: (()->())?
    var deleteSection: ((IndexPath)->())?
    var pageTitle: String {
        return Constants.homeTitle
    }
    func getPhoto(atIndex index: Int) -> UIImage? {
        if dataSource[index].photos.count > 0, let image = dataSource[index].photos.randomElement()?.image {
            return image
        }
        return UIImage(named: "add-photo")
    }
    func getNumberOfSection() -> Int {
        return dataSource.count
    }
    func getNumberOfRows() -> Int {
        return dataSource.count
    }
    func getCellViewModelAtIndexPath(_ indexPath: IndexPath) -> Hotel {
        return dataSource[indexPath.row]
    }
    mutating func addOrUpdateRecord(_ existingRecord: Hotel?, newRecord: Hotel, index: Int?) {
        if existingRecord != nil, let index = index {
            dataSource[index] = newRecord
        } else {
            dataSource.append(newRecord)
        }
        dataSource.sort {$0.lastUpdateDate > $1.lastUpdateDate}
        self.reloadTableView?()
    }
    mutating func deleteRecordAtIndexPath(_ indexPath: IndexPath) {
        dataSource.remove(at: indexPath.row)
        if dataSource.count > 0 {
            self.deleteSection?(indexPath)
        } else {
            self.reloadTableView?()
        }
    }
}
