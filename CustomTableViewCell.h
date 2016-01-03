//
//  CustomTableViewCell.h
//  friendmap
//
//  Created by Đào Duy Quang  on 11/27/15.
//  Copyright © 2015 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataServices.h"

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgAvaCell;
@property (weak, nonatomic) IBOutlet UILabel *labelNameCell;
@property (weak, nonatomic) IBOutlet UILabel *labelAdCell;
@property (weak, nonatomic) IBOutlet UILabel *labelLastUpDated;
@property (weak, nonatomic) IBOutlet UILabel *labelKm;
@property (strong, nonatomic) DataServices *service;
@property (strong, nonatomic) CLLocation *mylocal;
-(void)setDataByEmail:(NSString*)email MyLocation:(CLLocation*)mylocal;
NSString* timeLeftSinceDate (NSDate * dateT);
@end
