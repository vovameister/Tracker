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
    let statController = StatsViewController.shared
    let trackerRecordCD = RecordStore()
    let trackerPinStore = TrackerPinsStore()
    let trackerStore = TrackerCoreDataStore()
    let analyticsService = AnalyticsService()
    
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    var selectedFilter: IndexPath? = nil {
        didSet {
            reloadVisibleCategories()
            if selectedFilter?.row == 1 {
                datePicker.date = Date()
            }
        }
    }
    
    private let button = UIButton()
    private let textViewTracker =  UILabel()
    private let imageStar = UIImageView()
    private let questionText = UILabel()
    private let searchBar = UISearchBar()
    let datePicker = UIDatePicker()
    private let filtersButton = UIButton()
    
    private let startTrackers = NSLocalizedString("trackers", comment: "")
    private let whatWeWill = NSLocalizedString("whatWeWill", comment: "")
    private let search = NSLocalizedString("search", comment: "")
    private let nothingFound = NSLocalizedString("nothingFound", comment: "")
    private let everyDay = NSLocalizedString("everyDay", comment: "")
    private let filters = NSLocalizedString("filters", comment: "")
    internal let unpin = NSLocalizedString("unpin", comment: "Unpin")
    internal let edit = NSLocalizedString("edit", comment: "Edit")
    internal let deleteAction = NSLocalizedString("delete", comment: "Delete")
    internal let pin = NSLocalizedString("pin", comment: "")
    internal let habitEdit = NSLocalizedString("habitEditing", comment: "")
    internal let pinned = NSLocalizedString("pinned", comment: "")
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        analyticsService.report(event: "open", params: ["screen" : "main"])
        
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
        analyticsService.report(event: "click", params: ["screen" : "main", "item" : "add_tracker"])
        let viewController = CreateTrackerViewController()
        
        present(viewController, animated: true, completion: nil)
    }
    @objc func showFilterController() {
        analyticsService.report(event: "click", params: ["sceen" : "main", "item" : "filter"])
        
        let viewController = FiltersViewController()
        
        present(viewController, animated: true, completion: nil)
    }
    @objc func handleTap() {
        searchBar.resignFirstResponder()
    }
    
    func setUpViewDidLoad() {
        view.backgroundColor = UIColor(named: "background")
        
        
        textViewTracker.font = UIFont.boldSystemFont(ofSize: 34)
        textViewTracker.text = startTrackers
        textViewTracker.translatesAutoresizingMaskIntoConstraints = false
        
        imageStar.image = UIImage(named: "Star")
        imageStar.translatesAutoresizingMaskIntoConstraints = false
        
        questionText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        questionText.text = whatWeWill
        questionText.textAlignment = .center
        questionText.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.placeholder = search
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        filtersButton.setTitle(filters, for: .normal)
        filtersButton.backgroundColor = UIColor(named: "blueColorTracker")
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        filtersButton.layer.cornerRadius = 16
        filtersButton.addTarget(self, action: #selector(showFilterController), for: .touchUpInside)
        
        
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
            datePicker.widthAnchor.constraint(equalToConstant: 102)
        ])
        
    }
    func setUpCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "background")
        
        
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showCreateViewController), for: .touchUpInside)
        view.addSubview(collectionView)
        view.addSubview(filtersButton)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 34),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            filtersButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            filtersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 131),
            filtersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),
            filtersButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @objc private func dateChanged() {
        reloadVisibleCategories()
    }
    
    func reloadData() {
        let allCategories = trackerCategoryStore.trackerCategories
        
        let pins = trackerPinStore.fetchAllPins()
        
        let pinnedTrackers = pins.compactMap { pin in
            return allCategories.flatMap { category in
                return category.trackers.filter { tracker in
                    return tracker.id == pin
                }
            }
        }
        let pinnedCategory = TrackerCategory(title: pinned, trackers: pinnedTrackers.flatMap { $0 })

        let categoriesWithoutPinnedTrackers = filterPinnedTrackers(from: allCategories, pinnedTrackers:  pinnedTrackers.flatMap { $0 })

        let updatedCategories: [TrackerCategory] = [pinnedCategory] + categoriesWithoutPinnedTrackers

        categories = updatedCategories
        dateChanged()
    }


    func filterPinnedTrackers(from categoriesWithoutPinnedTrackers: [TrackerCategory], pinnedTrackers: [Tracker]) -> [TrackerCategory] {
        let filteredCategories = categoriesWithoutPinnedTrackers.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                return !pinnedTrackers.contains(where: { $0.id == tracker.id })
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }

        return filteredCategories
    }



    internal func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: datePicker.date)
        let filterText = (searchBar.text ?? "").lowercased()

        visibleCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.action.lowercased().contains(filterText)

                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US")
                let dayOfWeekName = dateFormatter.weekdaySymbols[(filterWeekday - 1 + 7) % 7].lowercased()

                let scheduleCondition = tracker.schedule.contains { (day, isSelected) in
                    day.name.lowercased() == dayOfWeekName && isSelected
                }

                var hasTrackerCondition = true
                if let filter = selectedFilter {
                    switch filter.row {
                    case 2:
                        hasTrackerCondition = trackerRecordCD.hasTracker1(for: tracker, on: datePicker.date)
                    case 3:
                        hasTrackerCondition = !trackerRecordCD.hasTracker1(for: tracker, on: datePicker.date)
                    default:
                        break
                    }
                }

                return textCondition && scheduleCondition && hasTrackerCondition
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
            questionText.text = nothingFound
            imageStar.image = UIImage(named: "nothingFind")
        } else  {
            questionText.text = whatWeWill
            imageStar.image = UIImage(named: "Star")
        }
    }
    func showDeleteActionSheet(uuid: UUID) {
           let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete?", preferredStyle: .actionSheet)

           let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
           
               self.deleteItem(uuid: uuid)
           }

           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

           alertController.addAction(deleteAction)
           alertController.addAction(cancelAction)

           present(alertController, animated: true, completion: nil)
       }

    func deleteItem(uuid: UUID) {
        trackerStore.deleteTracker(id: uuid)
        trackerPinStore.deleteItems(id: uuid)
        trackerRecordCD.deleteItems(id: uuid)
        statController.updateScoreText()
        reloadData()
       }
}


