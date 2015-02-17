//
//  SpecificTutorScheduleViewController.swift
//  LearningCenterAPP
//
//  Created by Coco Liu on 2/8/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//


// COCO'S

import UIKit

class SpecificTutorScheduleViewController: UITableViewController{
    let specificTutorScheduleCellIdentifier = "SpecificTutorScheduleCell"
    var workingTime : NSString = ""
    var tutorUserName : NSString = ""
    var workingDate : NSString = ""
    var userName : NSString = ""
    var slots = Array<String>()
    var students  = Array<String>()
    var myRootRef = Firebase(url:"https://learning-center-app.firebaseio.com/Users")
    var newSchedule = [String: String]()
    var signInName : NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var signInNameFire = myRootRef.childByAppendingPath(self.userName).childByAppendingPath("Name")
        signInNameFire.observeEventType(.Value, withBlock: { snapshot in
            self.signInName = snapshot.value as NSString
            }, withCancelBlock: { error in
                println(error.description)
        })
      
        self.viewFromFirebase()
        self.tableView.reloadData()
        
    }
    
    // collect current signed-up studetns from the firebase. 
    func viewFromFirebase(){
        let newFire = myRootRef.childByAppendingPath(self.tutorUserName).childByAppendingPath("IsATutor").childByAppendingPath("Schedule").childByAppendingPath(self.workingDate).childByAppendingPath(self.workingTime)
        
        newFire.observeEventType(.Value, withBlock: { snapshot in
            
            for rest in snapshot.children.allObjects as [FDataSnapshot] {
                self.slots.append(rest.key)
                self.students.append(rest.value as NSString)
            }
            self.tableView.reloadData()
            
            }, withCancelBlock: { error in
                println(error.description)
            }
            
        )
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return students.count;
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(specificTutorScheduleCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = students[indexPath.row]
        cell.detailTextLabel?.text = self.slots[indexPath.row]
        
        return cell
    }
    
    // show notification accordingly to availability
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(self.students[indexPath.row] == "Available"){
            self.showEditSlotAlert(self.signInName, title: "Sign Up")
        }else if(self.students[indexPath.row] == self.signInName){
            self.showEditSlotAlert("Available", title: "Cancel")
        }
        
    }
    
    
    // change Firebase Data accoring to sign up / cancel appoitment with different slot
    func editFromFirebase(newName: NSString){
        let indexPath = tableView.indexPathForSelectedRow()
        let slotFirebase = myRootRef.childByAppendingPath(self.tutorUserName).childByAppendingPath("IsATutor").childByAppendingPath("Schedule").childByAppendingPath(self.workingDate).childByAppendingPath(self.workingTime).childByAppendingPath(self.slots[indexPath!.row])
        slotFirebase.setValue(newName)
        self.students = Array<String>()
        self.slots = Array<String>()
        
    }
    
    // show the sign up / cancel appointment notification
    func showEditSlotAlert(availability : NSString , title : NSString){
        let indexPath = self.tableView.indexPathForSelectedRow()
        
        let alertController = UIAlertController(title: title, message: "Do you want to \(title.lowercaseString) slot \(self.slots[indexPath!.row])", preferredStyle: UIAlertControllerStyle.Alert)
        
        let signUpAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
            { (action) -> Void in
                // NEED TO HAVE SUGEU TO PASS SIGNED IN USER NAME TO HERE AND REPLACE WITH "test"
                self.students[indexPath!.row] = availability
                self.editFromFirebase(availability)
                self.tableView.reloadData()
                // NEED TO UPDATE CHILD TO DATABASE
                
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(signUpAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}
