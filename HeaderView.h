//
//  HeaderView.h
//  FriendMaps
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface HeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgAva;
@property (weak, nonatomic) IBOutlet UILabel *lblAd;
@property (weak, nonatomic) IBOutlet UILabel *lblFriends;
-(void)setDataByUserData:(UserData*)userData;

@end
