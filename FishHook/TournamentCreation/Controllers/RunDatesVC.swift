//
//  RunDatesVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/25/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FSCalendar

class RunDatesVC: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    
    var start: String?
    var end: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Set initial start dates and variable values
        
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Dates.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSelected(sender:)))
        
        setUpCalendar()
        
    }
    
    @IBAction func timeChange(_ sender: UIDatePicker) {
    }
    
    
    @objc func doneSelected(sender: UIBarButtonItem) {
        // TODO: Validate at least one day has been selected and start and end times
        // TODO: Save the run dates to the database
    }
    
    func setUpCalendar(){
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        
        // NO idea what is going on
//        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)
//        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        

    }
}

extension RunDatesVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // TODO: Format the dates.
    
    // Datasource
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        // TODO: Change for AutoLayout
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // add selected date to the array
        
        print("Selected " + date.description)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Deselected " + date.description)
        
        // TODO: Remove date from array.
    }
}
