//
//  UIViewController+Extension.swift
//  MyHotels
//
//  Created by BhumeshwerKatre on 17/04/21.
//

import UIKit

extension UIViewController {
    func alert(title: String, message: String ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.okButtonTitle, style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
