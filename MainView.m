//
//  MainView.m
//  FriendMaps
//
//  Created by Đào Duy Quang  on 12/31/15.
//  Copyright © 2015 Đào Duy Quang . All rights reserved.
//

#import "MainView.h"

@interface MainView ()

@end

@implementation MainView

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(menuAction)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
    self.navigationItem.leftBarButtonItem = menuButton;
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self setupRefreshView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _service = [[DataServices alloc]init];
    _userData = [[UserData alloc]init];
    
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    _email = [data objectForKey:@"userData"];
    
    [self loadDataOnTheFirstTime:YES];
    // Do any additional setup after loading the view.
}
#pragma mark - Setup tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_userData.userFriends == nil) return 0;
    else return _userData.userFriends.count;
}

-(CustomTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setDataByEmail:_userData.userFriends[indexPath.row] MyLocation:_userData.userPoint];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showMap" sender:indexPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - AlertVoid
-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Setup refreshView
-(void)setupRefreshView{
    self.topRefreshControl  = [[UIRefreshControl alloc] init];
    [self.topRefreshControl addTarget:self action:@selector(refreshData)
                     forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.topRefreshControl];
    self.topRefreshControl.backgroundColor = [UIColor clearColor];
    self.topRefreshControl.tintColor = [UIColor orangeColor];
}

