//
//  Filters.swift
//  Tracker
//
//  Created by Владимир Клевцов on 4.1.24..
//

import UIKit

final class FiltersViewController: UIViewController {
    let TrackerViewController = TrackersViewController.shared
    
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let filters = NSLocalizedString("filters", comment: "")
    
    private let notCompleted = NSLocalizedString("notCompleted", comment: "Not completed")
    private let allTrackers = NSLocalizedString("allTrackers", comment: "All trackers")
    private let completed = NSLocalizedString("completed", comment: "Completed")
    private let trackersForToday = NSLocalizedString("trackersForToday", comment: "Trackers for today")
    
    private let cellIdentifier = "CellIdentifier"
    
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "background")
        setUpView()
    }
    func setUpView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = filters
        view.addSubview(titleLabel)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 300),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ])
    }
}
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
       let filtersText = [allTrackers, trackersForToday, completed, notCompleted]
        cell.backgroundColor = UIColor(named: "textBg")
        cell.textLabel?.text = filtersText[indexPath.row]
       
      
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let preSelected = TrackerViewController.selectedFilter,
           let preSelectedCell = tableView.cellForRow(at: preSelected) {
            preSelectedCell.accessoryType = .checkmark
        }
        dismiss(animated: true)
        TrackerViewController.selectedFilter = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let preSelected = TrackerViewController.selectedFilter,
           indexPath == preSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}
