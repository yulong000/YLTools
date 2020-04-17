//
//  YLAudioPlayer.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YLAudioPlayStatus) {
    YLAudioPlayStatusNone,              // 未开始
    YLAudioPlayStatusPreparing,         // 准备中
    YLAudioPlayStatusPlaying,           // 播放中
    YLAudioPlayStatusPause,             // 暂停
    YLAudioPlayStatusStop,              // 播放结束
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^YLAudioPlayerPlayHandler)(CGFloat progress, YLAudioPlayStatus playStatus);


// 音频播放器, 需要手动释放,否则会等到播放结束后才会自动释放 [self stop]
@interface YLAudioPlayer : NSObject

@property (nonatomic, copy)             YLAudioPlayerPlayHandler playHandler;
@property (nonatomic, assign, readonly) YLAudioPlayStatus playStatus;

/**  播放网络音频  */
- (void)playWithUrl:(NSString *)url;
/**  播放音频文件  */
- (void)playWithFileData:(NSData *)fileData;
/**  播放状态下,指定播放进度,(0~1)  */
- (void)playAtProgress:(CGFloat)progress;
- (void)play;
- (void)pause;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
