//
//  SignUpViewController.swift
//  LearningCenterAPP
//
//  Created by Coco Liu on 2/11/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit



class SignUpViewController: UIViewController {
    
    var myRootRef = Firebase(url:"https://learning-center-app.firebaseio.com/Users")
    var specificUser = Dictionary<String, String> ()
    var exist : Bool = false
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var createPassTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    @IBAction func signUpButton(sender: AnyObject) {
        
        myRootRef.queryOrderedByChild("Name").observeEventType(.ChildAdded, withBlock: { snapshot in
            if self.userNameTextField.text == snapshot.key{
                self.exist = true
                
                
            }
        })
        
        delay(0.4){
        if(self.userNameTextField.text == "" || self.nameTextField == "" || self.createPassTextField.text == "" || self.confirmPassTextField == "" ){
            self.showAlert("Please Fill Out All Information")
        }else{
            if(self.createPassTextField.text == self.confirmPassTextField.text){
                
                self.specificUser = ["Name": self.nameTextField.text, "Password": self.createPassTextField.text]
                
                var newUser = [self.userNameTextField.text: self.specificUser]
                
                if self.exist{
                    self.showAlert("User Exist")
                }
                else{
                   
                    self.myRootRef.updateChildValues(newUser)
                    
                    self.showAlert("You have sign up with \(self.userNameTextField.text)")
                    self.exist = false
                }
                
            }else{
                self.showAlert("Password Doesn't Match")
                
            }
        }
        
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
}
