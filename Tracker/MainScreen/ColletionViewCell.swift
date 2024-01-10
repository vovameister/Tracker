//
//  ColletionViewCell.swift
//  Tracker
//
//  Created by Владимир Клевцов on 8.11.23..
//

import UIKit
protocol TrackerCellDelegate: AnyObject {
    func addOrDalete(id: UUID, at indexPath: IndexPath)
    
}

final class CollectionViewCell: UICollectionViewCell {
    let analytics = AnalyticsService()
    
    
    let colorLabel = UILabel()
    let emodjiLabel = UILabel()
    let daysLabel = UILabel()
    let button = UIButton()
    let messege = UILabel()
    let pinMark = UIImageView()
    
    weak var delegate: TrackerCellDelegate?
    
    var trackerId: UUID?
    var indexPath: IndexPath?
    var repeatedTimes = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorLabel)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.layer.cornerRadius = 16
        colorLabel.layer.masksToBounds = true
        colorLabel.backgroundColor = .red
        
        colorLabel.addSubview(emodjiLabel)
        emodjiLabel.translatesAutoresizingMaskIntoConstraints = false
        emodjiLabel.backgroundColor = UIColor(named: "Color30")
        emodjiLabel.layer.cornerRadius = 12
        emodjiLabel.layer.masksToBounds = true
        
        contentView.addSubview(daysLabel)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.text = "1 day"
        daysLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(trackerButtonTapped), for: .touchUpInside)
        
        colorLabel.addSubview(messege)
        messege.translatesAutoresizingMaskIntoConstraints = false
        messege.text = "wake Up"
        messege.textColor = .white
        messege.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        messege.textAlignment = .left
        
        pinMark.translatesAutoresizingMaskIntoConstraints = false
        pinMark.image = UIImage(named: "pin")
        colorLabel.addSubview(pinMark)
        
        NSLayoutConstraint.activate([
            colorLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            colorLabel.heightAnchor.constraint(equalToConstant: 90),
            
            emodjiLabel.topAnchor.constraint(equalTo: colorLabel.topAnchor, constant: 12),
            emodjiLabel.leadingAnchor.constraint(equalTo: colorLabel.leadingAnchor, constant: 12),
            emodjiLabel.heightAnchor.constraint(equalToConstant: 24),
            emodjiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            daysLabel.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.widthAnchor.constraint(equalToConstant: 101),
            
            button.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            button.heightAnchor.constraint(equalToConstant: 34),
            button.widthAnchor.constraint(equalToConstant: 34),
            
            messege.topAnchor.constraint(equalTo: colorLabel.topAnchor, constant: 44),
            messege.leadingAnchor.constraint(equalTo: colorLabel.leadingAnchor, constant: 12),
            messege.trailingAnchor.constraint(equalTo: colorLabel.trailingAnchor, constant: -12),
            messege.bottomAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 12),
            
            pinMark.topAnchor.constraint(equalTo: colorLabel.topAnchor, constant: 12),
            pinMark.trailingAnchor.constraint(equalTo: colorLabel.trailingAnchor, constant: -4),
            pinMark.heightAnchor.constraint(equalToConstant: 24),
            pinMark.widthAnchor.constraint(equalToConstant: 24)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func trackerButtonTapped() {
        analytics.report(event: "click", params: ["screen" : "main", "item" : "track"])
        print("tracked")
        
        guard let trackerId = trackerId,
              let indexPath = indexPath else { return }
        delegate?.addOrDalete(id: trackerId, at: indexPath)
    }
}
