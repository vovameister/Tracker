//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Владимир Клевцов on 12.11.23..
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    let analytics = AnalyticsService()
    
    let habit = UIButton()
    let irregularEvent = UIButton()
    let titleLabel = UILabel()
    private let colors = Colors.shared
    
    private let habitText = NSLocalizedString("habit", comment: "")
    private let irregularEventText = NSLocalizedString("irregularEvent", comment: "")
    private let createTracker = NSLocalizedString("createTracker", comment: "")
    private let newIrregularEvent = NSLocalizedString("newIrregularEvent", comment: "")
    private let newHabit = NSLocalizedString("newHabit", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        analytics.report(event: "open", params: ["sceen" : "create_tracker"])
        view.addSubview(habit)
        view.addSubview(irregularEvent)
        view.addSubview(titleLabel)
        view.backgroundColor = UIColor(named: "background")
        
        habit.translatesAutoresizingMaskIntoConstraints = false
        habit.setTitle(habitText, for: .normal)
        habit.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        habit.setTitleColor(UIColor(named: "background"), for: .normal)
        habit.backgroundColor = colors.bgColor
        habit.layer.cornerRadius = 16
        habit.addTarget(self, action: #selector(habitTap), for: .touchUpInside)
        
        irregularEvent.translatesAutoresizingMaskIntoConstraints = false
        irregularEvent.setTitle(irregularEventText, for: .normal)
        irregularEvent.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        irregularEvent.setTitleColor(UIColor(named: "background"), for: .normal)
        irregularEvent.backgroundColor =  colors.bgColor
        irregularEvent.layer.cornerRadius = 16
        irregularEvent.addTarget(self, action: #selector(eventTap), for: .touchUpInside)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = createTracker
        
        NSLayoutConstraint.activate([
            habit.topAnchor.constraint(equalTo: view.topAnchor, constant: 330),
            habit.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habit.heightAnchor.constraint(equalToConstant: 60),
            
            irregularEvent.topAnchor.constraint(equalTo: habit.bottomAnchor, constant: 16),
            irregularEvent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEvent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            irregularEvent.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    @objc func habitTap() {
        let viewController = HabitOrEventController(title: newHabit, setUpTableInt: 2, tableViewHeight: 150, isEdit: false)
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func eventTap() {
        let viewController = HabitOrEventController(title: newIrregularEvent, setUpTableInt: 1, tableViewHeight: 75, isEdit: false)
        present(viewController, animated: true, completion: nil)
    }
    
}
