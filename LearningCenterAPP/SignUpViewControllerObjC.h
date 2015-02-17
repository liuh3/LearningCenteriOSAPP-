//
//  SignUpViewControllerObjC.h
//  LearningCenterAPP
//
//  Created by Coco Liu on 2/17/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
@interface SignUpViewControllerObjC : UIViewController

- (id) init;
- (void) signUp;
- (void) showAlert: (NSString*) message;

@end
