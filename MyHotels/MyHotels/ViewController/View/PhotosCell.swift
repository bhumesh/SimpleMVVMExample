//
//  PhotosCell.swift
//  MyHotels
//
//  Created by BhumeshwerKatre on 17/04/21.
//

import UIKit

protocol PhotosCellDelegate: class {
    func didAddPhotoButtonTapped(atIndex index: Int)
}
class PhotosCell: UITableViewCell {
    static let cellID = "PhotosCell"
    var collectionView: UICollectionView!
    var photos: [HotelPhoto]! {
        didSet {
            self.collectionView.reloadData()
        }
    }
    weak var cellDelegate: PhotosCellDelegate?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        setupCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotosCell {
    func setupCell() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 72, height: 72)
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.minimumInteritemSpacing = 6.0
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellID)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .white
        
        self.contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension PhotosCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellID, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        cell.button.tag = indexPath.item
        DispatchQueue.main.async {
            cell.configureCell(self.photos[indexPath.item].image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

extension PhotosCell {
    @objc func addButtonTapped(_ sender: UIButton) {
        cellDelegate?.didAddPhotoButtonTapped(atIndex: sender.tag)
    }
}
