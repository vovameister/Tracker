//
//  EmojiTableViewDelegate.swift
//  Tracker
//
//  Created by Владимир Клевцов on 17.11.23..
//

import UIKit

final class EmojiCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    weak var parentViewController: HabitOrEventController?
    var selectedEmoji: String?
    var selectedIndexPath: IndexPath?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        18
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? EmojiCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.label.text = emojis[indexPath.row]
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
        selectedEmoji = emojis[indexPath.item]
        if let prevIndexPath = selectedIndexPath {
            let prevCell = collectionView.cellForItem(at: prevIndexPath)
            prevCell?.backgroundColor = UIColor.white
        }
        
        selectedEmoji = emojis[indexPath.item]
        parentViewController!.emoji = selectedEmoji
        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.backgroundColor = UIColor(named: "lightGrey")
        selectedCell?.layer.cornerRadius = 16
        
        selectedIndexPath = indexPath
        
        print("Selected Emoji: \(selectedEmoji ?? "")")
    }
}

final class EmojiCollectionViewCell: UICollectionViewCell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
fileprivate let emojis: [String] = ["😀", "😍", "🚀", "🌈", "🎉", "🍎", "🍕", "🎸", "⌚️", "🚗", "📷", "💡", "🎈", "📚", "🏖️", "🍦", "🎁", "🌟"]
