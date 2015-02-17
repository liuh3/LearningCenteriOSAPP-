//
//  CalendarViewController.swift
//  LearningCenterAPP
//
//  Created by Coco Liu on 2/12/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    let workingTutorSegueIdentifier = "WorkingTutorSegue"
    var date : NSString = ""
    var userName = ""
    @IBOutlet weak var calendarPicker: UIDatePicker!
    
    @IBOutlet weak var rose_image: UIImageView!
    

    @IBAction func selectDateButton(sender: AnyObject) {
        calendarPicker.datePickerMode = UIDatePickerMode.Date
        date = self.handleDatePicker(calendarPicker)
        self.performSegueWithIdentifier(self.workingTutorSegueIdentifier, sender: sender)
        
        
    }
    
    func handleDatePicker(sender: UIDatePicker) -> NSString {
        var dateFormatter = NSDateFormatter()
        // the specific format we use in the Firebase for date
        dateFormatter.dateFormat = "yyyy-M-dd"
        return dateFormatter.stringFromDate(sender.date)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == workingTutorSegueIdentifier{
            
            let navController = segue.destinationViewController as UINavigationController
            let tutorViewController = navController.topViewController as TutorScheduleTableViewController
            
            tutorViewController.date = self.date
            tutorViewController.userName = self.userName
            
        }
    }
    
}
