//
//  Setting.m
//  FriendMaps
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "Setting.h"

@interface Setting ()

@end

@implementation Setting

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *setup = [NSUserDefaults standardUserDefaults];
    _btnSeg.selectedSegmentIndex = [[setup valueForKey:@"time"] integerValue];
    
    
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
        NSUserDefaults *setup = [NSUserDefaults standardUserDefaults];
        [setup setValue:[NSNumber numberWithInteger:_btnSeg.selectedSegmentIndex] forKey:@"time"];
        [setup synchronize];
}
-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
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

@end
