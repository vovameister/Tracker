//
//  TrackersExtentions.swift
//  Tracker
//
//  Created by Владимир Клевцов on 8.11.23..
//

import UIKit

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .white
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let days = String.localizedStringWithFormat(
            NSLocalizedString("Days", comment: "Number of days repeated"),
            trackerRecordCD.sumOfRecords(uuid: tracker.id)
        )
        if visibleCategories[indexPath.section].title != pinned {
            cell.pinMark.isHidden = true
        } else {
            cell.pinMark.isHidden = false
        }
        
        cell.delegate = self
        
        cell.backgroundColor = UIColor(named: "backgroung")
        cell.colorLabel.backgroundColor = tracker.color
        cell.button.backgroundColor = tracker.color
        cell.messege.text = tracker.action
        cell.emodjiLabel.text = tracker.emoji
        cell.trackerId = tracker.id
        cell.indexPath = indexPath
        cell.button.isEnabled = isButtonEnable()
        let buttonText = trackerRecordCD.hasTracker(date: datePicker.date, uuid: tracker.id) ? "✓" : "+"
        cell.button.setTitle(buttonText, for: .normal)
        
        cell.repeatedTimes = trackerRecordCD.sumOfRecords(uuid: tracker.id)
        cell.daysLabel.text = "\(cell.repeatedTimes) \(days)"
        
        return cell
    }
    func isButtonEnable() -> Bool {
        let selectedDate = datePicker.date
        let currentDate = Date()
        
        if selectedDate <= currentDate {
            return true
        } else {
            return false
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
            view.titleLabel.text = visibleCategories[indexPath.section].title
            return view
        default:
            fatalError("Unexpected kind")
        }
    }
}
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else {
               return nil
           }

           let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
           let isPinned = trackerPinStore.fetchPin(id: tracker.id)
           return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {_ in
               let inspectAction =
               UIAction(title: isPinned == true ? self.unpin : self.pin,
                                   image: nil) { action in
                   self.trackerPinStore.addPin(id: tracker.id, pin: !(isPinned ?? false))
                   self.reloadData()
                          }
                          
                      let duplicateAction =
               UIAction(title: self.edit,
                                   image: nil) { action in
                   self.analyticsService.report(event: "click", params: ["sceen" : "main", "item" : "edit"])
                   
                   let viewController = HabitOrEventController(title: self.habitEdit, setUpTableInt: 2, tableViewHeight: 150, isEdit: true, uuid: tracker.id)
                   self.present(viewController, animated: true, completion: nil)
                          }
                          
                      let deleteAction =
               UIAction(title: self.deleteAction,
                                   image: nil){ action in
                   self.analyticsService.report(event: "click", params: ["sceen" : "main", "item" : "delete"])
                   
                   self.showDeleteActionSheet(uuid: tracker.id)
                          }
               let deleteActionAttributes: [NSAttributedString.Key: Any] = [
                   .foregroundColor: UIColor.red
               ]
               let deleteActionTitle = NSAttributedString(string: self.deleteAction, attributes: deleteActionAttributes)
               deleteAction.setValue(deleteActionTitle, forKey: "attributedTitle")
               return UIMenu(title: "", children: [inspectAction, duplicateAction, deleteAction])
           })
       }
    }


extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width:(view.bounds.width - 41) / 2, height: 148)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        CGSize(width: collectionView.bounds.width, height: 30)
    }
}
extension TrackersViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        reloadVisibleCategories()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reloadVisibleCategories()
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        reloadVisibleCategories()
        print("Cancel button clicked")
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadVisibleCategories()
    }
}
extension TrackersViewController: TrackerCellDelegate {
    
    func addOrDalete(id: UUID, at indexPath: IndexPath) {
        if trackerRecordCD.hasTracker(date: datePicker.date, uuid: id) {
            
            trackerRecordCD.removeTracker(date: datePicker.date, uuid: id)
        } else {
            
            trackerRecordCD.addRecord(id: id, date: datePicker.date)
        }
        statController.updateScoreText()
        collectionView.reloadItems(at: [indexPath])
    }
}
extension TrackersViewController: TrackerCategoryStoreDelegate {
    func categoryStore() {
        categories = trackerCategoryStore.trackerCategories
        reloadData()
        
    }
}
extension TrackersViewController: TrackerCoreDataStoreDelegate {
    func store() {
        categories = trackerCategoryStore.trackerCategories
        reloadData()
    }
}
