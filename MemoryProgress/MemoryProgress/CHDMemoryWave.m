//
//  MemoryWave.m
//  MemoryProgress
//
//  Created by xiongan on 2017/11/15.
//  Copyright © 2017年 xiongan. All rights reserved.
//

#import "CHDMemoryWave.h"
#import <UIKit/UIKit.h>
#import "CHDMemoryWaveController.h"

@implementation CHDMemoryWave
{
    UIViewController *_vc;
    UIWindow *_window;
}
+ (instancetype)sharedMemoryWave {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CHDMemoryWave alloc]init];
        
    });
    return instance;
}
- (instancetype)init {
if (self = [super init]) {
    CHDMemoryWaveController *vc = [[CHDMemoryWaveController alloc]init];
    CGSize size = [UIScreen mainScreen].bounds.size;
    vc.view.frame = CGRectMake(size.width - 100,size.height - 100 , 100, 100);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:vc.view];
    [window bringSubviewToFront:vc.view];
    _vc = vc;
}
    return self;
}
@end
