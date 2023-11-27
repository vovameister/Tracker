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
        
        
        cell.delegate = self
        
        cell.backgroundColor = .white
        cell.colorLabel.backgroundColor = tracker.color
        cell.button.backgroundColor = tracker.color
        cell.messege.text = tracker.action
        cell.emodjiLabel.text = tracker.emoji
        cell.trackerId = tracker.id
        cell.indexPath = indexPath
        cell.isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        cell.button.isEnabled = isButtonEnable()
        let buttonText = cell.isCompletedToday ? "✓" : "+"
        cell.button.setTitle(buttonText, for: .normal)
        
        cell.repeatedTimes = completedTrackers.filter { $0.trackerId == tracker.id }.count
        cell.daysLabel.text = "\(cell.repeatedTimes) \(calculateDayString(for: cell.repeatedTimes))"
        
        return cell
    }
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.trackerId == id && isSameDay
        }
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
    func calculateDayString(for repeatedTimes: Int) -> String {
        var day = ""
        
        if repeatedTimes > 4 || repeatedTimes == 0 {
            day = "дней"
        } else if repeatedTimes == 1 {
            day = "день"
        } else {
            day = "дня"
        }
        return day
    }
}
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(trackerId: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.trackerId == id && isSameDay
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    
}
