//
//  NewCategory.swift
//  Tracker
//
//  Created by Владимир Клевцов on 26.12.23..
//

import UIKit

final class NewCategoryViewController: UIViewController {
    private let categoryViewModel = CategoryViewModel.shared
    
    private let titleLabel = UILabel()
    private let readyButton = UIButton()
    private let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    private func setupViews() {
        view.backgroundColor = .white
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.text = "Новая категория"
        view.addSubview(titleLabel)
        
        
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.layer.cornerRadius = 16
        readyButton.backgroundColor = UIColor(named: "trackerGray")
        readyButton.setTitle("Готово", for: .normal)
        readyButton.titleLabel?.textColor = .white
        readyButton.addTarget(self, action: #selector(readyButtonTap), for: .touchUpInside)
        view.addSubview(readyButton)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(named: "textBg")
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 16
        let leftIndentView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftIndentView
        textField.leftViewMode = .always
        textField.delegate = self
        view.addSubview(textField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    @objc func readyButtonTap() {
        if let text = textField.text {
            categoryViewModel.appendCategory(category: text)
        }
        self.dismiss(animated: true)
    }
}
extension NewCategoryViewController: UITextFieldDelegate {
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
    func buttonEnable() {
        if textField.text != "" {
            readyButton.isEnabled = true
            readyButton.backgroundColor = .black
        } else {
            readyButton.isEnabled = false
            readyButton.backgroundColor = UIColor(named: "trackerGray")
        }
    }
}
