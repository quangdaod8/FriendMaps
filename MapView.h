//
//  MapView.h
//  FriendMaps
//
//  Created by Đào Duy Quang  on 1/2/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataServices.h"
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>

@interface MapView : UIViewController<MKMapViewDelegate>
@property(strong, nonatomic) DataServices *service;
@property(strong, nonatomic) NSString* email;
@property(strong, nonatomic) NSString* myName;
@property(strong,nonatomic) NSString* toName;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UIImage *img;
@property(strong, nonatomic) CLLocation *userLocation;
@end
