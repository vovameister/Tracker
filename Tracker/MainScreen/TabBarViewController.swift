//
//  ViewController.swift
//  Tracker
//
//  Created by Владимир Клевцов on 31.10.23..
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let trackersViewController = TrackersViewController.shared
        let statsViewController = StatsViewController()

        
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "Image1gray"), selectedImage: UIImage(named: "Image1blue"))
        statsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "Image2gray"), selectedImage: UIImage(named: "Image2blue"))
        addSeparatorLine()
        self.tabBar.backgroundColor = .white
        self.viewControllers = [trackersViewController, statsViewController]
    }
    func addSeparatorLine() {
          let separatorLine = UIView()
          separatorLine.backgroundColor = UIColor.gray
        separatorLine.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 0.5)

          tabBar.addSubview(separatorLine)
      }
}

