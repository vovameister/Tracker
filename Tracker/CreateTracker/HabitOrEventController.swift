//
//  HabitOrEventController.swift
//  Tracker
//
//  Created by Владимир Клевцов on 12.11.23..
//

import UIKit
final class HabitOrEventController: UIViewController {
    let titleLabel = UILabel()
    let textField = UITextField()
    let tableView = UITableView()
    let cancelButton = UIButton()
    let createButton = UIButton()
    let cellIdentifier = "CellIdentifier"
    
    let font16 = UIFont.systemFont(ofSize: 16, weight: .medium)
    private lazy var viewControllers: [UIViewController] = {
        return [
            CategoryViewController(),
            ScheduleViewController()
        ]
    }()
    let tableText = [ "Категория",
                      "Расписание"]
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
            tableView.heightAnchor.constraint(equalToConstant: 150),
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
}
extension HabitOrEventController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = UIColor(named: "textBg")
        cell.textLabel?.text = tableText[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.frame.height / 2.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row < viewControllers.count else {
            return
        }
        
        let selectedViewController = viewControllers[indexPath.row]
        present(selectedViewController, animated: true, completion: nil)
    }
}



