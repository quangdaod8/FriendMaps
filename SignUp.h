//
//  SignUp.h
//  FriendMaps
//
//  Created by Đào Duy Quang  on 1/1/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DataServices.h"

@interface SignUp : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPass;
@property (weak, nonatomic) IBOutlet UIButton *btnAva;
@property (strong, nonatomic) UIImage *imgAva;
@property (strong,nonatomic) DataServices *service;
- (IBAction)btnAva:(id)sender;

- (IBAction)btnSignUp:(id)sender;
- (IBAction)btnCancel:(id)sender;
@end
