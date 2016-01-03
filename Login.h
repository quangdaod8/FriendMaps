//
//  Login.h
//  FriendMaps
//
//  Created by Đào Duy Quang  on 12/30/15.
//  Copyright © 2015 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"
#import "DataServices.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "SignUp.h"

@interface Login : UIViewController
@property (nonatomic, strong) UserData *userData;
@property(nonatomic,strong) DataServices *getData;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)btnLogin:(id)sender;
- (IBAction)btnRegister:(id)sender;
@end
