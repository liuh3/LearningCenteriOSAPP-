//
//  SignUpViewControllerObjC.m
//  LearningCenterAPP
//
//  Created by Coco Liu on 2/17/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

#import "SignUpViewControllerObjC.h"
#import <Firebase/Firebase.h>

@interface SignUpViewControllerObjC ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *createPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (nonatomic) BOOL exist;
@property (nonatomic) NSDictionary* specificUser;
//@property Firebase* ref;
@end

@implementation SignUpViewControllerObjC

- (id) init{
    self = [super init];
    if(self) {
        self.exist = NO;
        self.specificUser = @{};
        //        self.ref= [[Firebase alloc] initWithUrl:@"https://learning-center-app.firebaseio.com/Users"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUpButton:(id)sender {
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://learning-center-app.firebaseio.com/Users"];
    [myRootRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if([self.userNameTextField.text isEqual: snapshot.key]){
            self.exist = YES;
            
        }
        
    }];
    
    
    
    [self performSelector:@selector(signUp) withObject:nil afterDelay:0.4];
    
}

- (void) signUp{
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://learning-center-app.firebaseio.com/Users"];
    
    if([self.userNameTextField.text  isEqual: @""] || [self.nameTextField.text  isEqual: @""] || [self.createPasswordTextField.text isEqual: @""] || [self.confirmPasswordTextField.text  isEqual: @""]){
        [self showAlert:@"Please Fill Out All Information"];
    }else{
        if([self.createPasswordTextField.text isEqualToString: self.confirmPasswordTextField.text]){
            self.specificUser = @{@"Name": self.userNameTextField.text,@"Password":self.createPasswordTextField.text};
            NSDictionary *newUser = @{self.userNameTextField.text:self.specificUser};
            
            if(self.exist){
                [self showAlert:@"User Exist"];
            }else{
                
                [myRootRef updateChildValues:newUser];
                [self showAlert:[NSString stringWithFormat:@"You have signed up with %@",self.userNameTextField.text]];
                self.exist = NO;
            }
            
        }else{
            [self showAlert:@"Password Doesn't Match"];
        }
    }
    
}
- (void)showAlert : (NSString*) message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message: @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
