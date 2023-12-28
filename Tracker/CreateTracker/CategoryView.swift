//
//  Category.swift
//  Tracker
//
//  Created by Владимир Клевцов on 13.11.23..
//

import UIKit

final class CategoryViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let readyButton = UIButton()
    private let imageStar = UIImageView()
    private let textLabel = UILabel()
    private let tableView = UITableView()
    private let cellIdentifier = "CellIdentifier"
    private var viewModel: CategoryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        
        viewModel = CategoryViewModel.shared
        viewModel?.$category.bind { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.setupConstraints()
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
        
        view.addSubview(tableView)
        
        
        view.backgroundColor = .white
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.text = "Категория"
        view.addSubview(titleLabel)
        
        
        view.addSubview(imageStar)
        imageStar.image = UIImage(named: "Star")
        imageStar.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textLabel.text = "Привычки и события можно \nобъединить по смыслу"
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.layer.cornerRadius = 16
        readyButton.backgroundColor = .black
        readyButton.setTitle("Добавить категорию", for: .normal)
        readyButton.titleLabel?.textColor = .white
        readyButton.addTarget(self, action: #selector(readyButtonTap), for: .touchUpInside)
        view.addSubview(readyButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -115),
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
        
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    @objc func readyButtonTap() {
        present(NewCategoryViewController(), animated: true, completion: nil)
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
    func isHiden() {
        if viewModel.category.count > 0 {
            imageStar.isHidden = true
            textLabel.isHidden = true
        }
    }
}

