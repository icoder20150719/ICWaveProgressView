//
//  CHDMemoryWaveController.m
//  MemoryProgress
//
//  Created by xiongan on 2017/11/15.
//  Copyright © 2017年 xiongan. All rights reserved.
//

#import "CHDMemoryWaveController.h"
#import "CHDWaveView.h"
#import "UIApplication+Memory.h"
@protocol WeakTargetDelegate <NSObject>

- (void)tick:(id)obj;
@end
@interface WeakTarget1 : NSObject<WeakTargetDelegate>
@property (weak,nonatomic)id <WeakTargetDelegate> delegate;
@end

@implementation WeakTarget1
- (void)tick:(id)obj {
    [self.delegate tick:obj];
}
@end
@interface CHDMemoryWaveController ()<WeakTargetDelegate>
@property (nonatomic,strong)CHDWaveView *waveView;
@end

@implementation CHDMemoryWaveController
{
    CADisplayLink *_link;
    NSUInteger _count;
    NSUInteger _duration;
    NSTimeInterval _lastTime;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    CHDWaveView *waveView = [[CHDWaveView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:waveView];
    self.waveView = waveView;
    self.waveView.waveHeight = 5;
    self.waveView.progress = 1;
    self.waveView.speed = 0.8;
    WeakTarget1 *target = [[WeakTarget1 alloc]init];
    target.delegate = self;
//    _link = [CADisplayLink displayLinkWithTarget:target selector:@selector(tick:)];
//    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self changed];
}
- (void)changed {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.waveView.progress -= 0.01;
        if (self.waveView.progress >= 0 || self.waveView.progress <= 1) {
            
            [self changed];
        }
    });
    
}
- (void)dealloc {
    [_link invalidate];
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    //每秒屏幕刷新的次数（帧数）
    float fps = _count / delta;
    _count = 0;
    _duration ++;
    CGFloat used = [UIApplication sharedApplication].memoryUsed;
    CGFloat free = [UIApplication sharedApplication].availableMemory;
    CGFloat fprogress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (fprogress - 0.2) saturation:1 brightness:0.9 alpha:1];
    CGFloat mprogress = used / (used + free);
    self.waveView.progress = mprogress;
    if (_duration % 11 == 0) {
        self.waveView.fpsLabel.text = [NSString stringWithFormat:@"占用:%dMB",(int)used];
    }else if (_duration % 11 == 1){
        self.waveView.fpsLabel.text = [NSString stringWithFormat:@"空闲:%dMB",(int)free];
    }else{
        self.waveView.fpsLabel.text = [NSString stringWithFormat:@"%d帧",(int)fps];
    }
    self.waveView.fpsLabel.textColor = color;
    UIColor *firstWaveColor = [UIColor colorWithHue:0.27 * (1-mprogress) saturation:1 brightness:0.9 alpha:1];
    UIColor *secondWaveColor = [UIColor colorWithHue:0.27 * (1-mprogress) saturation:1 brightness:0.9 alpha:0.5];
    self.waveView.firstWaveColor = firstWaveColor;
    self.waveView.secondWaveColor = secondWaveColor;
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
   CGPoint point = [touch locationInView:self.view.superview];
    self.view.center = point;
}
@end
