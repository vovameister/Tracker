//
//  StatsViewController.swift
//  Tracker
//
//  Created by Владимир Клевцов on 31.10.23..
//
import UIKit

final class StatsViewController: UIViewController {
    static let shared = StatsViewController()
    
    private let titleView = UITextView()
    private let bestPeriodView = UIImageView()
    private let scoreText = UITextView()
    private let recordTitle = UITextView()
    
    let recordStore = RecordStore()
    private let statistics = NSLocalizedString("statistics", comment: "")
    private let trackersCompleted = NSLocalizedString("trackersCompleted", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        setUpView()
    }
    
    func setUpView() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = statistics
        titleView.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleView.backgroundColor = UIColor(named: "background")
        view.addSubview(titleView)
        
        bestPeriodView.translatesAutoresizingMaskIntoConstraints = false
        bestPeriodView.layer.cornerRadius = 16
        bestPeriodView.image = UIImage(named: "statGradient")
        view.addSubview(bestPeriodView)
        
        recordTitle.translatesAutoresizingMaskIntoConstraints = false
        recordTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        recordTitle.text = trackersCompleted
        recordTitle.backgroundColor = UIColor(named: "background")
        bestPeriodView.addSubview(recordTitle)
        
        scoreText.translatesAutoresizingMaskIntoConstraints = false
        scoreText.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        updateScoreText()
        scoreText.backgroundColor = UIColor(named: "background")
        bestPeriodView.addSubview(scoreText)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -105),
            titleView.heightAnchor.constraint(equalToConstant: 41),
            
            bestPeriodView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bestPeriodView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 77),
            bestPeriodView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bestPeriodView.heightAnchor.constraint(equalToConstant: 90),
            
            recordTitle.topAnchor.constraint(equalTo: bestPeriodView.topAnchor, constant: 48),
            recordTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            recordTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            recordTitle.bottomAnchor.constraint(equalTo: bestPeriodView.bottomAnchor, constant: -12),
            
            scoreText.topAnchor.constraint(equalTo: bestPeriodView.topAnchor, constant: 5),
            scoreText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            scoreText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            scoreText.bottomAnchor.constraint(equalTo: bestPeriodView.bottomAnchor, constant: -44)
        ])
        
    }
    func updateScoreText() {
        scoreText.text = String(recordStore.sumOfAllRecords())
        print(String(recordStore.sumOfAllRecords()))
    }
}


