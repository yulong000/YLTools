//
//  YLNetworkTools.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLNetworkTools.h"
#import "AFNetworking.h"

// 网络连接超时时间
#define kNetworkRequestTimeoutInterval  10.0
#define Web_app_update                  @""

@implementation YLNetworkTools
+ (instancetype)shareInstance {
    static YLNetworkTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[YLNetworkTools alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable: {
                    YLLog(@"网络已断开");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi: {
                    YLLog(@"已切换到WiFi");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN: {
                    YLLog(@"已切换到手机网络");
                }
                    break;
                default:
                    YLLog(@"未知网络");
                    break;
            }
        }];
    });
    return tools;
}

+ (void)getWithURL:(NSString *)url success:(YLNetworkSuccessHandler)success failure:(YLNetworkFailureHandler)failure {
    [self getWithURL:url params:nil success:success failure:failure];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(YLNetworkSuccessHandler)success failure:(YLNetworkFailureHandler)failure {
    // 网络未连接,直接返回失败
    if([[YLNetworkTools shareInstance] connectNetWorkWithFailureHandler:failure] == NO)   return;
    
    // 请求参数设置
    AFHTTPSessionManager *mgr = [self createManager];
    params = [self requestPararmsWithDict:params];
    [mgr GET:url parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YLLog(@"\nget url : %@\nparams : %@\nresponse : %@",url, params, responseObject);
        int code = [responseObject[@"code"] intValue];
        if(code < 300) {
            if(success) success(responseObject);
        } else if(code == 401) {
            // 重新登录
            if(failure) {
                failure(@"请先登录", code);
            }
        } else {
            if(failure) failure(responseObject[@"error"], code);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YLLog(@"\nget url : %@\nparams : %@\nerror : %@",url, params, error.userInfo);
        if(failure) failure(error.localizedDescription, (int)error.code);
    }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(YLNetworkSuccessHandler)success failure:(YLNetworkFailureHandler)failure {
    // 网络未连接,直接返回失败
    if([[YLNetworkTools shareInstance] connectNetWorkWithFailureHandler:failure] == NO)   return;
    
    // 请求参数设置
    AFHTTPSessionManager *mgr = [self createManager];
    if([url isEqualToString:Web_app_update] == NO) {
        params = [self requestPararmsWithDict:params];
    }
    [mgr POST:url parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YLLog(@"\npost url : %@\nparams : %@\nresponse : %@",url, params, responseObject);
        int code = [responseObject[@"code"] intValue];
        if(code < 300 || [url isEqualToString:Web_app_update]) {
            if(success) success(responseObject);
        } else if(code == 401) {
            // 重新登录
            if(failure) {
                failure(@"请先登录", code);
            }
        } else {
            if(failure) failure(responseObject[@"error"], code);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YLLog(@"\npost url : %@\nparams : %@\nerror : %@",url, params, error.userInfo);
        if(failure) failure(error.localizedDescription, (int)error.code);
    }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray<YLFormData *> *)formDataArray success:(YLNetworkSuccessHandler)success failure:(YLNetworkFailureHandler)failure {
    // 网络未连接,直接返回失败
    if([[YLNetworkTools shareInstance] connectNetWorkWithFailureHandler:failure] == NO)   return;
    
    // 请求参数设置
    AFHTTPSessionManager *mgr = [self createManager];
    params = [self requestPararmsWithDict:params];
    [mgr POST:url parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 拼接数据
        for (YLFormData *data in formDataArray) {
            [formData appendPartWithFileData:data.data name:data.name fileName:data.filename mimeType:data.mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YLLog(@"\npost url : %@\nparams : %@\nresponse : %@",url, params, responseObject);
        int code = [responseObject[@"code"] intValue];
        if([responseObject isKindOfClass:[NSArray class]]) {
            if(success) success(responseObject);
        } else {
            if(code < 300) {
                if(success) success(responseObject);
            } else if(code == 401) {
                // 重新登录
                if(failure) {
                    failure(@"请先登录", code);
                }
            }  else {
                if(failure) failure(responseObject[@"error"], code);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YLLog(@"\npost url : %@\nparams : %@\nerror : %@",url, params, error.userInfo);
        if(failure) failure(error.localizedDescription, (int)error.code);
    }];
}

+ (void)putWithURL:(NSString *)url params:(NSDictionary *)params success:(YLNetworkSuccessHandler)success failure:(YLNetworkFailureHandler)failure {
    // 网络未连接,直接返回失败
    if([[YLNetworkTools shareInstance] connectNetWorkWithFailureHandler:failure] == NO)   return;
    
    // 请求参数设置
    AFHTTPSessionManager *mgr = [self createManager];
    params = [self requestPararmsWithDict:params];
    [mgr PUT:url parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YLLog(@"\nput url : %@\nparams : %@\nresponse : %@",url, params, responseObject);
        int code = [responseObject[@"code"] intValue];
        if(code < 300) {
            if(success) success(responseObject);
        } else if(code == 401) {
            // 重新登录
            if(failure) {
                failure(@"请先登录", code);
            }
        } else {
            if(failure) failure(responseObject[@"error"], code);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YLLog(@"\nput url : %@\nparams : %@\nerror : %@",url, params, error.userInfo);
        if(failure) failure(error.localizedDescription, (int)error.code);
    }];
}

+ (void)deleteWithURL:(NSString *)url params:(NSDictionary *)params success:(YLNetworkSuccessHandler)success failure:(YLNetworkFailureHandler)failure {
    // 网络未连接,直接返回失败
    if([[YLNetworkTools shareInstance] connectNetWorkWithFailureHandler:failure] == NO)   return;
    
    // 请求参数设置
    AFHTTPSessionManager *mgr = [self createManager];
    params = [self requestPararmsWithDict:params];
    [mgr DELETE:url parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YLLog(@"\ndelete url : %@\nparams : %@\nresponse : %@",url, params, responseObject);
        int code = [responseObject[@"code"] intValue];
        if(code < 300) {
            if(success) success(responseObject);
        } else if(code == 401) {
            // 重新登录
            if(failure) {
                failure(@"请先登录", code);
            }
        } else {
            if(failure) failure(responseObject[@"error"], code);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YLLog(@"\ndelete url : %@\nparams : %@\nerror : %@",url, params, error.userInfo);
        if(failure) failure(error.localizedDescription, (int)error.code);
    }];
}

+ (void)downloadWithUrl:(NSString *)urlString filePath:(NSString *)filePath progress:(YLNetworkQownloadHandler)progress success:(YLNetworkSuccessHandler)success failure:(YLNetworkFailureHandler)failure {
    // 网络未连接,直接返回失败
    if([[YLNetworkTools shareInstance] connectNetWorkWithFailureHandler:failure] == NO)   return;
    if(urlString == nil)    return;
    
    // 请求参数设置
    NSFileManager *mng = [NSFileManager defaultManager];
    if([mng fileExistsAtPath:[filePath stringByDeletingLastPathComponent]] == NO) {
        if([mng createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:NULL]) {
            YLLog(@"创建文件夹成功 -- %@", filePath.stringByDeletingLastPathComponent);
        }
    }
    //初始化队列
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDownloadTask *task = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        float pro = downloadProgress.completedUnitCount * 1.0 / downloadProgress.totalUnitCount;
        if(progress)    progress(pro);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(error == nil) {
            if(success) success(@{@"downloadUrl" : urlString});
        } else {
            if(failure) failure(error.localizedDescription, (int)error.code);
        }
    }];
    [task resume];
}

#pragma 设置请求
+ (AFHTTPSessionManager *)createManager {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.requestSerializer.timeoutInterval = kNetworkRequestTimeoutInterval;
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"iOS-%@", [UIDevice currentDevice].systemVersion] forHTTPHeaderField:@"systemVersion"];
    [mgr.requestSerializer setValue:kAPP_Version forHTTPHeaderField:@"appVersion"];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    return mgr;
}

#pragma mark 请求参数
+ (NSDictionary *)requestPararmsWithDict:(NSDictionary *)dict {
    NSMutableDictionary *params;
    if(dict) {
        params = [NSMutableDictionary dictionaryWithDictionary:dict];
    } else {
        params = [NSMutableDictionary dictionary];
    }
    // 需要添加公共请求参数, 在这里添加
    return params;
}

#pragma mark 检测网络状态
- (BOOL)connectNetWorkWithFailureHandler:(YLNetworkFailureHandler)failure {
    BOOL flag = YES;
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:       flag = NO;  YLLog(@"无网络");    break;
        case AFNetworkReachabilityStatusReachableViaWiFi:   flag = YES; YLLog(@"WiFi");     break;
        case AFNetworkReachabilityStatusReachableViaWWAN:   flag = YES; YLLog(@"手机网络");   break;
        default:                                            flag = YES; YLLog(@"未知网络");   break;
    }
    if(flag == NO && failure) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:@{NSLocalizedDescriptionKey : @"无网络连接"}];
        failure(error.localizedDescription, 404);
    }
    return flag;
}

