//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Владимир Клевцов on 2.1.24..
//
import SnapshotTesting
import XCTest
@testable import Tracker


final class TrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewController() throws {
        let vc = TrackersViewController()
        assertSnapshots(matching: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
        assertSnapshots(matching: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }

}
