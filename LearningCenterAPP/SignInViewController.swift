//
//  SignInViewController.swift
//  LearningCenterAPP
//
//  Created by Coco Liu on 2/12/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    let showCalenderSegueIdentifier = "ShowCalenderSegue";
    var myRootRef = Firebase(url:"https://learning-center-app.firebaseio.com/Users")
    var exist = false
    var userName = ""
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var rose_image: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        rose_image.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    // check if both username and password are completed and if the data exist in the Firebase
    @IBAction func signInButton(sender: AnyObject) {
        
        
        myRootRef.queryOrderedByChild("Name").observeEventType(.ChildAdded, withBlock: { snapshot in
            
            if let password = snapshot.value["Password"] as? String{
                
                if (self.userNameTextField.text == snapshot.key) && (self.passwordTextField.text == password){
                    self.userName = snapshot.key
                    self.exist = true
                    
                    self.performSegueWithIdentifier(self.showCalenderSegueIdentifier, sender: sender)
                    
                }
                
            }
            
        })
        
        delay(0.2){
            if(!self.exist){
                self.showAlert("User Name / Password Incorrect")}
        }
        
    }
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == self.showCalenderSegueIdentifier){
            let navController = segue.destinationViewController as UINavigationController
            let tutorViewController = navController.topViewController as CalendarViewController
            tutorViewController.userName = self.userName
            
            
        }
    }
}
