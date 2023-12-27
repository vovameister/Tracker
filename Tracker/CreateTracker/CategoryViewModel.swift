//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Владимир Клевцов on 27.12.23..
//


import UIKit

final class CategoryViewModel {
    static let shared = CategoryViewModel()
    
    @Observable
    private(set) var category:[String] = []
    @Observable
    private(set) var selectedCategory: String?
    
    private(set) var preSelected: IndexPath? = nil
    
    private var categoryStore = TrackerCategoryStore()
    
    
    convenience init() {
        let categoryStore = try! TrackerCategoryStore(
            context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        )
        self.init(categoryStore: categoryStore)
    }

    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
        self.category = categoryStore.fetchCategoryTitles()
    }
    func selectCategory(indexPath: IndexPath) {
        selectedCategory = category[indexPath.row]
    }
    func setindexPath(indexPath: IndexPath) {
        preSelected = indexPath
    }
    func appendCategory(category: String) {
        categoryStore.saveNewCategory(title: category)
//        self.category = categoryStore.fetchCategoryTitles()
            self.category.append(category)

    }
}
