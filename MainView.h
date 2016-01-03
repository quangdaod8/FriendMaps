//
//  MainView.h
//  FriendMaps
//
//  Created by Đào Duy Quang  on 12/31/15.
//  Copyright © 2015 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"
#import "DataServices.h"
#import "MBProgressHUD.h"
#import "Login.h"
#import "CustomTableViewCell.h"
#import "SignUp.h"
#import "AddFriend.h"
#import "MapView.h"


@interface MainView : UIViewController<UITableViewDataSource,UITableViewDelegate>;
@property(strong, nonatomic) NSMutableArray *userArray;
@property(nonatomic, strong) UserData *userData;
@property(nonatomic,strong) DataServices *service;
@property(nonatomic,strong) NSString *email;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) UIRefreshControl *topRefreshControl;

@end
