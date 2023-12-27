//
//  Page.swift
//  Tracker
//
//  Created by Владимир Клевцов on 26.12.23..
//

import UIKit

class Page: UIPageViewController {
    var blue = BlueScreenViewController()
    var red = RedScreenViewController()
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        if let pages = pages {
            pageControl.numberOfPages = pages.count
        }
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .black
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    var pages: [UIViewController]?
   
    
    override func viewDidLoad() {
        pages = [blue, red]
    
        super.viewDidLoad()
        let first = pages?.first
        setViewControllers([first!], direction: .forward, animated: true)
        
        dataSource = self
        delegate = self
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 638),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
extension Page: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages?.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages?[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let pages = pages {
            guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
                return nil
            }
            return pages[index + 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let pages = pages {
            if let currentViewController = pageViewController.viewControllers?.first,
               let currentIndex = pages.firstIndex(of: currentViewController) {
                pageControl.currentPage = currentIndex
            }
        }
    }
}
