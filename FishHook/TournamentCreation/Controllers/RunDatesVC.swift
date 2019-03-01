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
    var timeFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Set initial DatePicker times to 12:00 PM
  
        timeSetup()
        
        // Setting initial start dates and variable values
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Dates.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSelected(sender:)))
        
        setUpCalendar()
    }
    
    func timeSetup(){
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        timeFormatter.locale = Locale(identifier: "en_US")
        start = timeFormatter.string(from: startTime.date)
        end = timeFormatter.string(from: endTime.date)
    }
    
    // getting time from DatePicker 
    @IBAction func timeChange(_ sender: UIDatePicker) {
        switch sender.tag {
        case 0:
            start = timeFormatter.string(from: sender.date)
        case 1:
            end = timeFormatter.string(from: sender.date)
        default:
            print("Invalid Sender")
        }
    }
    
    
    @objc func saveSelected(sender: UIBarButtonItem) {
        
        
        // TODO: Validate at least one day has been selected and start and end times
        guard calendar.selectedDates.count > 0 else {
            let alert = Utils.basicAlert(title: "No Dates Selected", message: "Please Select a valid range of dates for your tournament", Button: "OK")
            present(alert, animated: true, completion:  nil)
            return
        }
        
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .none
        dateFormat.locale = Locale(identifier: "en_US")
    
        // Sorting dates by ascending
        let sortedDates = calendar.selectedDates.sorted(by: {$0 < $1})
        
        // Getting the start and end dates
        let startDate = "\(dateFormat.string(from: sortedDates[0])) at \(start!)"
        let endDate = "\(dateFormat.string(from: sortedDates[sortedDates.count - 1])) at \(end!)"
        
        print(startDate)
        print(endDate)
        
        // TODO: Save the run dates to the database
    
    }
    
    // Calendar setup
    func setUpCalendar(){
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)
    }
}

extension RunDatesVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // TODO: Format the dates.
    
    // Datasource
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        // Setting height after layout change.
        self.calendar.frame.size.height = bounds.height

    }
    
    // Setting minimum date
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
