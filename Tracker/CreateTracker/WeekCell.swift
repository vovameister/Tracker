//
//  WeekCell.swift
//  Tracker
//
//  Created by Владимир Клевцов on 13.11.23..
//

// CustomTableViewCell.swift

import UIKit

class DayTableViewCell: UITableViewCell {
    
    let dayLabel = UILabel()
    let daySwitch = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(daySwitch)
        
        daySwitch.tintColor = UIColor(named: "switch")
        
        daySwitch.onTintColor = UIColor(named: "blueColorTracker")
        
       
        
        self.backgroundColor = UIColor(named: "textBg")
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
