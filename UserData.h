//
//  UserData.h
//  FriendMaps
//
//  Created by Đào Duy Quang  on 12/30/15.
//  Copyright © 2015 Đào Duy Quang . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface UserData : NSObject
@property (nonatomic, strong) NSString        *userName;
@property (nonatomic, strong) NSString        *userEmail;
@property (nonatomic, strong) NSString        *userPassword;
@property (nonatomic, strong) NSString        *userLocation;
@property (nonatomic, strong) CLLocation      *userPoint;
@property (nonatomic, strong) UIImage         *userImageAvatar;
@property (nonatomic, strong) NSMutableArray  *userFriends;
@property (nonatomic, strong) NSDate          *userUpdateAt;
@end
