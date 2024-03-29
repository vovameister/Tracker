//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Владимир Клевцов on 12.11.23..
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectDays(_ days: [DayOfWeek: Bool])
}


final class ScheduleViewController: UIViewController {
    private let colors = Colors.shared
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let cellIdentifier = "DayCell"
    private let readyButton = UIButton()
    
    private let mondayFull = NSLocalizedString("mondayFull", comment: "")
    private let tuesdayFull = NSLocalizedString("tuesdayFull", comment: "")
    private let wednesdayFull = NSLocalizedString("wednesdayFull", comment: "")
    private let thursdayFull = NSLocalizedString("thursdayFull", comment: "")
    private let fridayFull = NSLocalizedString("fridayFull", comment: "")
    private let saturdayFull = NSLocalizedString("saturdayFull", comment: "")
    private let sundayFull = NSLocalizedString("sundayFull", comment: "")
    
    private var selectedDays: [DayOfWeek: Bool] = [
        .monday: false,
        .tuesday: false,
        .wednesday: false,
        .thursday: false,
        .friday: false,
        .saturday: false,
        .sunday: false
    ]
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        let dayIndex = sender.tag
        if let dayOfWeek = DayOfWeek(intValue: dayIndex) {
            selectedDays[dayOfWeek] = sender.isOn
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    private func setupViews() {
        view.backgroundColor = UIColor(named: "background")
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.text = "Расписание"
        view.addSubview(titleLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DayTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.layer.cornerRadius = 16
        view.addSubview(tableView)
        
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.layer.cornerRadius = 16
        readyButton.backgroundColor = colors.bgColor
        readyButton.setTitle("Готово", for: .normal)
        readyButton.setTitleColor(UIColor(named: "background"), for: .normal)
        readyButton.addTarget(self, action: #selector(readyButtonTap), for: .touchUpInside)
        view.addSubview(readyButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    @objc func readyButtonTap() {
        print(selectedDays)
        delegate?.didSelectDays(selectedDays)
        
        self.dismiss(animated: true)
    }
}
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.frame.height / 7.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DayTableViewCell else {
            return UITableViewCell()
        }
        
        
        let daysOfWeek = [mondayFull, tuesdayFull, wednesdayFull, tuesdayFull, fridayFull, saturdayFull, sundayFull]
        cell.dayLabel.text = daysOfWeek[indexPath.row]
        cell.selectionStyle = .none
        cell.daySwitch.tag = indexPath.row
        cell.daySwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return cell
    }
}

