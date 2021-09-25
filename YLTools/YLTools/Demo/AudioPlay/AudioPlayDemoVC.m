//
//  AudioPlayDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/9/9.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "AudioPlayDemoVC.h"
#import "YLAudioPlayer.h"

@interface AudioPlayDemoVC ()

@property (nonatomic, strong) YLAudioPlayer *player;

@property (nonatomic, strong) UILabel *progressLabel;

@end

@implementation AudioPlayDemoVC

- (YLAudioPlayer *)player {
    if(_player == nil) {
        __weak typeof(self) weakSelf = self;
        _player = [[YLAudioPlayer alloc] init];
        _player.playHandler = ^(CGFloat progress, YLAudioPlayStatus playStatus) {
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"播放进度 : %f", progress];
        };
    }
    return _player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 200, 30)];
    self.progressLabel.textColor = RedColor;
    self.progressLabel.font = Font(15);
    [self.view addSubview:self.progressLabel];
    
    __weak typeof(self) weakSelf = self;
    UIButton *btn1 = [UIButton buttonWithTitle:@"跳转到20%" clickBlock:^(UIButton *button) {
        [weakSelf.player playAtProgress:0.2];
    }];
    btn1.backgroundColor = GrayColor;
    [btn1 setTitleColor:WhiteColor forState:UIControlStateNormal];
    btn1.titleLabel.font = Font(14);
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithTitle:@"跳转到50%" clickBlock:^(UIButton *button) {
        [weakSelf.player playAtProgress:0.5];
    }];
    btn2.backgroundColor = GrayColor;
    [btn2 setTitleColor:WhiteColor forState:UIControlStateNormal];
    btn2.titleLabel.font = Font(14);
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithTitle:@"跳转到80%" clickBlock:^(UIButton *button) {
        [weakSelf.player playAtProgress:0.8];
    }];
    btn3.backgroundColor = GrayColor;
    [btn3 setTitleColor:WhiteColor forState:UIControlStateNormal];
    btn3.titleLabel.font = Font(14);
    [self.view addSubview:btn3];
    
    btn1.size = btn2.size = btn3.size = CGSizeMake((kScreenWidth - 100) / 3, 30);
    btn1.left = 20;
    btn1.top = self.progressLabel.bottom + 30;
    
    btn2.centerY = btn3.centerY = btn1.centerY;
    btn2.left = btn1.right + 30;
    btn3.left = btn2.right + 30;
    
    UILabel *netAudioLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.width, 30)];
    netAudioLabel.text = @"http://sc1.111ttt.cn/2015/1/10/15/103152254180.mp3";
    netAudioLabel.font = Font(12);
    netAudioLabel.textColor = BlueColor;
    [self.view addSubview:netAudioLabel];
    
    UILabel *localAudioLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, self.view.width, 30)];
    localAudioLabel.text = @"G.E.M. 邓紫棋-泡沫";
    localAudioLabel.font = Font(12);
    localAudioLabel.textColor = BlueColor;
    [self.view addSubview:localAudioLabel];
    
    [netAudioLabel addTapGestureHandleBlock:^(UIView *view, UITapGestureRecognizer *tap) {
        [weakSelf.player playWithUrl:((UILabel *)view).text];
    }];
    [localAudioLabel addTapGestureHandleBlock:^(UIView *view, UITapGestureRecognizer *tap) {
        [weakSelf.player playWithFileData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:((UILabel *)view).text ofType:@"mp3"]]];
    }];
}

#pragma mark 要手动停止播放
- (void)dealloc {
    YLLog(@"AudioPlayDemoVC dealloc");
    [_player stop];
}

@end
