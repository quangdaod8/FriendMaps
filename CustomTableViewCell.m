//
//  CustomTableViewCell.m
//  friendmap
//
//  Created by Đào Duy Quang  on 11/27/15.
//  Copyright © 2015 Đào Duy Quang . All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
        _service = [[DataServices alloc]init];
    _imgAvaCell.layer.cornerRadius = 70/2;
    _imgAvaCell.clipsToBounds = YES;
    _imgAvaCell.layer.borderWidth = 0.5;
    _imgAvaCell.layer.borderColor = [UIColor orangeColor].CGColor;
    _labelAdCell.textColor = [UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataByEmail:(NSString *)email MyLocation:(CLLocation *)mylocal
{

    [_service getUserDataWithEmail:email completed:^(UserData *userData, NSError *error) {
        if(!error)
        {
            _imgAvaCell.image = userData.userImageAvatar;
            _labelNameCell.text = userData.userName;
            _labelAdCell.text = userData.userLocation;
            _labelLastUpDated.text = timeLeftSinceDate(userData.userUpdateAt);
            _labelKm.text = distance(userData.userPoint,mylocal);
        }
    }];
}

NSString* timeLeftSinceDate (NSDate * dateT)
{
    NSString *timeLeft;
    
    NSDate *today10am =[NSDate date];
    
    NSInteger seconds                = [today10am timeIntervalSinceDate:dateT];
    
    NSInteger days                   = (int) (floor(seconds / (3600 * 24)));
    if(days) seconds                 -= days * 3600 * 24;
    
    NSInteger hours                  = (int) (floor(seconds / 3600));
    if(hours) seconds                -= hours * 3600;
    
    NSInteger minutes                = (int) (floor(seconds / 60));
    if(minutes) seconds              -= minutes * 60;
    
    if(days) {
        timeLeft                         = [NSString stringWithFormat:@"%ld ngày trước", (long)days];
    }
    else if(hours) { timeLeft        = [NSString stringWithFormat: @"%ld giờ trước", (long)hours];
    }
    else if(minutes) { timeLeft      = [NSString stringWithFormat: @"%ld phút trước", (long)minutes];
    }
    else if(seconds)
        timeLeft                         = @"Online";
    return timeLeft;
}

NSString* distance (CLLocation * Point, CLLocation *mylocal)
{
    if((Point.coordinate.longitude == 0 && Point.coordinate.latitude == 0) || (mylocal.coordinate.longitude == 0 && mylocal.coordinate.latitude == 0)) return @"";
    else {
    CLLocationDistance dis           = [mylocal distanceFromLocation:Point];
    if(dis >= 1000) return([NSString stringWithFormat:@"Cách bạn %0.0f Km",dis/1000]);
    else return ([NSString stringWithFormat:@"Cách bạn %0.0f m",dis]);
    }
}

@end
