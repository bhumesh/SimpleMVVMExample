//
//  CollectionViewCell.swift
//  MyHotels
//
//  Created by BhumeshwerKatre on 17/04/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let cellID = "CollectionViewCell"
    var button = UIButton(type: .custom)
    override init(frame: CGRect) {
         super.init(frame: frame)
        setupCell()
     }
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}

extension CollectionViewCell {
    func setupCell() {
        button.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 4),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
         ])
    }
    func configureCell(_ image: UIImage) {
        self.button.setImage(image, for: .normal)
    }
}
