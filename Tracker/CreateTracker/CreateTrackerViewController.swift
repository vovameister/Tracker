//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Владимир Клевцов on 12.11.23..
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    let habit = UIButton()
    let irregularEvent = UIButton()
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(habit)
        view.addSubview(irregularEvent)
        view.addSubview(titleLabel)
        view.backgroundColor = .white
        
        
        habit.translatesAutoresizingMaskIntoConstraints = false
        habit.setTitle("Привычка", for: .normal)
        habit.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        habit.setTitleColor(.white, for: .normal)
        habit.backgroundColor = .black
        habit.layer.cornerRadius = 16
        habit.addTarget(self, action: #selector(habitTap), for: .touchUpInside)
        
        irregularEvent.translatesAutoresizingMaskIntoConstraints = false
        irregularEvent.setTitle("Нерегулярное событие", for: .normal)
        irregularEvent.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        irregularEvent.setTitleColor(.white, for: .normal)
        irregularEvent.backgroundColor = .black
        irregularEvent.layer.cornerRadius = 16
        irregularEvent.addTarget(self, action: #selector(eventTap), for: .touchUpInside)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Создание трекера"
        
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
        let viewController = HabitOrEventController()
        
        present(viewController, animated: true, completion: nil)
        viewController.titleLabel.text = "Новая привычка"
    }
    @objc func eventTap() {
        let viewController = HabitOrEventController()
        
        present(viewController, animated: true, completion: nil)
        viewController.titleLabel.text = "Новое нерегулярное событие"
    }
}
