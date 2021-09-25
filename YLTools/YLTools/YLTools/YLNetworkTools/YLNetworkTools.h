//
//  YLNetworkTools.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**  请求成功  */
typedef void (^YLNetworkSuccessHandler)(NSDictionary *resp);

/**  请求失败  */
typedef void (^YLNetworkFailureHandler)(NSString *error, int errorCode);

/**  下载文件进度  */
typedef void (^YLNetworkQownloadHandler)(float percent);

@class YLFormData;
@interface YLNetworkTools : NSObject

/**
 发送一个GET请求, 不带参数
 
 @param url 请求路径
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url
           success:(YLNetworkSuccessHandler _Nullable)success
           failure:(YLNetworkFailureHandler _Nullable)failure;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url
            params:(NSDictionary * _Nullable)params
           success:(YLNetworkSuccessHandler _Nullable)success
           failure:(YLNetworkFailureHandler _Nullable)failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url
             params:(NSDictionary * _Nullable)params
            success:(YLNetworkSuccessHandler _Nullable)success
            failure:(YLNetworkFailureHandler _Nullable)failure;

/**
 *  发送一个POST请求(上传文件数据)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formDataArray  文件参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url
             params:(NSDictionary * _Nullable)params
      formDataArray:(NSArray<YLFormData *> *)formDataArray
            success:(YLNetworkSuccessHandler _Nullable)success
            failure:(YLNetworkFailureHandler _Nullable)failure;

/**
 发送一个PUT请求
 
 @param url     请求路径
 @param params  请求参数
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)putWithURL:(NSString *)url
            params:(NSDictionary * _Nullable)params
           success:(YLNetworkSuccessHandler _Nullable)success
           failure:(YLNetworkFailureHandler _Nullable)failure;

/**
 发送一个DELETE请求
 
 @param url     请求路径
 @param params  请求参数
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)deleteWithURL:(NSString *)url
               params:(NSDictionary * _Nullable)params
              success:(YLNetworkSuccessHandler _Nullable)success
              failure:(YLNetworkFailureHandler _Nullable)failure;

/**
 *  下载文件
 *
 *  @param urlString 文件资源的全路径
 *  @param filePath  下载后存放的全路径
 *  @param progress  进度百分比
 *  @param success   成功后返回的数据
 *  @param failure   下载失败返回错误信息
 */
+ (void)downloadWithUrl:(NSString *)urlString
               filePath:(NSString *)filePath
               progress:(YLNetworkQownloadHandler _Nullable)progress
                success:(YLNetworkSuccessHandler _Nullable)success
                failure:(YLNetworkFailureHandler _Nullable)failure;

@end

/**
 *  用来封装文件数据的模型
 */
@interface YLFormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy)   NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy)   NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy)   NSString *mimeType;

/**  图片, 有可能为nil  */
+ (instancetype)formDataWithImage:(UIImage *)image;
+ (NSArray <YLFormData *> *)formDataWithImages:(NSArray <UIImage *> *)images;

/**  视频, 有可能为nil  */
+ (instancetype)formDataWithVideo:(NSData *)videoData;
+ (NSArray <YLFormData *> *)formDataWithVideos:(NSArray <NSData *> *)videos;

/**  音频, 有可能为nil */
+ (instancetype)formDataWithAudio:(NSData *)audioData;
@end

NS_ASSUME_NONNULL_END
