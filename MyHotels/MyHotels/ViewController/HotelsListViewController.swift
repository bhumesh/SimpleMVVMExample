//
//  HotelsListViewController.swift
//  MyHotels
//
//  Created by BhumeshwerKatre on 17/04/21.
//

import UIKit

class HotelsListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var viewModel: HotelsViewModel = HotelsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = viewModel.pageTitle
        setupTableView()
        self.viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        self.viewModel.deleteSection = { [weak self] (indexPath) in
            DispatchQueue.main.async {
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    private func setupTableView() {
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
    }
}
extension HotelsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView = nil
        if viewModel.getNumberOfSection() > 0 {
            return 1
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.view.frame.size.height))
        label.text = Constants.addHotelHint
        label.textAlignment = .center
        tableView.backgroundView = label
        
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.hotelInfoCellID, for: indexPath) as? HotelInfoCell else {
            return UITableViewCell()
        }
        let model = viewModel.getCellViewModelAtIndexPath(indexPath)
        cell.configureCell(viewModel.getPhoto(atIndex: indexPath.row), name: model.name, rating: model.rating)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToUpdate(self.viewModel.getCellViewModelAtIndexPath(indexPath), index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.deleteRecordAtIndexPath(indexPath)
        }
    }
}
extension HotelsListViewController {
    @IBAction func addHotelAction(_ sender: UIBarButtonItem?) {
        navigateToUpdate(nil)
    }
    func navigateToUpdate(_ hotel: Hotel?, index: Int? = nil) {
        let viewModel = UpdateHotelViewModel(hotelData: hotel)
        let vc = UpdateHotelViewController(withViewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
        vc.completionBlock = { [weak self]  (updatedHotel) in
            self?.viewModel.addOrUpdateRecord(hotel, newRecord: updatedHotel, index: index)
        }
    }
}
