//
//  ColorViewDelegate.swift
//  Tracker
//
//  Created by Владимир Клевцов on 20.11.23..
//

import UIKit

final class ColorViewDelegate: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    weak var parentViewController: HabitOrEventController?
    var selectedColor: UIColor?
    var selectedIndexPath: IndexPath?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        18
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ColorViewCell else {
            return UICollectionViewCell()
        }
        cell.viewColor.backgroundColor = UIColor(named: "\(indexPath.row + 1)")
        cell.layer.cornerRadius = 8
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        6.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (((parentViewController!.scrollView.bounds.width - 38) - 52 * 6) / 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = UIColor(named: "\(indexPath.item + 1)")
        
        if let prevIndexPath = selectedIndexPath {
            let prevCell = collectionView.cellForItem(at: prevIndexPath)
            prevCell?.layer.borderWidth = 0.0
        }
     
        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.layer.borderColor = UIColor(named: "\(indexPath.item + 1)")?.withAlphaComponent(0.3).cgColor
        selectedCell?.layer.borderWidth = 3.0
        
        selectedIndexPath = indexPath
        
        print("Selected Color: \(String(describing: selectedColor))")
    }

}

final class ColorViewCell: UICollectionViewCell {
    let viewColor = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    private func setupViews() {
        contentView.addSubview(viewColor)
        viewColor.translatesAutoresizingMaskIntoConstraints = false
        viewColor.layer.cornerRadius = 8

        NSLayoutConstraint.activate([
            viewColor.heightAnchor.constraint(equalToConstant: 40),
            viewColor.widthAnchor.constraint(equalToConstant: 40),
            viewColor.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            viewColor.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}
