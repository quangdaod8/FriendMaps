//
//  DataServices.h
//  FriendMaps
//
//  Created by Đào Duy Quang  on 12/30/15.
//  Copyright © 2015 Đào Duy Quang . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserData.h"
#import <Parse/Parse.h>

typedef void (^blockComplete) (UserData* userData, NSError* error);
typedef void (^blockDone) (BOOL done,NSError* error);
typedef void (^blockEmailExist) (BOOL isEmailExist,NSError* error);
typedef void (^blockFriendExist) (BOOL isFriendAlready, NSError* error);
typedef void  (^blockGetList) (NSMutableArray* arrayOfFriend,NSError *error);

@interface DataServices : NSObject
@property (nonatomic, strong) UserData *userData;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) NSString *location;
-(void)getUserDataWithEmail: (NSString*) email  completed:(blockComplete) completed;
-(void)updateLocationForEmail: (NSString*)email completed:(blockDone) completed;
-(void)signUpForEmail:(NSString*)email Name:(NSString*)name Password:(NSString*)password ImageAva:(UIImage*)image Completed:(blockEmailExist)completed;
-(void)addFriendFromMyEmail:(NSString *)myEmail toEmail:(NSString *)email Completed:(blockFriendExist)completed;
-(void)pushNotificationToEmail:(NSString *)email withAlert:(NSString *)alert withIsBadge:(BOOL) isBadge;
-(void)getListFriendsWithEmail:(NSString*)email completed:(blockGetList) completed;
@end
