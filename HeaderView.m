//
//  HeaderView.m
//  FriendMaps
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setDataByUserData:(UserData *)userData {
    _imgAva.clipsToBounds = YES;
    _imgAva.layer.cornerRadius = 70/2;
    _imgAva.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgAva.layer.borderWidth = 1;
    _imgAva.image = userData.userImageAvatar;
    _lblAd.text = userData.userLocation;
    _lblFriends.text = [NSString stringWithFormat:@"%d bạn bè",userData.userFriends.count];
}

@end
