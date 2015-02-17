//
//  TutorScheduleTableViewController.swift
//  LearningCenterAPP
//
//  Created by Coco Liu on 2/8/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class TutorScheduleTableViewController: UITableViewController {
    
    let tutorScheduleCellIdentifier = "TutorScheduleCell"
    let specificTutorSegueIdentifier = "SpecificTutorSegue"
    let noTutorAvailableCellIdentifier = "NoTutorAvailableCell"
    let studentEvalSegueIdentifier = "StudentEvalSegue"
    let tutorEvalSegueIdentifier = "TutorEvalSegue"
    let specificTutorScheduleCellIdentifier = "SpecificTutorScheduleCell"
    let backToCalSegueIdentifier = "BackToCalSegue"
    var myRootRef = Firebase(url:"https://learning-center-app.firebaseio.com/Users")
    var names = Array<String>()
    var times = Array<String>()
    var tutorUserNames = Array<String>()
    var date : NSString = ""
    var userName : NSString = ""
    var signInName : NSString = ""
    var isTutor : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "showEvaluationForms")
        
    }
    
    //collect all the working tutor data with names and working time from Firebase
    func getDataFromFireBase(){
        myRootRef.queryOrderedByChild("IsATutor").observeEventType(.ChildAdded, withBlock: { snapshot in
            var userFirebase = self.myRootRef.childByAppendingPath(snapshot.key)
            userFirebase.observeEventType(.Value, withBlock: { snapshot in
                
                if snapshot.hasChild("IsATutor"){
                    var tutorWorking = snapshot.value["Name"] as String
                    var tutorUserName = snapshot.key as String
                    let scheduelFirebase = userFirebase.childByAppendingPath("IsATutor").childByAppendingPath("Schedule")
                    scheduelFirebase.queryOrderedByChild("Schedule").observeEventType(.ChildAdded, withBlock: {snapshot in
                        
                        if(snapshot.key == self.date){
                            self.tutorUserNames.append(tutorUserName)
                            let timeSlot = scheduelFirebase.childByAppendingPath(snapshot.key)
                            timeSlot.observeSingleEventOfType(.Value, withBlock: {
                                snapshot in
                                
                                // WORKGING HOUR
                                if let rest = snapshot.children.nextObject() as? FDataSnapshot {
                                    
                                    self.times.append(rest.key)
                                }
                                self.names.append(tutorWorking)
                                self.tableView.reloadData()
                            })
                            
                        }
                        
                    })
                }
                
                
                }, withCancelBlock: { error in println(error.description)})
            
        })
        
    }
    
    // initilize all data
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var signInNameFire = myRootRef.childByAppendingPath(self.userName).childByAppendingPath("Name")
        signInNameFire.observeEventType(.Value, withBlock: { snapshot in
            self.signInName = snapshot.value as NSString
            }, withCancelBlock: { error in
                println(error.description)
        })
        
        var checkTutorFire = myRootRef.childByAppendingPath(self.userName)
        
        
        checkTutorFire.observeEventType(.Value, withBlock: { snapshot in
            
            self.isTutor = snapshot.hasChild("IsATutor")
            }, withCancelBlock: { error in
                println(error.description)
        })
        
        self.times = Array<String>()
        self.names = Array<String>()
        self.getDataFromFireBase()
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(times.count,1)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        if(self.times.count==0){
            cell = tableView.dequeueReusableCellWithIdentifier(self.noTutorAvailableCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        }else{
            
            cell = tableView.dequeueReusableCellWithIdentifier(tutorScheduleCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = self.names[indexPath.row]
            cell.detailTextLabel?.text = self.times[indexPath.row]
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == self.specificTutorSegueIdentifier{
            if let indexPath = self.tableView.indexPathForSelectedRow(){
                let navController = segue.destinationViewController as UINavigationController
                let specificTutorViewController = navController.topViewController as SpecificTutorScheduleViewController
                specificTutorViewController.workingTime  = self.times[indexPath.row]
                specificTutorViewController.tutorUserName = self.tutorUserNames[indexPath.row]
                specificTutorViewController.workingDate = self.date
                specificTutorViewController.userName = self.userName
                
            }
        }
        else if(segue.identifier == self.tutorEvalSegueIdentifier){
            (segue.destinationViewController as TutorEvaluationViewController).userName = self.userName
            (segue.destinationViewController as TutorEvaluationViewController).date = self.date
        }else if(segue.identifier == self.studentEvalSegueIdentifier){
            (segue.destinationViewController as StudentEvaluationViewController).userName = self.userName
            (segue.destinationViewController as StudentEvaluationViewController).date = self.date
        }
        
    }
    
    // handle all evaluation according to the type fo user, evaluations will be displayed as a navigation item
    func showEvaluationForms(){
        
        
        let alertController = UIAlertController(title: "Evaluation", message: "You have finished your tutor session. Would you like to write an evaluation?", preferredStyle: .Alert)
        let studentAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            self.performSegueWithIdentifier(self.studentEvalSegueIdentifier, sender: nil)
        }
        let peerTutorAction = UIAlertAction(title: "Peer Tutor", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.performSegueWithIdentifier(self.tutorEvalSegueIdentifier, sender: nil)
            
        }
        
        let ESLAction = UIAlertAction(title: "ESL", style: UIAlertActionStyle.Default) { (action) -> Void in

            var bool  = UIApplication.sharedApplication().openURL(NSURL(string: "https://docs.google.com/forms/d/1YBtkRkxVzjqGt-7dBC5hA5qoND66-o_gfG__iuSQsMo/viewform")!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            // nothing here
        }
        
        if(isTutor){
            alertController.addAction(peerTutorAction)
            alertController.addAction(ESLAction)
            alertController.addAction(cancelAction)
        }else{
            alertController.addAction(studentAction)
            alertController.addAction(cancelAction)
        }
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
}
