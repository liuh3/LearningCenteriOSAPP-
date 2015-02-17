//
//  StudentEvaluationViewController.swift
//  LearningCenterAPP
//
//  Created by Nithin Perumal on 2/12/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class StudentEvaluationViewController: UIViewController {
    let studentEvalBackSegueIdentifier = "StudentEvalBackSegue"
    var userName = ""
    var date = ""
    // These fields must be filled in
    @IBOutlet weak var ClassYear: UITextField!
    @IBOutlet weak var ESL: UISegmentedControl!
    @IBOutlet weak var Purpose: UITextField!
    @IBOutlet weak var Attitude: UISegmentedControl!
    @IBOutlet weak var Atmosphere: UISegmentedControl!
    @IBOutlet weak var Knowledge: UISegmentedControl!
    @IBOutlet weak var Understanding: UISegmentedControl!
    @IBOutlet weak var Opinion: UISegmentedControl!
    
    // Optional Text fields:
    
    @IBOutlet weak var Commens: UITextField!
    @IBOutlet weak var TutorName: UITextField!
    @IBOutlet weak var StudentName: UITextField!
    
    // Additional variables
    var myRootRef = Firebase(url:"https://learning-center-app.firebaseio.com/Evaluations")
    var ESLC : Bool!
    var filled : Bool = true

    // The submit button
    @IBAction func Submit(sender: AnyObject) {
        
        if(self.ClassYear.text == "" || self.Purpose.text == ""){
            self.showAlert("Please Fill Out All Text Fields")
            self.filled = false;
            return;
        }
        self.filled = true;
        var att = 0;
        var atmos = 0;
        var knowl = 0;
        var understand = 0;
        var opin = 0;
        var randomid = NSUUID().UUIDString

        
        if (ESL.selectedSegmentIndex.toIntMax() != 0) {
            if (ESL.selectedSegmentIndex.toIntMax() != 1) {
                ESLC = false
            }
        }
        if (ESL.selectedSegmentIndex == 0) {
            ESLC = true
        }
        else {
            ESLC = false
        }
        
        
        if (Commens.text == "") {
            Commens.text = "N/A"
        }
        if (TutorName.text == "") {
            TutorName.text = "N/A"
        }
        if (StudentName.text == "") {
            StudentName.text = "N/A"
        }
        
        var CLY : String = ClassYear.text
        var Com : String = Commens.text
        var Eva : String = StudentName.text
        var Tut : String = TutorName.text
        var purp : String = Purpose.text
        
        
        
        if (Atmosphere.selectedSegmentIndex>=0) {
            att = Atmosphere.selectedSegmentIndex
        }
        if (Attitude.selectedSegmentIndex>=0) {
            att = Atmosphere.selectedSegmentIndex
        }
        if (Knowledge.selectedSegmentIndex>=0) {
            att = Atmosphere.selectedSegmentIndex
        }
        if (Understanding.selectedSegmentIndex>=0) {
            att = Atmosphere.selectedSegmentIndex
        }
        if (Opinion.selectedSegmentIndex>=0) {
            att = Atmosphere.selectedSegmentIndex
        }
        
        
        
        var evalDic = ["Atmosphere": atmos+1, "Attitude": att+1, "Class Year": CLY, "Comment": Com, "ESL": ESLC, "Evaluator": Eva, "General": opin+1, "Overall Knowledge": knowl+1, "Purpose": purp, "Tutor Evaluated": Tut, "Understanding": understand+1]
        
        var uploadDic = [randomid: evalDic]
        
        self.myRootRef.updateChildValues(uploadDic)
        self.showAlert("Evaluation Complete, Thank You!!!")
//         self.performSegueWithIdentifier(self.studentEvalBackSegueIdentifier, sender: nil)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as TutorScheduleTableViewController).userName = self.userName
        (segue.destinationViewController as TutorScheduleTableViewController).date = self.date
    }
    
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            if(self.filled){
            self.performSegueWithIdentifier(self.studentEvalBackSegueIdentifier, sender: nil)
            }
        }
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
