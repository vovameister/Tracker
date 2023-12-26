//
//  BlueScreen.swift
//  Tracker
//
//  Created by Владимир Клевцов on 26.12.23..
//
import UIKit

final class BlueScreenViewController: UIViewController {
    var background = UIImageView()
    var button = UIButton()
    var label = UILabel()
    
    override func viewDidLoad() {
        view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.image = UIImage(named: "blueImage")
        
        background.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Отслеживайте только то, что хотите"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        background.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 432),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 160),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84)
        ])
    }
}
