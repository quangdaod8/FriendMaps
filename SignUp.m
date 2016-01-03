//
//  SignUp.m
//  FriendMaps
//
//  Created by Đào Duy Quang  on 1/1/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "SignUp.h"

@interface SignUp ()

@end

@implementation SignUp

- (void)viewDidLoad {
    _service = [[DataServices alloc]init];
    _btnAva.clipsToBounds = YES;
    _btnAva.layer.cornerRadius = 50;
    _btnAva.layer.borderWidth = 1;
    _btnAva.layer.borderColor = [UIColor orangeColor].CGColor;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnAva:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)btnSignUp:(id)sender {
    if([_txtName.text isEqualToString:@""]) [self AlertWithTitle:@"Tên Hiển Thị" Messenger:@"Tên hiển thị không được trống" Butontitle:@"Ok"];
    else if ([_txtEmail.text isEqualToString:@""]) [self AlertWithTitle:@"Email" Messenger:@"Email không được trống" Butontitle:@"Ok"];
    else if ([_txtPass.text isEqualToString:@""]) [self AlertWithTitle:@"Mật Khẩu" Messenger:@"Mật Khẩu không được trống" Butontitle:@"Ok"];
    else if (_imgAva == nil) [self AlertWithTitle:@"Ảnh Đại Diện" Messenger:@"Ảnh Đại Diện giúp bạn bè nhận ra bạn dễ dàng hơn, vui lòng chọn 1 ảnh" Butontitle:@"Ok"];
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_service signUpForEmail:_txtEmail.text Name:_txtName.text Password:_txtPass.text ImageAva:_imgAva Completed:^(BOOL isEmailExist, NSError *error) {
            if(isEmailExist)
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self AlertWithTitle:@"Email" Messenger:@"Email này đã đăng ký tài khoản, vui lòng chọn 1 email khác" Butontitle:@"Ok"];
            }
            else
            {
                if(!error)
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertController *done = [UIAlertController alertControllerWithTitle:@"Thành công" message:@"Đã tạo tài khoản thành công.\nBây giờ bạn có thể đăng nhập và sử dụng ứng dụng." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [done addAction:ok];
                    [self presentViewController:done animated:YES completion:nil];
                }
                else
                {
                    switch (error.code) {
                        case 100:
                        {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            [self AlertWithTitle:@"Lỗi mạng" Messenger:@"Vui lòng kiểm tra lại kết nối Internet" Butontitle:@"Ok"];
                            break;
                        }
                        default:
                        {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            [self AlertWithTitle:@"Lỗi" Messenger:@"Lỗi không xác định, vui lòng thử lại" Butontitle:@"Ok"];
                            break;
                        }
                    }
                    
                    
                }
            }
        }];
         
    }
        
}

- (IBAction)btnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        _imgAva = [[UIImage alloc]init];
        _imgAva = [info valueForKey:@"UIImagePickerControllerEditedImage"];
        [_btnAva setBackgroundImage:_imgAva forState:UIControlStateNormal];
    }];
}

-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
