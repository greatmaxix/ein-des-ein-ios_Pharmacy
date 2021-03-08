//
//  OrderServiceViewController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 23.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol OrderServiceVControllerOutput: OrderServiceViewModelInput {}
protocol OrderServiceVControllerInput: OrderServiceViewModelModelOutput {}

//
//"checkout.title" = "Оформление";
//"checkout.contactData" = "Контактные данные";
//"checkout.change" = "Изменить";
//"checkout.deliveryType" = "Способ доставки";
//"checkout.deliveryAddress" = "Адрес доставки";
//"checkout.farmacyAddress" = "Адрес аптеки";
//"checkout.paymentType" = "Выберите тип оплаты";
//"checkout.orderConsistence" = "Состав заказа";
//"checkout.orderForOther" = "Заказать другому";
//
//"checkout.name" = "Имя и фамилия";
//"checkout.phone" = "+7";
//"checkout.email" = "email";
//"checkout.city" = "Город";
//"checkout.street" = "Улица";
//"checkout.houseNumber" = "№ Дома";
//"checkout.flatNumber" = "№ Квартиры";
//"checkout.description" = "Примечание к заказу";
//
//"checkout.whorePrice" = "Общая сумма";
//"checkout.discount" = "Скидка";
//"checkout.delivery" = "Доставка";
//"checkout.pickup" = "Самовывоз";
//"checkout.finalPrice" = "Итого к оплате";
//
//"checkout.promocode" = "Промокод";
//"checkout.applyPurchase" = "Оформить заказ";

class OrderServiceViewController: UIViewController, NavigationBarStyled {
    
    @IBOutlet private var emailtextField: CustomTextFieldView!
    @IBOutlet private var phoneTextField: CustomTextFieldView!
    @IBOutlet private var nameTextField: CustomTextFieldView!
    @IBOutlet private var commentTextField: UITextView!
    
    @IBOutlet private var orderViewHeight: NSLayoutConstraint!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var genelPriceView: UIView!
    @IBOutlet private var payButton: UIButton!
    @IBOutlet private var promocodView: UIView!
    @IBOutlet private var paymentView: UIView!
    @IBOutlet private var clinicView: UIView!
    @IBOutlet private var timeView: UIView!
    @IBOutlet private var generalPriceView: UIView!
    @IBOutlet private var infoClinicView: UIView!
    @IBOutlet private var tableHeight: NSLayoutConstraint!
    @IBOutlet private var openFilialListButton: UIButton!
    @IBOutlet private var orderToAnotherPersonButton: UIButton!
    @IBOutlet private var orderStackView: UIStackView!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var dateAndTimeTextFieldFi: UITextField!
    @IBOutlet private var anotherPersonOrderView: UIView!
        
    private var countClick = 1
    private var textFieldView: CustomTextFieldView?
    
    var style: NavigationBarStyle = .normalWithoutSearch
    
    @IBAction func addPromocodAction(_ sender: Any) {
        model.addAlert()
    }
        
    @IBAction func openFilialListButton(_ sender: Any) {
        model.openFilialList()
    }
    @IBAction func orderToAnotherPersonButtonAction(_ sender: Any) {
        countClick += 1
        if countClick % 2 == 0 {
            print(countClick)
            self.createTextFieldView(countClick: countClick, placeholder: R.string.localize.checkoutName())
        } else {
            self.textFieldView?.removeFromSuperview()
            orderViewHeight.constant = 1
        }
    }
    
    @IBAction func payAction(_ sender: Any) {
        model.finishOrder()
    }
    var model: OrderServiceVControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        addDoneButtonOnKeyboard()
        configUI()
        commentTextField.delegate = self
        setupTableView()
        model.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitle()
    }
    
    private func configUI() {
        tableView.separatorStyle = .none
        clinicView.layer.cornerRadius = 6
        paymentView.layer.cornerRadius = 6
        infoClinicView.layer.cornerRadius = 6
        timeView.layer.cornerRadius = 6
        
        nameTextField.configure(placeholder: R.string.localize.checkoutName())
        phoneTextField.configure(placeholder: "+73809994824231")
        emailtextField.configure(placeholder: R.string.localize.checkoutEmail())
        configure(to: clinicView)
        configure(to: paymentView)
        configure(to: infoClinicView)
        configure(to: timeView)
        setupView()
    }
    @IBAction func openPickerView(_ sender: Any) {
        showDatePicker()
        
        
    }
    
    
    let datePicker: UIDatePicker = UIDatePicker()
    
    func showDatePicker(){
        if #available(iOS 13.4, *) {
            datePicker.backgroundColor = .white
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: R.string.localize.actionCancel(), style: .plain, target: self, action: #selector(cancelDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        dateAndTimeTextFieldFi.inputAccessoryView = toolbar
        dateAndTimeTextFieldFi.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm"
        let selectedDate: String = dateFormatter.string(from: datePicker.date)
        self.timeLabel.text = selectedDate
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func closeDataPicer(){
        view.endEditing(true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        self.timeLabel.text = selectedDate
    }
    
    private func configure(to view: UIView) {
        view.layer.cornerRadius = 6
    }
    
    private func createTextFieldView(countClick: Int, placeholder: String) -> UIView  {
        let textView = CustomTextFieldView()
        textView.backgroundColor = .white
        self.textFieldView = textView
        self.orderStackView.addArrangedSubview(textView)
        let spacing = (self.orderStackView.arrangedSubviews.count - 1) * 24
        self.orderViewHeight.constant = (48 * CGFloat(self.orderStackView.arrangedSubviews.count)) + CGFloat(spacing)
        textView.configure(placeholder: placeholder)
        
        return self.textFieldView!
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        commentTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        commentTextField.resignFirstResponder()
    }
    
    private func setupView() {
        commentTextField.layer.cornerRadius = 12
        commentTextField.layer.borderWidth = 1
        commentTextField.layer.borderColor = UIColor(red: 0.859, green: 0.882, blue: 0.922, alpha: 1).cgColor
        generalPriceView.layer.cornerRadius = 8
        promocodView.layer.cornerRadius = 16
        commentTextField.delegate = self
        
        payButton.layer.cornerRadius = 16
        self.orderToAnotherPersonButton.setTitle(R.string.localize.checkoutOrderForOther(), for: .normal)
    }
    
    private func setupTitle() {
        if let bar = self.navigationController?.navigationBar as? NavigationBar {
            bar.smallNavBarTitleLabel.text = R.string.localize.checkoutTitle()
        }
    }
}
extension OrderServiceViewController {
    private func setupTableView() {
        
    }
}

extension OrderServiceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: PaymantCell.self)
        let model = self.model.model[indexPath.row]
        cell.apply(model: model, selected: model.paymetText == self.model.selected?.paymetText)
        if cell.namePaymentLabel.text == self.model.model.last?.paymetText {
            cell.isUserInteractionEnabled = true
            cell.notEnableView.tintColor = UIColor.systemBlue
            cell.namePaymentLabel.textColor = .black
        }
        
        return  cell
    }
}

extension OrderServiceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        model.didSelectCell(at: indexPath)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        model.selected = nil
    }
}

extension OrderServiceViewController: OrderServiceViewModelModelOutput {
    
    func didLoad(models: [PaymentModel]) {
        tableHeight.constant = CGFloat(self.model.model.count) * model.cellHeight
    }
    
    func didFetchError(error: Error) {
        
    }
}
extension OrderServiceViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == R.string.localize.checkoutAddComment() {
            self.commentTextField.text = nil
            self.commentTextField.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.commentTextField.text = R.string.localize.checkoutAddComment()
            self.commentTextField.textColor = .lightGray
        }
    }
}
