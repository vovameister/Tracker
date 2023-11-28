//
//  HabitOrEventController.swift
//  Tracker
//
//  Created by Владимир Клевцов on 12.11.23..
//
//protocol HabitOrEventControllerDelegate: AnyObject {
//    func appendArray()
//}

import UIKit
final class HabitOrEventController: UIViewController {

    let trackerViewController = TrackersViewController.shared
    
    let titleLabel = UILabel()
    let textField = UITextField()
    let tableView = UITableView()
    let cancelButton = UIButton()
    let createButton = UIButton()
    let cellIdentifier = "CellIdentifier"
    let scheduleviewController = ScheduleViewController()
    
    var newAction = ""
    var newHabit: [DayOfWeek: Bool]?
    var newId: UUID?
    var newCategory = "mockcategorey"
    
    let font16 = UIFont.systemFont(ofSize: 16, weight: .medium)
    
    let tableText = [ "Категория",
                      "Расписание"]
    
    
    var setUpTableInt: Int?
    var tableViewHeight: CGFloat?
    
    
    init(title: String, setUpTableInt: Int, tableViewHeight: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.setUpTableInt = setUpTableInt
        self.tableViewHeight = tableViewHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(createButton)
        view.addSubview(cancelButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(named: "textBg")
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 16
        let leftIndentView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftIndentView
        textField.leftViewMode = .always
        textField.delegate = self
        
        titleLabel.font = font16
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.layer.cornerRadius = 16
        createButton.backgroundColor = UIColor(named: "trackerGray")
        createButton.setTitle("Создать", for: .normal)
        createButton.titleLabel?.font = font16
        createButton.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)
        createButton.isEnabled = false
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 16
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "trackerRed"), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor(named: "trackerRed")?.cgColor
        cancelButton.titleLabel?.font = font16
        cancelButton.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: tableViewHeight ?? 150),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            createButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func cancelButtonTap() {
        self.dismiss(animated: true)
        
    }
    @objc func saveButtonTap() {
        
        let newTracker = Tracker(id: UUID(), action: newAction, color: .blue, emoji: "", schedule: newHabit ?? eventMockShudle)
        
        let newCategory1 = TrackerCategory(title: newCategory, trackers: [newTracker])
        
        
        mockCategory1.append(newCategory1)
        trackerViewController.reloadData()
        
        self.dismiss(animated: true)
    }
    
}
extension HabitOrEventController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setUpTableInt ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = UIColor(named: "textBg")
        cell.textLabel?.text = tableText[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if setUpTableInt == 2 {
            return tableView.frame.height / 2.0 }
        else { return tableView.frame.height }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            scheduleviewController.delegate = self
            present(scheduleviewController, animated: true, completion: nil)
        } else if indexPath.row == 0 {
            present(CategoryViewController(), animated: true, completion: nil)
        } else {
            return
        }
    }
}

extension HabitOrEventController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let enteredText = textField.text {
            
            newAction = enteredText
        }
        if textField.text != nil {
            createButton.isEnabled = true
        }
        return true
    }
}

extension HabitOrEventController: ScheduleViewControllerDelegate {
    func didSelectDays(_ days: [DayOfWeek: Bool]) {
        newHabit = days
    }
}


