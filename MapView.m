//
//  MapView.m
//  FriendMaps
//
//  Created by Đào Duy Quang  on 1/2/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "MapView.h"

@interface MapView ()

@end

@implementation MapView

- (void)viewDidLoad {
    _mapView.delegate = self;
    _service = [[DataServices alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIBarButtonItem *getButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(btnAction)];
    self.navigationItem.rightBarButtonItem = getButton;
    
    [_service getUserDataWithEmail:_email completed:^(UserData *userData, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            self.navigationItem.title = userData.userName;
            
            if(userData.userPoint.coordinate.longitude != 0 && userData.userPoint.coordinate.latitude != 0) {
            _img = userData.userImageAvatar;
            
            MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D myCoordinate;
            myCoordinate.latitude=userData.userPoint.coordinate.latitude;
            myCoordinate.longitude=userData.userPoint.coordinate.longitude;
            annotation.coordinate = myCoordinate;
            annotation.title = userData.userName;
            annotation.subtitle = userData.userLocation;
            [self.mapView addAnnotation:annotation];
            
            MKCoordinateSpan span = {.latitudeDelta =  0.05, .longitudeDelta =  0.05};
            MKCoordinateRegion region = {myCoordinate, span};
            [_mapView setRegion:region animated:YES];
            } else [self AlertWithTitle:@"Vị trí chưa sẵn sàng" Messenger:@"Vị trí của người dùng này chưa sẵn sàng để hiển thị trên bản đồ." Butontitle:@"Ok"];
        } else {
            switch (error.code) {
                case 100:
                    [self AlertWithTitle:@"Lỗi mạng" Messenger:@"Kiểm tra lại kết nối internet" Butontitle:@"Ok"];
                    break;
                    
                default:
                    [self AlertWithTitle:@"Lỗi" Messenger:@"Lỗi không xác định, vui lòng thử lại" Butontitle:@"Ok"];
                    break;
            }
        }
    }];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            imgView.image = _img;
            imgView.clipsToBounds = YES;
            imgView.layer.cornerRadius = 20;
            imgView.layer.borderWidth = 1.5;
            imgView.layer.borderColor = [UIColor redColor].CGColor;
            [pinView addSubview:imgView];
            pinView.canShowCallout = YES;
            pinView.calloutOffset = CGPointMake(0, 32);
            pinView.selected = YES;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

-(void)btnAction
{
    UIAlertController *opt = [UIAlertController alertControllerWithTitle:@"" message:@"Tuỳ Chọn" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [opt dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *push = [UIAlertAction actionWithTitle:@"Gửi Tin Ngắn" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIAlertController *pushView = [UIAlertController alertControllerWithTitle:@"Gửi Tin Ngắn" message:@"Gửi 1 thông báo đẩy với nội dung:" preferredStyle:UIAlertControllerStyleAlert];
        [pushView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Ví dụ: Đang ở đâu? Mở App lên ngay";
        }];
        UIAlertAction *send = [UIAlertAction actionWithTitle:@"Gửi" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *s = [NSString stringWithFormat:@"%@: %@",_myName,pushView.textFields[0].text];
            [_service pushNotificationToEmail:_email withAlert:s withIsBadge:YES];
        }];
        UIAlertAction *huy = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [pushView dismissViewControllerAnimated:YES completion:nil];
        }];
        [pushView addAction:huy];
        [pushView addAction:send];
        [self presentViewController:pushView animated:YES completion:nil];
    }];
    UIAlertAction *direct = [UIAlertAction actionWithTitle:@"Chỉ đường đến đây" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //Direction
    }];
    [opt addAction:push];
    [opt addAction:direct];
    [opt addAction:cancel];
    [self presentViewController:opt animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
