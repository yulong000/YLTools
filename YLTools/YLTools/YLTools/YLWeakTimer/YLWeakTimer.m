//
//  YLWeakTimer.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLWeakTimer.h"

@interface YLWeakTimerTarget : NSObject

@property (nonatomic, copy)   YLTimerRepeatBlock handler;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak)   id target;

@end

@implementation YLWeakTimerTarget

- (void)fire {
    if(self.target == nil) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    if(self.handler) {
        self.handler(self.timer);
    }
}

- (void)dealloc {
    YLLog(@"timer dealloc");
}

@end

@implementation YLWeakTimer

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                            target:(id)target
                     repeatHandler:(YLTimerRepeatBlock)handler {
    YLWeakTimerTarget *timerTarget = [[YLWeakTimerTarget alloc] init];
    timerTarget.handler = handler;
    timerTarget.target = target;
    timerTarget.timer = [NSTimer timerWithTimeInterval:interval target:timerTarget selector:@selector(fire) userInfo:nil repeats:YES];
    return timerTarget.timer;
}

@end
