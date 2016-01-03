//
//  Login.m
//  FriendMaps
//
//  Created by Đào Duy Quang  on 12/30/15.
//  Copyright © 2015 Đào Duy Quang . All rights reserved.
//

#import "Login.h"

@interface Login ()

@end

@implementation Login

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    if([data objectForKey:@"userData"] != nil) [self getDataForFirstLogin:NO];
    if([data objectForKey:@"time"] == nil) {
        [data setValue:[NSNumber numberWithInteger:0] forKey:@"time"];
        [data synchronize];
    }
}
- (void)viewDidLoad {
    _userData = [[UserData alloc]init];
    _getData = [[DataServices alloc]init];
        [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDataForFirstLogin:(BOOL) isFirstLogin
{
    if (isFirstLogin) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_getData getUserDataWithEmail:_txtEmail.text completed:^(UserData *userData, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(!error)
            {
                if ([_txtPassword.text isEqualToString:userData.userPassword]) {
                    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
                    [data setObject:userData.userEmail forKey:@"userData"];
                    [data synchronize];
                    PFInstallation *curren = [PFInstallation currentInstallation];
                    if(!curren[@"email"] || curren[@"email"] != userData.userEmail) {
                        curren[@"email"] = userData.userEmail;
                    [curren saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(!error) {
                        UINavigationController *target = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
                        [self presentViewController:target animated:YES completion:nil];
                        } else [self AlertWithTitle:@"Lỗi Đăng Nhập" Messenger:@"Chưa thể đăng nhập vào lúc này, mất kết nối mạng có thể là nguyên nhân." Butontitle:@"Ok"];
                    }];
                    } else {
                        UINavigationController *target = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
                        [self presentViewController:target animated:YES completion:nil];
                    }
                }
                else
                {
                    [self AlertWithTitle:@"Sai mật khẩu" Messenger:@"Vui lòng nhập lại đúng mật khẩu" Butontitle:@"Ok"];
                }
            }
            else
            {
                switch (error.code) {
                    case 100:
                    {
                        [self AlertWithTitle:@"Lỗi mạng" Messenger:@"Kiểm tra lại kết nối internet" Butontitle:@"Ok"];
                        break;
                    }
                    case 101:
                    {
                        [self AlertWithTitle:@"Lỗi đăng nhập" Messenger:@"Email không hợp lệ hoặc chưa đăng ký tài khoản" Butontitle:@"Ok"];
                        break;
                    }
                        default:
                    {
                        [self AlertWithTitle:@"Lỗi" Messenger:@"Lỗi không xác định, vui lòng thử lại" Butontitle:@"Ok"];
                    }
                }
            }
        }];
    }
    else
    {
        UINavigationController *target = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
        [self presentViewController:target animated:YES completion:nil];
    }
}

-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnLogin:(id)sender {
    [self getDataForFirstLogin:YES];
}

- (IBAction)btnRegister:(id)sender {
    SignUp *signUp = [[SignUp alloc]init];
    [self presentViewController:signUp animated:YES completion:nil];
}
@end
