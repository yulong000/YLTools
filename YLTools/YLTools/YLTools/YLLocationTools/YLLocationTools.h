//
//  YLLocationTools.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

NS_ASSUME_NONNULL_BEGIN

// 定位成功 返回location, 逆地址解析失败, regeocode = nil
typedef void(^YLLocationResultBlock)(CLLocation * _Nullable location, AMapLocationReGeocode * _Nullable regeocode, NSError * _Nullable error);

@interface YLLocationTools : NSObject

/**  获取单次定位信息  */
+ (void)getLocationAddressCompletionBlock:(YLLocationResultBlock _Nullable)resultBlock;

/**  开启持续定位 meter:最小更新距离(米),默认为 kCLDistanceFilterNone,表示只要检测到设备位置发生变化就会更新位置信息  */
+ (void)startUpdatingLocationWith:(CLLocationDistance)meter resultBlock:(YLLocationResultBlock _Nullable)resultBlock;
/**  关闭持续定位  */
+ (void)stopUpdateingLocation;

@end

NS_ASSUME_NONNULL_END
