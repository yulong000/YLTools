//
//  YLLocationTools.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLLocationTools.h"

@interface YLLocationTools () <AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *manager;
@property (nonatomic, copy  ) YLLocationResultBlock resultBlock;

@end

@implementation YLLocationTools

+ (instancetype)shareInstance {
    static YLLocationTools *manager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        manager = [[YLLocationTools alloc] init];
        manager.manager = [[AMapLocationManager alloc] init];
        manager.manager.allowsBackgroundLocationUpdates = YES;
        manager.manager.delegate = manager;
        [manager.manager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    });
    return manager;
}

#pragma mark 请求定位权限
+ (BOOL)requestLocation {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if([CLLocationManager locationServicesEnabled] == NO || status < 2) {
        // 定位无法使用
        [MBProgressHUD showText:@"当前定位无法使用!"];
        return NO;
    }
    if (status == kCLAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"请开启定位权限来获得更好的体验" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *setting = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alert addAction:cancel];
        [alert addAction:setting];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
}

#pragma mark 单次定位
+ (void)getLocationAddressCompletionBlock:(YLLocationResultBlock)resultBlock {
    YLLocationTools *manager = [self shareInstance];
    if([manager.manager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if(location == nil && error) {
            if(error.code == AMapLocationErrorLocateFailed) {
                [YLLocationTools requestLocation];
            }
            if(resultBlock) {
                resultBlock(nil, nil, error);
            }
            YLLog(@"定位失败 : %@", error.userInfo);
        } else if (location) {
            YLLog(@"定位成功 longitude : %f, latitude : %f", location.coordinate.longitude, location.coordinate.latitude);
            // 定位成功
            if(regeocode && regeocode.province.isValidString && regeocode.city.isValidString && regeocode.district.isValidString) {
                // 逆地址解析成功
                YLLog(@"逆地址解析成功 : %@ %@ %@, 详细地址 : %@", regeocode.province, regeocode.city, regeocode.district, regeocode.formattedAddress);
                
                if(resultBlock) {
                    resultBlock(location, regeocode, nil);
                }
            } else {
                // 解析失败,只返回坐标
                YLLog(@"解析逆地址失败");
                if(resultBlock) {
                    resultBlock(location, nil, nil);
                }
            }
        }
    }] == NO) {
        YLLog(@"获取单次定位失败");
    }
}

+ (void)startUpdatingLocationWith:(CLLocationDistance)meter resultBlock:(YLLocationResultBlock)resultBlock {
    YLLocationTools *manager = [self shareInstance];
    manager.resultBlock = resultBlock;
    manager.manager.distanceFilter = meter;    // 最小更新距离
    manager.manager.locatingWithReGeocode = YES; // 持续定位返回逆地址信息
    [manager.manager startUpdatingLocation];
}

+ (void)stopUpdateingLocation {
    YLLocationTools *manager = [self shareInstance];
    [manager.manager stopUpdatingLocation];
    YLLog(@"关闭持续定位");
}

#pragma mark AMapLocationManager delegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    if(self.resultBlock) {
        self.resultBlock(location, reGeocode, nil);
    }
    YLLog(@"定位成功 longitude : %f, latitude : %f", location.coordinate.longitude, location.coordinate.latitude);
    YLLog(@"逆地址解析 : %@ %@ %@ %@ %@, 详细地址 : %@", reGeocode.province, reGeocode.city, reGeocode.district, reGeocode.street, reGeocode.POIName, reGeocode.formattedAddress);
}

#pragma mark 定位失败
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    if(self.resultBlock) {
        self.resultBlock(nil, nil, error);
    }
    YLLog(@"定位失败 : %@", error.userInfo);
}

@end
