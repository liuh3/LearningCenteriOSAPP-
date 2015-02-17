//
//  TutorEvaluationViewController.swift
//  LearningCenterAPP
//
//  Created by Nithin Perumal on 2/13/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class TutorEvaluationViewController: UIViewController {
    
    let tutorEvalBackSegueIdentifier = "TutorEvalBackSegue"
    
    @IBOutlet weak var StudentName: UITextField!
    @IBOutlet weak var ClassYear: UITextField!
    @IBOutlet weak var Date: UITextField!
    @IBOutlet weak var Time: UITextField!
    @IBOutlet weak var Professor: UITextField!
    @IBOutlet weak var Course: UITextField!
    @IBOutlet weak var HelpNeeded: UITextField!
    @IBOutlet weak var Attitude: UITextField!
    @IBOutlet weak var Tutor: UITextField!
    
    var userName = ""
    var date = ""
    var reviewnum : Int = 0
    var myRootRef = Firebase(url:"https://learning-center-app.firebaseio.com/Users/")
    var myRootRef2 = Firebase(url:"https://learning-center-app.firebaseio.com/Users")
    var filled : Bool = true;
    
    @IBAction func Submit(sender: AnyObject) {
        
        if(self.StudentName.text == "" || self.ClassYear.text == "" || self.Date.text == "" || self.Time.text == "" || self.Professor.text == "" || self.Course.text == "" || self.HelpNeeded.text == "" || self.Attitude.text == "" || self.Tutor.text == "") {
            self.filled = false
            self.showAlert("Please Fill Out All Information")
            
            return
        }
        self.filled = true
        
        //        myRootRef = Firebase(url:"https://learning-center-app.firebaseio.com/Users/\(userName)")
        
        myRootRef = myRootRef.childByAppendingPath(userName)
        
        myRootRef2.queryOrderedByChild("IsATutor").observeEventType(.ChildAdded, withBlock: { snapshot in
            
            var SN : String = self.StudentName.text
            var CY : String = self.ClassYear.text
            var D : String = self.Date.text
            var T : String = self.Time.text
            var Prof : String = self.Professor.text
            var Cour : String = self.Course.text
            var HN : String = self.HelpNeeded.text
            var Att : String = self.Attitude.text
            var Tut : String = self.Tutor.text
            var randomid = NSUUID().UUIDString
            
            
            
            if (self.userName == snapshot.key){
                
                
                self.myRootRef = self.myRootRef.childByAppendingPath("/IsATutor/Evaluations")
                
                var evalDic = ["Student": SN, "Year": CY, "Date": D, "Time": T, "Professor": Prof, "Course": Cour, "Help Needed": HN, "Attitude": Att, "Tutor": Tut]
                
                var uploadDic = [randomid : evalDic]
                
                self.myRootRef.updateChildValues(uploadDic)
                self.showAlert("Evaluation Complete, Thank You!!!")
                return
            }

            
        })
        
        
    }
    
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            if(self.filled){
            self.performSegueWithIdentifier(self.tutorEvalBackSegueIdentifier, sender: nil)
            }
        }
        alertController.addAction(defaultAction)
        
            self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as TutorScheduleTableViewController).userName = self.userName
        (segue.destinationViewController as TutorScheduleTableViewController).date = self.date
    }
    
}