@end


@implementation YLFormData

+ (instancetype)formDataWithImage:(UIImage *)image {
    if(image == nil)    return nil;
    NSData *data = UIImageJPEGRepresentation(image, 0);
    if(data.length == 0)    return nil;
    YLFormData *formData = [[YLFormData alloc] init];
    formData.filename = @"image.jpg";
    formData.name = @"file";
    formData.data = UIImageJPEGRepresentation(image, 0);
    formData.mimeType = @"image/jpeg";
    return formData;
}

+ (instancetype)formDataWithAudio:(NSData *)audioData {
    if(audioData.length == 0)   return nil;
    YLFormData *formData = [[YLFormData alloc] init];
    formData.filename = @"audio.wav";
    formData.name = @"file";
    formData.data = audioData;
    formData.mimeType = @"audio/mpeg";
    return formData;
}

+ (instancetype)formDataWithVideo:(NSData *)videoData {
    if(videoData.length == 0)   return nil;
    YLFormData *formData = [[YLFormData alloc] init];
    formData.filename = @"video.mp4";
    formData.name = @"file";
    formData.data = videoData;
    formData.mimeType = @"video/mp4";
    return formData;
}

+ (NSArray <YLFormData *> *)formDataWithImages:(NSArray<UIImage *> *)images{
    NSMutableArray *arr = [NSMutableArray array];
    for (UIImage *img in images) {
        YLFormData *data = [YLFormData formDataWithImage:img];
        if(data) {
            [arr addObject:data];
        }
    }
    return arr;
}

+ (NSArray <YLFormData *> *)formDataWithVideos:(NSArray<NSData *> *)videos {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSData *data in videos) {
        YLFormData *formData = [YLFormData formDataWithVideo:data];
        if(formData) {
            [arr addObject:formData];
        }
    }
    return arr;
}

@end

