//
//  UpdateHotelViewController.swift
//  MyHotels
//
//  Created by BhumeshwerKatre on 17/04/21.
//

import UIKit
typealias UpdateHotelRecordCallback = (_ hotel: Hotel) -> Void

class UpdateHotelViewController: UIViewController {
    var viewModel: UpdateHotelViewModel!
    var completionBlock: UpdateHotelRecordCallback?
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.estimatedSectionHeaderHeight = 16.0
        table.tableFooterView = UIView()
        table.tableHeaderView = UIView()
        table.register(HotelEntryCell.self, forCellReuseIdentifier: HotelEntryCell.cellID)
        table.register(PhotosCell.self, forCellReuseIdentifier: PhotosCell.cellID)
        return table
    }()
    init(withViewModel vm: UpdateHotelViewModel) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = viewModel.title
        let barButtonItem = UIBarButtonItem(title: Constants.doneTitle, style: .done, target: self, action: #selector(addUpdateRecordAction))
        self.navigationItem.rightBarButtonItem = barButtonItem
        setupTableView()
        self.viewModel.reloadSection = { [weak self] (section) in
            DispatchQueue.main.async {
                self?.tableView.reloadSections([section], with: .none)
            }
        }
    }
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

extension UpdateHotelViewController {
    @objc func addUpdateRecordAction(_ sender: UIBarButtonItem) {
        if self.viewModel.isValidEntry {
            self.completionBlock?(viewModel.getHotelRecord())
            self.navigationController?.popViewController(animated: true)
            return
        } else {
            self.alert(title: Constants.popUpTitle, message: Constants.inputErrorMsg)
        }
    }
}

extension UpdateHotelViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSection()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsAtSection(section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, let entryCell = tableView.dequeueReusableCell(withIdentifier: HotelEntryCell.cellID, for: indexPath) as? HotelEntryCell {
            entryCell.configureCell(viewModel.getCellViewModelForIndexPath(indexPath))
            entryCell.cellDelegate = self
            entryCell.selectionStyle = .none
            return entryCell
        } else if indexPath.section == 1, let photoCell = tableView.dequeueReusableCell(withIdentifier: PhotosCell.cellID, for: indexPath) as? PhotosCell {
            photoCell.cellDelegate = self
            photoCell.photos = self.viewModel.photos
            photoCell.selectionStyle = .none
            return photoCell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getHeaderTitleAtSection(section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension : 96
    }
}

extension UpdateHotelViewController: HotelEntryCellDelegate {
    func didTextFieldValueChanged(_ textField: UITextField, model: HotelEntryModel) {
        viewModel.checkPlaceHolderAndUpdateRate(textField.text ?? "", model: model)
    }
    
    func textFieldToolBarAction(_ textField: UITextField, model: HotelEntryModel, type: KeyboardToolbarButton) {
        if let index = viewModel.dataSource.firstIndex(where: { $0.placeHolder == model.placeHolder}) {
            switch type {
            case .back:
                if index == 0 {
                    fallthrough
                }
                if let cell = self.tableView.cellForRow(at: IndexPath(row: index-1, section: 0)) as? HotelEntryCell {
                    cell.entryTextField.becomeFirstResponder()
                }
            case .next:
                if index == viewModel.dataSource.count - 1 {
                    fallthrough
                }
                if let cell = self.tableView.cellForRow(at: IndexPath(row: index+1, section: 0)) as? HotelEntryCell {
                    cell.entryTextField.becomeFirstResponder()
                }
            default:
                textField.resignFirstResponder()
            }
            
            if model.placeHolder == Constants.roomRate, let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? HotelEntryCell {
                cell.configureCell(self.viewModel.dataSource[index])
            }
        }
    }
}

extension UpdateHotelViewController: PhotosCellDelegate {
    func didAddPhotoButtonTapped(atIndex index: Int) {
        //Show alert to selected the media source type.
        let alert = UIAlertController(title: Constants.addImageTitle, message: Constants.addImageDescription, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.cameraResoruceTitle, style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: Constants.photoAlbumResourceTitle, style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: Constants.cancelTitle, style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.viewModel.currentUpdateImageIndex = index
    }
    
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
}

extension UpdateHotelViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.dismiss(animated: true) { [weak self] in
            guard let weakSelf = self, let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            //Setting image to your image view
            weakSelf.viewModel.createPhotoRecordWithImage(image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
