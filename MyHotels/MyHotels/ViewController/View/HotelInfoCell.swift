//
//  HotelInfoCell.swift
//  MyHotels
//
//  Created by BhumeshwerKatre on 17/04/21.
//

import UIKit

class HotelInfoCell: UITableViewCell {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var rating: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    private func setupCell() {
        self.accessoryType = .disclosureIndicator
        icon.backgroundColor = .yellow
        icon.contentMode = .scaleAspectFill
    }
}

extension HotelInfoCell {
    func configureCell(_ image: UIImage?, name: String, rating: String) {
        self.name.text = name
        self.rating.text = "Rating: \(rating)"
        self.icon.image = image
    }
}
