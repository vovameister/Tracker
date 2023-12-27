//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Владимир Клевцов on 31.10.23..
//

import UIKit

final class TrackersViewController: UIViewController {
   
    
    static let shared = TrackersViewController()
    let trackerCategoryStore = TrackerCategoryStore()
    let trackerCD = TrackerCoreDataStore.shared
    let trackerRecordCD = RecordStore()
    
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []

 
    let button = UIButton()
    let textViewTracker =  UILabel()
    let imageStar = UIImageView()
    let questionText = UILabel()
    let searchBar = UISearchBar()
    let datePicker = UIDatePicker()
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
        setUpCollectionView()
        reloadVisibleCategories()
        reloadData()
        
        
        trackerCategoryStore.delegate = self
        trackerCD.delegate = self
        
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @objc func showCreateViewController() {
        
        let viewController = CreateTrackerViewController()
        
        present(viewController, animated: true, completion: nil)
    }
    @objc func handleTap() {
            searchBar.resignFirstResponder()
        }
    func setUpViewDidLoad() {
        view.backgroundColor = .white
        
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showCreateViewController), for: .touchUpInside)
        
        textViewTracker.font = UIFont.boldSystemFont(ofSize: 34)
        textViewTracker.text = "Трекеры"
        textViewTracker.translatesAutoresizingMaskIntoConstraints = false
        
        imageStar.image = UIImage(named: "Star")
        imageStar.translatesAutoresizingMaskIntoConstraints = false
        
        questionText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        questionText.text = "Что будем отслеживать?"
        questionText.textAlignment = .center
        questionText.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.placeholder = "Поиск"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        
        
        view.addSubview(imageStar)
        view.addSubview(button)
        view.addSubview(textViewTracker)
        view.addSubview(questionText)
        view.addSubview(searchBar)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            button.widthAnchor.constraint(equalToConstant: 42),
            button.heightAnchor.constraint(equalToConstant: 42),
            
            textViewTracker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textViewTracker.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 1),
            textViewTracker.heightAnchor.constraint(equalToConstant: 41),
            textViewTracker.widthAnchor.constraint(equalToConstant: 254),
            
            imageStar.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            imageStar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageStar.widthAnchor.constraint(equalToConstant: 80),
            imageStar.heightAnchor.constraint(equalToConstant: 80),
            
            questionText.topAnchor.constraint(equalTo: imageStar.bottomAnchor, constant: 8),
            questionText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionText.heightAnchor.constraint(equalToConstant: 18),
            questionText.widthAnchor.constraint(equalToConstant: 343),
            
            searchBar.topAnchor.constraint(equalTo: textViewTracker.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.widthAnchor.constraint(equalToConstant: 92)
        ])
        
    }
    func setUpCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 34),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @objc private func dateChanged() {
        reloadVisibleCategories()
    }
    
    func reloadData() {
        categories = trackerCategoryStore.trackerCategories
        dateChanged()
    }

    internal func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: datePicker.date)
        let filterText = (searchBar.text ?? "").lowercased()

        visibleCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.action.lowercased().contains(filterText)

                let dateFormatter = DateFormatter()
                let dayOfWeekName = dateFormatter.weekdaySymbols[(filterWeekday - 1 + 7) % 7].lowercased()

                let scheduleCondition = tracker.schedule.contains { (day, isSelected) in
                    day.name.lowercased() == dayOfWeekName && isSelected
                }

                return textCondition && scheduleCondition
            }

            if !filteredTrackers.isEmpty {
                return TrackerCategory(title: category.title, trackers: filteredTrackers)
            }

            return nil
        }
        collectionView.reloadData()
        reloadPlaceholder()
        changeQuestionLabel()
    }



    private func reloadPlaceholder() {
        collectionView.isHidden = categories.isEmpty || visibleCategories.isEmpty
    }

    func changeQuestionLabel() {
        if !categories.isEmpty && visibleCategories.isEmpty {
            questionText.text = "Ничего не найдено"
            imageStar.image = UIImage(named: "nothingFind")
        } else  {
            questionText.text = "Что будем отслеживать?"
            imageStar.image = UIImage(named: "Star")
        }
    }
}


