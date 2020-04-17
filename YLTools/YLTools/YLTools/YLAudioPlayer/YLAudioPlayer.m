//
//  YLAudioPlayer.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLAudioPlayer.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YLNetworkTools.h"

@interface YLAudioPlayer () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) YLAudioPlayStatus playStatus;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy)   NSString *url;
@property (nonatomic, copy)   NSString *filePath;

@property (nonatomic, strong) NSData *fileData;

@end

@implementation YLAudioPlayer

- (instancetype)init {
    if(self = [super init]) {
        __weak typeof(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:AVAudioSessionRouteChangeNotification object:self queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            NSDictionary *dic = note.userInfo;
            //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
            if ([dic[AVAudioSessionRouteChangeReasonKey] intValue] == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
                AVAudioSessionRouteDescription *routeDescription = dic[AVAudioSessionRouteChangePreviousRouteKey];
                AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
                //原设备为耳机则暂停
                if ([portDescription.portType isEqualToString:@"Headphones"]) {
                    [weakSelf pause];
                }
            }
        }];
    }
    return self;
}

- (AVAudioPlayer *)audioPlayer {
    if(_audioPlayer == nil) {
        NSError *error = nil;
        if(self.url.isValidString) {
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.filePath] error:&error];
        } else if (self.fileData.length) {
            _audioPlayer = [[AVAudioPlayer alloc] initWithData:self.fileData error:&error];
        } else {
            YLLog(@"未找到音频文件!");
            return nil;
        }
        _audioPlayer.numberOfLoops = 0;
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
        
        if(error) {
            YLLog(@"音频文件初始化失败!");
        }
    }
    return _audioPlayer;
}

- (void)dealloc {
    YLLog(@"YLAudioPlayer dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 下载并播放音频
- (void)playWithUrl:(NSString *)url {
    if(!([url isKindOfClass:[NSString class]] && ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]))) {
        return;
    }
    _url = url;
    if(_audioPlayer) {
        [self stop];
        _audioPlayer = nil;
    }
    
    __weak typeof(self) weakSelf = self;
    self.filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:url.lastPathComponent];
    if([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        // 本地已有缓存
        // 重新播放
        [weakSelf play];
    } else {
        // 第一次播放,先下载
        [YLNetworkTools downloadWithUrl:url filePath:self.filePath progress:^(float percent) {
            // 下载中
            weakSelf.playStatus = YLAudioPlayStatusPreparing;
            if(weakSelf.playHandler) {
                weakSelf.playHandler(0, YLAudioPlayStatusPreparing);
            }
        } success:^(NSDictionary * _Nonnull resp) {
            // 下载成功,开始播放
            [weakSelf play];
        } failure:^(NSString * _Nonnull error) {
            
        }];
    }
}

#pragma mark 直接播放音频
- (void)playWithFileData:(NSData *)fileData {
    if(fileData == nil || fileData.length == 0) {
        return;
    }
    _url = nil;
    
    if(_audioPlayer) {
        [self stop];
        _audioPlayer = nil;
    }
    _fileData = fileData;
    [self play];
}

#pragma mark 获取播放进度
- (void)displayLick:(CADisplayLink *)link {
    if(self.audioPlayer.duration && self.audioPlayer.isPlaying && self.playHandler) {
        float progress = self.audioPlayer.currentTime / self.audioPlayer.duration;
        if(progress < self.progress) {
            // 播放完毕
            [self stop];
        } else {
            self.progress = progress;
            self.playStatus = YLAudioPlayStatusPlaying;
            if(self.playHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.playHandler(progress, YLAudioPlayStatusPlaying);
                });
            }
        }
    } else {
        [self removeDisplayLink];
    }
}

#pragma mark 监听播放进度
- (void)addDisplayLink {
    if(self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLick:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

#pragma mark 移除播放监听
- (void)removeDisplayLink {
    if(self.displayLink) {
        [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        self.displayLink = nil;
    }
}

#pragma mark 开始播放
- (void)play {
    if(self.audioPlayer.isPlaying == NO) {
        [self.audioPlayer play];
        [self addDisplayLink];
        self.playStatus = YLAudioPlayStatusPlaying;
    }
}

#pragma mark 暂停播放
- (void)pause {
    if(self.audioPlayer.isPlaying) {
        [self.audioPlayer pause];
        [self removeDisplayLink];
        self.playStatus = YLAudioPlayStatusPause;
        if(self.playHandler) {
            self.playHandler(self.progress, YLAudioPlayStatusPause);
        }
    }
}

#pragma mark 停止播放
- (void)stop {
    self.progress = 0;
    if(self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
        [self removeDisplayLink];
        self.playStatus = YLAudioPlayStatusStop;
        if(self.playHandler) {
            self.playHandler(0, YLAudioPlayStatusStop);
        }
    }
}

#pragma mark 指定播放进度
- (void)playAtProgress:(CGFloat)progress {
    if(_audioPlayer == nil) return;
    self.progress = MIN(1, MAX(0, progress));
    [self removeDisplayLink];
    self.audioPlayer.currentTime = self.audioPlayer.duration * self.progress;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDisplayLink];
    });
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.playStatus = YLAudioPlayStatusStop;
    if(self.playHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.playHandler(0, YLAudioPlayStatusStop);
        });
    }
    [self.audioPlayer stop];
    [self removeDisplayLink];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [self stop];
}

@end
