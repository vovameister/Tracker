//
//  HabitOrEventController.swift
//  Tracker
//
//  Created by Владимир Клевцов on 12.11.23..
//

import UIKit
final class HabitOrEventController: UIViewController {
    var newHabit: [DayOfWeek: Bool]? {
        didSet {
            tableView.reloadData()
        }
    }
    var newId: UUID?
    var newCategory: String? {
        didSet {
            tableView.reloadData()
            buttonEnable()
        }
    }
    var emoji: String?
    var color: UIColor?
    
    
    let trackerViewController = TrackersViewController.shared
    let scheduleviewController = ScheduleViewController()
    var trackerCategory = TrackerCategoryStore.shared
    var viewModel: CategoryViewModel!
    
    let titleLabel = UILabel()
    let textField = UITextField()
    let tableView = UITableView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private let enterTrackerName = NSLocalizedString("enterTrackerName", comment: "")
    private let colorText = NSLocalizedString("color", comment: "")
    private let create = NSLocalizedString("create", comment: "")
    private let cancel = NSLocalizedString("cancel", comment: "")
    private let everyDay = NSLocalizedString("everyDay", comment: "")
    
    private let monday = NSLocalizedString("monday", comment: "")
    private let tuesday = NSLocalizedString("tuesday", comment: "")
    private let wednesday = NSLocalizedString("wednesday", comment: "")
    private let thursday = NSLocalizedString("thursday", comment: "")
    private let friday = NSLocalizedString("friday", comment: "")
    private let sat = NSLocalizedString("saturday", comment: "")
    private let sunday = NSLocalizedString("sunday", comment: "")
    
    let emojiView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    let colorView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(ColorViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    let cancelButton = UIButton()
    let createButton = UIButton()
    let cellIdentifier = "CellIdentifier"
    let cellIdentifier2 = "CellIdentifier2"
    let emojiLabel = UILabel()
    let colorLabel = UILabel()
    let emojiCollectionViewDelegate = EmojiCollectionViewDelegate()
    let colorCollectionViewDelegate = ColorViewDelegate()
    let font16 = UIFont.systemFont(ofSize: 16, weight: .medium)
    private lazy var viewControllers: [UIViewController] = {
        return [
            CategoryViewController(),
            ScheduleViewController()
        ]
    }()
    let tableText = [  NSLocalizedString("category", comment: ""),
                       NSLocalizedString("schedule", comment: "")]
    
    
    var setUpTableInt: Int?
    var tableViewHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CategoryViewModel.shared
        viewModel?.$selectedCategory.bind { [weak self] _ in
            guard let self = self else { return }
            self.newCategory = viewModel.selectedCategory ?? ""
        }
        
        
        
        view.addSubview(scrollView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.backgroundColor = .white
        contentView.addSubview(tableView)
        contentView.addSubview(createButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(emojiView)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(colorView)
        contentView.addSubview(colorLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(named: "textBg")
        textField.placeholder = enterTrackerName
        textField.layer.cornerRadius = 16
        let leftIndentView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftIndentView
        textField.leftViewMode = .always
        textField.delegate = self
        
        titleLabel.font = font16
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HabitOrEventCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.layer.cornerRadius = 16
        createButton.backgroundColor = UIColor(named: "trackerGray")
        createButton.setTitle(create, for: .normal)
        createButton.titleLabel?.font = font16
        createButton.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)
        createButton.isEnabled = false
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 16
        cancelButton.setTitle(cancel, for: .normal)
        cancelButton.setTitleColor(UIColor(named: "trackerRed"), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor(named: "trackerRed")?.cgColor
        cancelButton.titleLabel?.font = font16
        cancelButton.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
        
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.delegate = emojiCollectionViewDelegate
        emojiView.dataSource = emojiCollectionViewDelegate
        emojiCollectionViewDelegate.parentViewController = self
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.delegate = colorCollectionViewDelegate
        colorView.dataSource = colorCollectionViewDelegate
        colorCollectionViewDelegate.parentViewController = self
        
        emojiLabel.text = "Emoji"
        emojiLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false 
        colorLabel.text = colorText
        colorLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 73),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: tableViewHeight ?? 150),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34),
            createButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            
            emojiView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 81),
            emojiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            emojiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            emojiView.heightAnchor.constraint(equalToConstant: 170),
            
            emojiLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            emojiLabel.heightAnchor.constraint(equalToConstant: 18),
            emojiLabel.widthAnchor.constraint(equalToConstant: 52),
            
            colorView.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 96),
            colorView.leadingAnchor.constraint(equalTo: emojiView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: emojiView.trailingAnchor),
            colorView.heightAnchor.constraint(equalTo: emojiView.heightAnchor),
            
            colorLabel.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 47),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            colorLabel.heightAnchor.constraint(equalToConstant: 18),
            colorLabel.widthAnchor.constraint(equalToConstant: 52),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1000)
        ])
    }
    init(title: String, setUpTableInt: Int, tableViewHeight: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.setUpTableInt = setUpTableInt
        self.tableViewHeight = tableViewHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @objc func cancelButtonTap() {
        self.dismiss(animated: true)
    }
    @objc func saveButtonTap() {
        let newTracker = Tracker(id: UUID(), action: textField.text ?? "", color: color ?? .blue, emoji: emoji ?? "", schedule: newHabit ?? eventMockShudle)
        
        let newCategory1 = TrackerCategory(title: newCategory ?? "", trackers: [newTracker])
        try? trackerCategory.addNewTrackerCategory(newCategory1)
        
        viewModel.nilInSelected()
        self.dismiss(animated: true)
        if let presentingViewController = presentingViewController {
            presentingViewController.dismiss(animated: true)
        }
    }
    func extractAbbreviations(schedule: [DayOfWeek: Bool]) -> String {
        if schedule.values.allSatisfy({ $0 }) {
            return everyDay
        } else {
            let selectedDays = schedule.filter { $0.value }.sorted { $0.key.intValue < $1.key.intValue }.map { abbreviationForDay($0.key) }
            return selectedDays.joined(separator: ", ")
        }
    }
    func abbreviationForDay(_ day: DayOfWeek) -> String {
        switch day {
        case .monday: return monday
        case .tuesday: return tuesday
        case .wednesday: return wednesday
        case .thursday: return thursday
        case .friday: return friday
        case .saturday: return sat
        case .sunday: return sunday
        }
    }
    func buttonEnable() {
        if textField.text != "" && newCategory != nil {
            createButton.isEnabled = true
            createButton.backgroundColor = .black
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = UIColor(named: "trackerGray")
        }
    }
    
}
extension HabitOrEventController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setUpTableInt ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HabitOrEventCell()
        cell.backgroundColor = UIColor(named: "textBg")
        cell.titleLabel.text = tableText[indexPath.row]
        if indexPath.row == 0 {
            cell.subtitleLabel.text = newCategory
        } else {
            cell.subtitleLabel.text = extractAbbreviations(schedule: newHabit ?? eventMockShudle)
        }
        cell.accessoryType = .disclosureIndicator
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if setUpTableInt == 2 {
            return tableView.frame.height / 2.0 }
        else { return tableView.frame.height }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            scheduleviewController.delegate = self
            present(scheduleviewController, animated: true, completion: nil)
        } else if indexPath.row == 0 {
            present(CategoryViewController(), animated: true, completion: nil)
        } else {
            return
        }
    }
}

extension HabitOrEventController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        buttonEnable()
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        buttonEnable()
    }
}
extension HabitOrEventController: ScheduleViewControllerDelegate {
    func didSelectDays(_ days: [DayOfWeek: Bool]) {
        newHabit = days
    }
}

