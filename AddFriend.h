//
//  AddFriend.h
//  FriendMaps
//
//  Created by Đào Duy Quang  on 1/2/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DataServices.h"
#import "UserData.h"

@interface AddFriend : UIViewController
@property (strong, nonatomic) NSString *myEmail;
@property (strong, nonatomic) NSString *myName;
@property (strong, nonatomic) NSString *toEmail;
@property (strong, nonatomic) DataServices *service;
@property (weak, nonatomic) IBOutlet UIImageView *imgAva;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)btnSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
- (IBAction)btnAdd:(id)sender;

@end
