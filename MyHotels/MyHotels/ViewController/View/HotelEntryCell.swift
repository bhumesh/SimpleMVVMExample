//
//  HotelEntryCell.swift
//  MyHotels
//
//  Created by BhumeshwerKatre on 17/04/21.
//

import UIKit

protocol HotelEntryCellDelegate: class {
    func didTextFieldValueChanged(_ textField: UITextField, model: HotelEntryModel)
    func textFieldToolBarAction(_ textField: UITextField, model: HotelEntryModel, type: KeyboardToolbarButton)
}
class HotelEntryCell: UITableViewCell {
    static let cellID = "HotelEntryCell"
    var model: HotelEntryModel!
    weak var cellDelegate: HotelEntryCellDelegate?
    let entryTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.maximumDate = Date()
        picker.minimumDate = Date().addingTimeInterval(-365*24*60*60)
        
        picker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        return picker
    }()
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.sizeToFit()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.contentView.addSubview(entryTextField)
        NSLayoutConstraint.activate([
            entryTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            entryTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            entryTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            entryTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
         ])
    }
}

extension HotelEntryCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        cellDelegate?.didTextFieldValueChanged(textField, model: self.model)
    }
}

extension HotelEntryCell {
    @objc func datePickerChanged() {
        self.entryTextField.text = model.getStringFromDate(datePicker.date)
        cellDelegate?.didTextFieldValueChanged(self.entryTextField, model: self.model)
    }
    func configureCell(_ model: HotelEntryModel) {
        self.model = model
        self.entryTextField.delegate = self
        self.entryTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.entryTextField.placeholder = model.placeHolder
        self.entryTextField.text = model.dispalyValue
        switch model.inputType {
        case .address, .name, .rate:
            self.entryTextField.inputView = nil
            self.entryTextField.keyboardType = .default
            if model.inputType == .rate {
                self.entryTextField.keyboardType = .numberPad
            }
            let letButtons: [KeyboardToolbarButton] = (model.inputType == .name) ? [KeyboardToolbarButton.backDisabled, KeyboardToolbarButton.next] : [KeyboardToolbarButton.back, KeyboardToolbarButton.next]
            self.entryTextField.addKeyboardToolBar(leftButtons: letButtons, rightButtons: [.done], toolBarDelegate: self)
        case .dateInput:
            self.entryTextField.inputView = datePicker
            self.entryTextField.addKeyboardToolBar(leftButtons: [.back, .next], rightButtons: [.done], toolBarDelegate: self)
        case .rating:
            self.entryTextField.inputView = pickerView
            self.entryTextField.addKeyboardToolBar(leftButtons: [.back, .nextDisabled], rightButtons: [.done], toolBarDelegate: self)
        }
    }
}

extension HotelEntryCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.inputs.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.entryTextField.text = model.inputs[row]
        cellDelegate?.didTextFieldValueChanged(self.entryTextField, model: self.model)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.model.inputs[row]
    }
}

extension HotelEntryCell: KeyboardToolbarDelegate {
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOf textField: UITextField) {
        cellDelegate?.textFieldToolBarAction(textField, model: model, type: type)
    }
}
