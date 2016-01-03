//
//  DataServices.m
//  FriendMaps
//
//  Created by Đào Duy Quang  on 12/30/15.
//  Copyright © 2015 Đào Duy Quang . All rights reserved.
//

#import "DataServices.h"

@implementation DataServices
-(void)getUserDataWithEmail:(NSString *)email completed:(blockComplete)completed
{
    UserData *userData = [[UserData alloc]init];
    PFQuery *query                   = [PFQuery queryWithClassName:@"data"];
    [query whereKey:@"email" equalTo:email];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error)
        {
            userData.userName = object[@"name"];
            userData.userPassword = object[@"pass"];
            userData.userEmail = object[@"email"];
            userData.userLocation = object[@"place"];
            userData.userFriends = [NSMutableArray arrayWithArray:object[@"friends"]];
            userData.userUpdateAt = object.updatedAt;
            
            PFGeoPoint *point = [[PFGeoPoint alloc]init];
            point = object[@"point"];
            CLLocation *location = [[CLLocation alloc]initWithLatitude:point.latitude longitude:point.longitude];
            userData.userPoint = location;
            
            PFFile *file                     = [object objectForKey:@"imgava"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if(!error)
                {
                    userData.userImageAvatar         = [UIImage imageWithData:data];
                    completed(userData,nil);
                } else completed(userData,error);
            }];
        } else completed(nil,error);
    }];    
}

-(void)updateLocationForEmail:(NSString *)email completed:(blockDone)completed
{
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if(!error)
        {
            PFQuery *query                   = [PFQuery queryWithClassName:@"data"];
            [query whereKey:@"email" equalTo:email];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if(!error)
            {
                CLGeocoder *geocoder = [[CLGeocoder alloc]init];
                CLLocation *myLocation = [[CLLocation alloc]initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
                [geocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                    if (!error && [placemarks count] > 0) {
                        CLPlacemark *placemark = [[CLPlacemark alloc]initWithPlacemark:[placemarks lastObject]];
                        NSString *location = @"";
                        if(placemark.thoroughfare != nil)
                            location =  [location stringByAppendingString:[NSString stringWithFormat:@"%@, ",placemark.thoroughfare]];
                        if(placemark.subLocality != nil)
                            location = [location stringByAppendingString:[NSString stringWithFormat:@"%@, ",placemark.subLocality]];
                        if(placemark.locality != nil)
                            location = [location stringByAppendingString:[NSString stringWithFormat:@"%@, ",placemark.locality]];
                        if(placemark.subAdministrativeArea != nil)
                            location = [location stringByAppendingString:[NSString stringWithFormat:@"%@, ",placemark.subAdministrativeArea]];
                        if(placemark.administrativeArea != nil)
                            location = [location stringByAppendingString:[NSString stringWithFormat:@"%@. ",placemark.administrativeArea]];
                        object[@"place"] = location;
                        object[@"point"] = geoPoint;
                        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if(!error) {
                                NSLog(@"Location: %@",location);
                                completed(nil);
                            }else completed(error);
                        }];
                    }else completed(error);}];
            }
            else completed(error);
        }];
        }
        else completed(error);
    }];
}

-(void)signUpForEmail:(NSString *)email Name:(NSString *)name Password:(NSString *)password ImageAva:(UIImage *)image Completed:(blockEmailExist)completed
{
    PFQuery *query                   = [PFQuery queryWithClassName:@"data"];
    [query whereKey:@"email" equalTo:email];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error)
        {
            completed(YES,nil);
        }
        else if(error.code == 101)
        {
            PFObject *newUser = [[PFObject alloc]initWithClassName:@"data"];
            newUser[@"email"] = email;
            newUser[@"name"] = name;
            newUser[@"pass"] = password;
            newUser[@"place"] = @"Vị trí chưa sẵn sàng.";
            NSData *imageData = UIImageJPEGRepresentation(image,0.5f);
            PFFile *file = [PFFile fileWithData:imageData];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded)
                {
                    [newUser setObject:file forKey:@"imgava"];
                    [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded) completed(NO,nil); else completed(NO,error);
                    }];
                }
                else completed(NO,error);
            }];
        }
        else completed(NO,error);
    }];
}
-(void)addFriendFromMyEmail:(NSString *)myEmail toEmail:(NSString *)email Completed:(blockAddFriendOk)completed
{
    PFQuery *query                   = [PFQuery queryWithClassName:@"data"];
    [query whereKey:@"email" equalTo:myEmail];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error)
        {
        NSMutableArray *friends = [NSMutableArray arrayWithArray:object[@"friends"]];
        if(friends.count > 0) {
        BOOL isFriend = NO;
            
            for(int i = 0; i < friends.count; i++)
            {
                if([friends[i] isEqualToString:email]) {
                    isFriend = YES;
                    NSError *loi = [NSError errorWithDomain:@"Domain" code:123 userInfo:nil];
                    completed(loi);
                    break;
                }
            }
                if(!isFriend) {
                    [friends addObject:email];
                    object[@"friends"] = friends;
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded && !error) {
                            [query whereKey:@"email" equalTo:email];
                            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                if(!error) {
                                    NSMutableArray *toFriend = [[NSMutableArray alloc]initWithArray:object[@"friends"]];
                                    [toFriend addObject:myEmail];
                                    object[@"friends"] = toFriend;
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        if(succeeded && !error) completed(nil);
                                        else completed(error);
                                    }];
                                } else completed(error);
                            }];
                        }
                        else completed(error);
                    }];
                }
            } else {
                [friends addObject:email];
                object[@"friends"] = friends;
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(succeeded && !error) {
                        [query whereKey:@"email" equalTo:email];
                        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                            if(!error) {
                                NSMutableArray *toFriend = [[NSMutableArray alloc]initWithArray:object[@"friends"]];
                                [toFriend addObject:myEmail];
                                object[@"friends"] = toFriend;
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                    if(succeeded && !error) completed(nil);
                                    else completed(error);
                                }];
                            } else completed(error);
                        }];
                    }
                    else completed(error);
                }];
            }
        } else completed(error);
    }];
}

-(void)pushNotificationToEmail:(NSString *)email withAlert:(NSString *)alert withIsBadge:(BOOL) isBadge
{
    PFQuery *query = [PFInstallation query];
    [query whereKey:@"email" equalTo:email];
    PFPush *push = [[PFPush alloc]init];
    [push setQuery:query];
    NSDictionary *data1 = @{ @"alert" : alert , @"badge" : @"Increment" };
    NSDictionary *data2 = @{ @"alert" : alert };
    if(isBadge) [push setData:data1]; else [push setData:data2];
    [push sendPushInBackground];
}
@end
