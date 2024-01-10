//
//  Category.swift
//  Tracker
//
//  Created by Владимир Клевцов on 13.11.23..
//

import UIKit

final class CategoryViewController: UIViewController {
    private let colors = Colors.shared
    
    private let titleLabel = UILabel()
    private let addButton = UIButton()
    private let imageStar = UIImageView()
    private let textLabel = UILabel()
    private let tableView = UITableView()
    private let cellIdentifier = "CellIdentifier"
    private var viewModel: CategoryViewModel!
    
    
    private let habitAndEvents = NSLocalizedString("habitAndEvents", comment: "")
    private let addCategory = NSLocalizedString("addCategory", comment: "")
    private let category = NSLocalizedString("category", comment: "")
    private let edit = NSLocalizedString("edit", comment: "Edit")
    private let deleteAction = NSLocalizedString("delete", comment: "Delete")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        
        viewModel = CategoryViewModel.shared
        viewModel?.$category.bind { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
            isHiden()
        }
        isHiden()
        setupConstraints()
    }
    
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = UIColor(named: "backgroung")
        
        view.addSubview(tableView)
        
        
        view.backgroundColor = UIColor(named: "background")
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.text = category
        view.addSubview(titleLabel)
        
        
        view.addSubview(imageStar)
        imageStar.image = UIImage(named: "Star")
        imageStar.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textLabel.text = habitAndEvents
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = 16
        addButton.backgroundColor = colors.bgColor
        addButton.setTitle(addCategory, for: .normal)
        addButton.setTitleColor(UIColor(named: "background"), for: .normal)
        addButton.addTarget(self, action: #selector(readyButtonTap), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            imageStar.topAnchor.constraint(equalTo: view.topAnchor, constant: 346),
            imageStar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageStar.widthAnchor.constraint(equalToConstant: 80),
            imageStar.heightAnchor.constraint(equalToConstant: 80),
            
            textLabel.topAnchor.constraint(equalTo: imageStar.bottomAnchor, constant: 8),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 36),
            textLabel.widthAnchor.constraint(equalToConstant: 343),
            
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    @objc func readyButtonTap() {
        present(NewCategoryViewController(isEdit: false), animated: true, completion: nil)
    }
    func editCategory(indexPath: IndexPath) {
        present(NewCategoryViewController(isEdit: true, category: viewModel.category[indexPath.row]), animated: true, completion: nil)
    }
}
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.category.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = UIColor(named: "textBg")
        cell.textLabel?.text = viewModel.category[indexPath.row]
        
        let lastRow = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.row == lastRow {
            
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            
            cell.layer.cornerRadius = 0
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let preSelected = viewModel.preSelected,
           let preSelectedCell = tableView.cellForRow(at: preSelected) {
            preSelectedCell.accessoryType = .checkmark
        }
        dismiss(animated: true)
        viewModel.setIndexPath(indexPath: indexPath)
        viewModel.selectCategory(indexPath: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let preSelected = viewModel.preSelected,
           indexPath == preSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {_ in
            let editAction =
            UIAction(title: self.edit,
                     image: nil) { action in
                self.editCategory(indexPath: indexPath)
            }
            let deleteAction =
            UIAction(title: self.deleteAction,
                     image: nil){ action in
                self.viewModel.deleteCategory(indexPath: indexPath)
            }
            let deleteActionAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red
            ]
            let deleteActionTitle = NSAttributedString(string: self.deleteAction, attributes: deleteActionAttributes)
            deleteAction.setValue(deleteActionTitle, forKey: "attributedTitle")
            return UIMenu(title: "", children: [editAction, deleteAction])
        })
        
    }
    func isHiden() {
        if viewModel.category.count > 0 {
            imageStar.isHidden = true
            textLabel.isHidden = true
        }
    }
}

