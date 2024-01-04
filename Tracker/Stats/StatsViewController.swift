//
//  StatsViewController.swift
//  Tracker
//
//  Created by Владимир Клевцов on 31.10.23..
//

import UIKit

final class StatsViewController: UIViewController {
    let titleView = UITextView()
    let tableView = UITableView()
    
    let statistics = NSLocalizedString("statistics", comment: "")
    let bestPeriod = NSLocalizedString("bestPeriod", comment: "")
    let perfectDays = NSLocalizedString("perfectDays", comment: "")
    let trackersCompleted = NSLocalizedString("trackersCompleted", comment: "")
    let average = NSLocalizedString("average", comment: "")

    override func viewDidLoad() {
        view.backgroundColor = .white
        setUpView()
        
    }
    func setUpView() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = statistics
        titleView.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        view.addSubview(titleView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -105),
            titleView.heightAnchor.constraint(equalToConstant: 41),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutYAxisAnchor>#>)
            ])
    }
    
}
extension StatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
