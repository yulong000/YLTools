//
//  LocationDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/9/2.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "LocationDemoVC.h"
#import "YLLocationTools.h"

@interface LocationDemoVC ()

@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation LocationDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.textAlignment = NSTextAlignmentCenter;
    self.addressLabel.font = Font(15);
    self.addressLabel.size = CGSizeMake(300, 200);
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.centerX = self.view.centerPoint.x;
    self.addressLabel.top = kNavTotalHeight + 30;
    [self.view addSubview:self.addressLabel];
    
    __weak typeof(self) weakSelf = self;
    UIButton *addressBtn = [UIButton buttonWithTitle:@"获取定位" clickBlock:^(UIButton *button) {
        /*
        // 获取单次定位
        [YLLocationTools getLocationAddressCompletionBlock:^(CLLocation * _Nonnull location, AMapLocationReGeocode * _Nullable regeocode, NSError * _Nullable error) {
            weakSelf.addressLabel.text = [NSString stringWithFormat:@"获取到定位:\n%@\nlog : %f  lat : %f\n%@ %@ %@ %@ %@", regeocode.formattedAddress, location.coordinate.longitude, location.coordinate.latitude, regeocode.province, regeocode.city, regeocode.district, regeocode.street, regeocode.POIName];
        }];
         */
        
        // 持续定位
        [YLLocationTools startUpdatingLocationWith:kCLDistanceFilterNone resultBlock:^(CLLocation * _Nonnull location, AMapLocationReGeocode * _Nullable regeocode, NSError * _Nullable error) {
            weakSelf.addressLabel.text = [NSString stringWithFormat:@"持续定位:\n%@\nlog : %f  lat : %f\n%@ %@ %@ %@ %@", regeocode.formattedAddress, location.coordinate.longitude, location.coordinate.latitude, regeocode.province, regeocode.city, regeocode.district, regeocode.street, regeocode.POIName];
        }];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addressBtn];
}

- (void)dealloc {
    [YLLocationTools stopUpdateingLocation];
}

@end
