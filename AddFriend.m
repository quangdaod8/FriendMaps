//
//  AddFriend.m
//  FriendMaps
//
//  Created by Đào Duy Quang  on 1/2/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "AddFriend.h"

@interface AddFriend ()

@end

@implementation AddFriend

- (void)viewDidLoad {
    _service = [[DataServices alloc]init];
    _btnAdd.highlighted = YES;
    _btnAdd.userInteractionEnabled = NO;
    _imgAva.clipsToBounds = YES;
    _imgAva.layer.cornerRadius = 50;
    _imgAva.layer.borderWidth = 1;
    _imgAva.layer.borderColor = [UIColor orangeColor].CGColor;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)btnSearch:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_service getUserDataWithEmail:_txtEmail.text completed:^(UserData *userData, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error)
        {
            if(![userData.userEmail isEqualToString:_myEmail]) {
            _btnAdd.userInteractionEnabled = YES;
            _btnAdd.highlighted = NO;
            _imgAva.image = userData.userImageAvatar;
            _lblName.text = userData.userName;
            _toEmail = _txtEmail.text;
            } else [self AlertWithTitle:@"Email của bạn" Messenger:@"Vui lòng nhập email khác" Butontitle:@"Ok"];
        }
        else
        {
            switch (error.code) {
                case 100:
                    [self AlertWithTitle:@"Lỗi mạng" Messenger:@"Kiểm tra lại kết nối internet" Butontitle:@"Ok"];
                    _btnAdd.userInteractionEnabled = NO;
                    _btnAdd.highlighted = YES;
                    break;
                
                case 101:
                    [self AlertWithTitle:@"Không tìm thấy" Messenger:@"Email này chưa đăng ký tài khoản" Butontitle:@"Ok"];
                    _btnAdd.userInteractionEnabled = NO;
                    _btnAdd.highlighted = YES;
                    break;
                    
                default:
                    [self AlertWithTitle:@"Lỗi" Messenger:@"Lỗi không xác định, vui lòng thử lại sau" Butontitle:@"Ok"];
                    _btnAdd.userInteractionEnabled = NO;
                    _btnAdd.highlighted = YES;
                    break;
            }
        }
    }];
}
- (IBAction)btnAdd:(id)sender {
    __unsafe_unretained typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_service addFriendFromMyEmail:_myEmail toEmail:_txtEmail.text Completed:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if(!error)
        {
            NSString *m = [NSString stringWithFormat:@"%@ và bạn đã trở thành bạn bè. Kéo danh sách bạn bè xuống để cập nhật.",weakSelf.lblName.text];
            [weakSelf AlertWithTitle:@"Thành công" Messenger:m Butontitle:@"Ok"];
            weakSelf.btnAdd.userInteractionEnabled = NO;
            weakSelf.btnAdd.highlighted = YES;
            NSString *s = [NSString stringWithFormat:@"%@ đã gửi yêu cầu kết bạn và được chấp nhận tự động.",weakSelf.myName];
            [weakSelf.service pushNotificationToEmail:weakSelf.txtEmail.text withAlert:s withIsBadge:YES];
        } else {
            switch (error.code) {
                    case 123:
                    [weakSelf AlertWithTitle:@"Đã là bạn" Messenger:@"Email này đã nằm trong danh sách bạn bè của bạn" Butontitle:@"Ok"];
                    weakSelf.btnAdd.userInteractionEnabled = NO;
                    weakSelf.btnAdd.highlighted = YES;
                    break;
                case 100:
                    [weakSelf AlertWithTitle:@"Lỗi mạng" Messenger:@"Kiểm tra lại kết nối internet" Butontitle:@"Ok"];
                    break;
                    
                default: [weakSelf AlertWithTitle:@"Lỗi" Messenger:@"Lỗi không xác định,  vui lòng thử lại" Butontitle:@"Ok"];
                    break;
            }
        }
    }];}

-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
