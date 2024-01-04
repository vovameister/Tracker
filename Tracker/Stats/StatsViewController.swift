//
//  StatsViewController.swift
//  Tracker
//
//  Created by Владимир Клевцов on 31.10.23..
//
import UIKit

final class StatsViewController: UIViewController {
    let titleView = UITextView()
    let bestPeriodView = UIView()

    let statistics = NSLocalizedString("statistics", comment: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpView()
    }

    func setUpView() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = statistics
        titleView.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        view.addSubview(titleView)

        bestPeriodView.translatesAutoresizingMaskIntoConstraints = false
//        bestPeriodView.layer.cornerRadius = 16
        bestPeriodView.backgroundColor = .gray
        bestPeriodView.gradientBorder(colors: [UIColor.red , UIColor.blue], isVertical: false)
        view.addSubview(bestPeriodView)

        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -105),
            titleView.heightAnchor.constraint(equalToConstant: 41),

            bestPeriodView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bestPeriodView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 77),
            bestPeriodView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bestPeriodView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

//    private func setupGradient() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bestPeriodView.bounds
//        gradientLayer.colors = [
//            UIColor(named: "gradient1")?.cgColor ?? UIColor.red.cgColor,
//            UIColor(named: "gradient2")?.cgColor ?? UIColor.green.cgColor,
//            UIColor(named: "gradient3")?.cgColor ?? UIColor.white.cgColor
//        ]
//        gradientLayer.cornerRadius = bestPeriodView.layer.cornerRadius
//        gradientLayer.borderWidth = 1
//
//        bestPeriodView.layer.addSublayer(gradientLayer)
//    }
}



//private func setupGradient() {
//    let startColor = UIColor(named: "gradient1")?.cgColor
//    let middleColor = UIColor(named: "gradient2")?.cgColor
//    let endColor = UIColor(named: "gradient3")?.cgColor
//
//    gradientLayer.colors = [startColor, middleColor, endColor]
//    gradientLayer.frame = bestPeriodView.bounds
//    gradientLayer.cornerRadius = 16
//    gradientLayer.borderWidth = 1
//    let shape = CAShapeLayer()
//    shape.lineWidth = 1
//    shape.path = UIBezierPath(rect: bestPeriodView.bounds).cgPath
//    shape.strokeColor = UIColor.black.cgColor
//    shape.fillColor = UIColor.clear.cgColor
//    gradientLayer.mask = shape
//    bestPeriodView.layer.addSublayer(gradientLayer)
//}
extension UIView {
    func gradientBorder(colors: [UIColor], isVertical: Bool){
        self.layer.masksToBounds = true
        
        //Create gradient layer
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradient.colors = colors.map({ (color) -> CGColor in
            color.cgColor
        })

        //Set gradient direction
        if(isVertical){
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        }
        else {
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        }

        //Create shape layer
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: gradient.frame.insetBy(dx: 1, dy: 1), cornerRadius: self.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        //Add layer to view
        self.layer.addSublayer(gradient)
        gradient.zPosition = 0
    }
}
