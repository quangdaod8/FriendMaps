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
    _userData = [[UserData alloc]init];
    PFQuery *query                   = [PFQuery queryWithClassName:@"data"];
    [query whereKey:@"email" equalTo:email];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error)
        {
            _userData.userName = object[@"name"];
            _userData.userPassword = object[@"pass"];
            _userData.userEmail = object[@"email"];
            _userData.userLocation = object[@"place"];
            _userData.userFriends = [NSMutableArray arrayWithArray:object[@"friends"]];
            _userData.userUpdateAt = object.updatedAt;
            
            PFGeoPoint *point = [[PFGeoPoint alloc]init];
            point = object[@"point"];
            CLLocation *location = [[CLLocation alloc]initWithLatitude:point.latitude longitude:point.longitude];
            _userData.userPoint = location;
            
            PFFile *file                     = [object objectForKey:@"imgava"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if(!error)
                {
                    _userData.userImageAvatar         = [UIImage imageWithData:data];
                    completed(_userData,nil);
                } else completed(_userData,error);
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
                _location = @"";
                CLGeocoder *geocoder = [[CLGeocoder alloc]init];
                CLLocation *myLocation = [[CLLocation alloc]initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
                [geocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                    if (error == nil && [placemarks count] > 0) {
                        _placemark                        = [placemarks lastObject];

                        if(_placemark.thoroughfare != nil)
                            _location =  [_location stringByAppendingString:[NSString stringWithFormat:@"%@, ",_placemark.thoroughfare]];
                        if(_placemark.subLocality != nil)
                            _location = [_location stringByAppendingString:[NSString stringWithFormat:@"%@, ",_placemark.subLocality]];
                        if(_placemark.locality != nil)
                            _location = [_location stringByAppendingString:[NSString stringWithFormat:@"%@, ",_placemark.locality]];
                        if(_placemark.subAdministrativeArea != nil)
                            _location = [_location stringByAppendingString:[NSString stringWithFormat:@"%@, ",_placemark.subAdministrativeArea]];
                        if(_placemark.administrativeArea != nil)
                            _location = [_location stringByAppendingString:[NSString stringWithFormat:@"%@. ",_placemark.administrativeArea]];
                        object[@"place"] = _location;
                        NSLog(@"Location: %@",_location);
                        object[@"point"] = geoPoint;
                        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if(succeeded) completed(true,nil);
                        }];

                    }else completed(true,error);}];
            }
            else completed(true,error);
        }];
        }
        else completed(true,error);
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
-(void)addFriendFromMyEmail:(NSString *)myEmail toEmail:(NSString *)email Completed:(blockFriendExist)completed
{
    PFQuery *query                   = [PFQuery queryWithClassName:@"data"];
    [query whereKey:@"email" equalTo:myEmail];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error)
        {
            NSMutableArray *friends = [NSMutableArray arrayWithArray:object[@"friends"]];
            if(friends.count > 0)
            {
            for(int i = 0; i < friends.count; i++)
            {
                if([friends[i] isEqualToString:email]) {
                    completed(YES,nil);
                    break;
                } else if( i == friends.count - 1) {
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
                                        if(succeeded && !error) completed(NO,nil);
                                        else completed(NO,error);
                                    }];
                                } else completed(NO,error);
                            }];
                        }
                        else completed(NO,error);
                    }];
                }
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
                                    if(succeeded && !error) completed(NO,nil);
                                    else completed(NO,error);
                                }];
                            } else completed(NO,error);
                        }];
                    }
                    else completed(NO,error);
                }];
            }
        } else completed(NO,error);
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
-(void)getListFriendsWithEmail:(NSString *)email completed:(blockGetList)completed
{
    [self getUserDataWithEmail:email completed:^(UserData *userData, NSError *error) {
        if(!error) {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            int n = userData.userFriends.count;
            __block int i = 0;
            while(i < n)
            {
                [self getUserDataWithEmail:userData.userFriends[i] completed:^(UserData *userData, NSError *error) {
                    if(!error) {
                        [array addObject:userData];
                        i++;
                        if(i == n) completed(array,nil);
                    } else completed(nil,error);
                }];
            }
        } else completed(nil,error);
    }];
}
@end