-(void)refreshData{
    [self loadDataOnTheFirstTime:NO];
    _tableView.userInteractionEnabled = NO;
}
#pragma mark - loadData
-(void)loadDataOnTheFirstTime:(BOOL)isFirstLoad
{
    if(isFirstLoad)
    {
        [_service updateLocationForEmail:_email completed:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (!error) {
                [_service getUserDataWithEmail:_email completed:^(UserData *userData, NSError *error) {
                    if(!error)
                    {
                        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                            if (currentInstallation.badge != 0) {
                                currentInstallation.badge = 0;
                                [currentInstallation saveEventually];
                            }
                        
                        _userData = userData;
                        if(_userData.userFriends.count == 0) [self AlertWithTitle:@"Thêm bạn bè" Messenger:@"Danh sách bạn bè hiện tại đang trống.\nẤn + để thêm bạn bè bằng Email.\nKéo danh sách bạn bè xuống để cập nhật thông tin." Butontitle:@"Ok"];
                        self.navigationItem.title = _userData.userName;
                        [_tableView reloadData];
                    }
                    else
                    {
                        switch (error.code) {
                            case 100:
                            {
                                [self AlertWithTitle:@"Lỗi mạng" Messenger:@"Kiểm tra lại kết nối internet" Butontitle:@"Ok"];
                                [_topRefreshControl endRefreshing];
                                _tableView.userInteractionEnabled = YES;
                                break;
                            }
                            default:
                            {
                                [_topRefreshControl endRefreshing];
                                _tableView.userInteractionEnabled = YES;
                                [self AlertWithTitle:@"Lỗi" Messenger:@"Lỗi không xác định, vui lòng thử lại" Butontitle:@"Ok"];
                                break;
                            }

                        }
                    }
                }];
            } else
            {
                switch (error.code) {
                    case 100:
                    {
                        [self AlertWithTitle:@"Lỗi mạng" Messenger:@"Kiểm tra lại kết nối internet" Butontitle:@"Ok"];
                        [_topRefreshControl endRefreshing];
                        _tableView.userInteractionEnabled = YES;
                        break;
                    }
                        
                    case 1:
                    {
                        [_service getUserDataWithEmail:_email completed:^(UserData *userData, NSError *error) {
                            if(!error)
                            {
                                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                if (currentInstallation.badge != 0) {
                                    currentInstallation.badge = 0;
                                    [currentInstallation saveEventually];
                                }
                                
                                _userData = userData;
                                if(_userData.userFriends.count == 0) [self AlertWithTitle:@"Thêm bạn bè" Messenger:@"Danh sách bạn bè hiện tại đang trống.\nẤn + để thêm bạn bè bằng Email.\nKéo danh sách bạn bè xuống để cập nhật thông tin." Butontitle:@"Ok"];
                                self.navigationItem.title = _userData.userName;
                                [_tableView reloadData];
                            }
                            else
                            {
                                switch (error.code) {
                                    case 100:
                                    {
                                        [self AlertWithTitle:@"Lỗi mạng" Messenger:@"Kiểm tra lại kết nối internet" Butontitle:@"Ok"];
                                        [_topRefreshControl endRefreshing];
                                        _tableView.userInteractionEnabled = YES;
                                        break;
                                    }
                                    default:
                                    {
                                        [self AlertWithTitle:@"Lỗi" Messenger:@"Lỗi không xác định, vui lòng thử lại" Butontitle:@"Ok"];
                                        [_topRefreshControl endRefreshing];
                                        _tableView.userInteractionEnabled = YES;
                                        break;
                                    }
                                }
                            }
                        }];
                        [self AlertWithTitle:@"Lỗi định vị" Messenger:@"Vui lòng bật Dịch Vụ Định Vị hoặc cho phép ứng dụng truy cập vị trí, nếu không vị trí của bạn sẽ không được cập nhật" Butontitle:@"Ok"];
                        break;
                    }
                        default:
                    {
                        [_topRefreshControl endRefreshing];
                        _tableView.userInteractionEnabled = YES;
                        [self AlertWithTitle:@"Lỗi" Messenger:@"Lỗi không xác định, vui lòng thử lại" Butontitle:@"Ok"];
                        break;
                    }
                        
                }

            }
        }];
            }
    else
    {
        [_service updateLocationForEmail:_email completed:^(NSError *error) {
            if (!error) {
                [_service getUserDataWithEmail:_email completed:^(UserData *userData, NSError *error) {
                    if(!error)
                    {
                        _userData = userData;
                        if(_userData.userFriends.count == 0) [self AlertWithTitle:@"Thêm bạn bè" Messenger:@"Danh sách bạn bè hiện tại đang trống.\nẤn + để thêm bạn bè bằng Email.\nKéo danh sách bạn bè xuống để cập nhật thông tin." Butontitle:@"Ok"];
                        self.navigationItem.title = _userData.userName;
                        [_tableView reloadData];
                        [_topRefreshControl endRefreshing];
                        _tableView.userInteractionEnabled = YES;
                    }
                    else
                    {
                        switch (error.code) {
                            case 100:
                            {
                                [self AlertWithTitle:@"Lỗi mạng" Messenger:@"Kiểm tra lại kết nối internet" Butontitle:@"Ok"];
                                [_topRefreshControl endRefreshing];
                                _tableView.userInteractionEnabled = YES;
                                break;
                            }
                                default:
                            {
                                [self AlertWithTitle:@"Lỗi" Messenger:@"Lỗi không xác định, vui lòng thử lại" Butontitle:@"Ok"];
                                [_topRefreshControl endRefreshing];
                                _tableView.userInteractionEnabled = YES;
                                break;
                            }
                        }
                    }
                }];
            } else
            {
                switch (error.code) {
                    case 100:
                    {
                    [self AlertWithTitle:@"Lỗi mạng" Messenger:@"Kiểm tra lại kết nối internet" Butontitle:@"Ok"];
                        [_topRefreshControl endRefreshing];
                        _tableView.userInteractionEnabled = YES;
                        break;
                    }
                        
                    case 1:
                    {
                        [_service getUserDataWithEmail:_email completed:^(UserData *userData, NSError *error) {
                            if(!error)
                            {
                                _userData = userData;
                                if(_userData.userFriends.count == 0) [self AlertWithTitle:@"Thêm bạn bè" Messenger:@"Danh sách bạn bè hiện tại đang trống.\nẤn + để thêm bạn bè bằng Email.\nKéo danh sách bạn bè xuống để cập nhật thông tin." Butontitle:@"Ok"];
                                self.navigationItem.title = _userData.userName;
                                [_tableView reloadData];
                                [_topRefreshControl endRefreshing];
                                _tableView.userInteractionEnabled = YES;
                            }
                            else
                            {
                                switch (error.code) {
                                    case 100:
                                    {
                                        [self AlertWithTitle:@"Lỗi mạng" Messenger:@"Kiểm tra lại kết nối internet" Butontitle:@"Ok"];
                                        [_topRefreshControl endRefreshing];
                                        _tableView.userInteractionEnabled = YES;
                                        break;
                                    }
                                    default:
                                    {
                                        [self AlertWithTitle:@"Lỗi" Messenger:@"Lỗi không xác định, vui lòng thử lại" Butontitle:@"Ok"];
                                        [_topRefreshControl endRefreshing];
                                        _tableView.userInteractionEnabled = YES;
                                        break;
                                    }
                                }
                            }
                        }];
                        [self AlertWithTitle:@"Lỗi định vị" Messenger:@"Vui lòng bật Dịch Vụ Định Vị hoặc cho phép ứng dụng truy cập vị trí, nếu không vị trí của bạn sẽ không được cập nhật" Butontitle:@"Ok"];
                        break;
                    }
                    default:
                    {
                        [self AlertWithTitle:@"Lỗi" Messenger:@"Lỗi không xác định, vui lòng thử lại" Butontitle:@"Ok"];
                        [_topRefreshControl endRefreshing];
                        _tableView.userInteractionEnabled = YES;
                        break;
                    }
                }
            }
        }];
    }
}
#pragma mark - Configure Button
-(void)menuAction
{
    UIAlertController *menu = [UIAlertController alertControllerWithTitle:@"" message:@"Thiết lập cài đặt" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [menu dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *setup = [UIAlertAction actionWithTitle:@"Cài Đặt" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:@"setting" sender:self];
         }];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"Đăng Xuất" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSUserDefaults *email = [NSUserDefaults standardUserDefaults];
        [email setObject:nil forKey:@"userData"];
        [email synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [menu addAction:setup];
    [menu addAction:logout];
    [menu addAction:cancel];
    [self presentViewController:menu animated:YES completion:nil];
}
-(void)addContact
{
    [self performSegueWithIdentifier:@"addFriend" sender:self];
}
#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"addFriend"])
    {
        AddFriend *add = segue.destinationViewController;
        add.myEmail = _userData.userEmail;
        add.myName = _userData.userName;
    }
    if([segue.identifier isEqualToString:@"showMap"])
    {
        NSIndexPath *index = (NSIndexPath*)sender;
        MapView *map = segue.destinationViewController;
        map.email = _userData.userFriends[index.row];
        map.myName = _userData.userName;
    }
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
