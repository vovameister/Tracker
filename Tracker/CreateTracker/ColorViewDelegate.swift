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
        cell.backgroundColor = UIColor(named: "\(indexPath.row + 1)")
        cell.layer.cornerRadius = 8
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        7.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (((parentViewController!.scrollView.bounds.width - 38) - 52 * 6) / 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = UIColor(named: "\(indexPath.item + 1)")
        if let prevIndexPath = selectedIndexPath {
                  let prevCell = collectionView.cellForItem(at: prevIndexPath)
                  prevCell?.backgroundColor = UIColor(named: "\(indexPath.row + 1)")
              }

               selectedColor = UIColor(named: "\(indexPath.item + 1)")

              let selectedCell = collectionView.cellForItem(at: indexPath)
              selectedCell?.backgroundColor = UIColor(named: "lightGrey")

              selectedIndexPath = indexPath

        print("Selected Color: \(String(describing: selectedColor)))")
     }
}

final class ColorViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
