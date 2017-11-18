//
//  ViewController.m
//  LayerDemo
//
//  Created by xiongan on 2017/11/18.
//  Copyright © 2017年 xiongan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,weak)CALayer *frontWaveLayer;
@property (nonatomic,weak)CALayer *backWaveLayer;
@property (nonatomic,weak)UIView *contentView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:contentView];
    _contentView = contentView;
    contentView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.5];
    
    CAShapeLayer *layer1 = [CAShapeLayer layer];
    layer1.bounds = contentView.bounds;
    layer1.position = CGPointMake(0, 0);
    layer1.anchorPoint = CGPointZero;
    
    layer1.path = [self frontLayerPath];
    layer1.fillColor = [UIColor colorWithRed:34/255.0 green:116/255.0 blue:210/255.0 alpha:1].CGColor;
    
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.bounds = contentView.bounds;
    layer2.position = CGPointMake(0, 0);
    layer2.anchorPoint = CGPointZero;
    layer2.path = [self backLayerPath];
    layer2.fillColor = [UIColor colorWithRed:34/255.0 green:116/255.0 blue:210/255.0 alpha:0.3].CGColor;
    
    
    [contentView.layer addSublayer:layer1];
    _frontWaveLayer = layer1;
                        
    [contentView.layer addSublayer:layer2];
    _backWaveLayer = layer2;
    _backWaveLayer.hidden = YES;
    
    [self.frontWaveLayer setValue:@(10) forKeyPath:@"position.y"];
    [self.backWaveLayer setValue:@(10) forKeyPath:@"position.y"];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)startFrontAnimation:(id)sender {
    CGFloat w = 100;
    // 说明这个动画对象要对CALayer的position属性执行动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.duration = 2;
    anim.fromValue = @(0);
    anim.toValue =@(-w);
    anim.repeatCount = MAXFLOAT;
    anim.fillMode = kCAFillModeForwards;
    [self.frontWaveLayer addAnimation:anim forKey:@"translation.x"];
}
- (IBAction)cutLayer {
    
    self.contentView.layer.masksToBounds = YES;
}


- (IBAction)startBackAnimation:(id)sender {
    CGFloat w = 100;
    // 说明这个动画对象要对CALayer的position属性执行动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.duration = 2;
    anim.fromValue = @(0);
    anim.toValue =@(-w);
    anim.repeatCount = MAXFLOAT;
    anim.fillMode = kCAFillModeForwards;
    [self.backWaveLayer addAnimation:anim forKey:@"translation.x"];
}
- (CGPathRef)frontLayerPath {
    
    CGFloat w = 100;
    CGFloat h = 100;
    UIBezierPath *bezierFristWave = [UIBezierPath bezierPath];
    CGFloat waveHeight = 5 ;
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGFloat startOffY = waveHeight * sinf(0 * M_PI * 2 / w);
    CGFloat orignOffY = 0.0;
    CGPathMoveToPoint(pathRef, NULL, 0, startOffY);
    
    [bezierFristWave moveToPoint:CGPointMake(0, startOffY)];
    for (CGFloat i = 0.f; i <= w * 2; i++) {
        orignOffY = waveHeight * sinf(2 * M_PI /w * i) ;
        [bezierFristWave addLineToPoint:CGPointMake(i, orignOffY)];
    }
    [bezierFristWave addLineToPoint:CGPointMake(w * 2, orignOffY)];
    [bezierFristWave addLineToPoint:CGPointMake(w * 2, h)];
    [bezierFristWave addLineToPoint:CGPointMake(0, h)];
    [bezierFristWave addLineToPoint:CGPointMake(0, startOffY)];
    [bezierFristWave closePath];
    return bezierFristWave.CGPath;
}
- (CGPathRef)backLayerPath {
    
    CGFloat w = 100;
    CGFloat h = 100;
    UIBezierPath *bezierFristWave = [UIBezierPath bezierPath];
    CGFloat waveHeight = 5 ;
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGFloat startOffY = waveHeight * sinf(0 * M_PI * 2 / w);
    CGFloat orignOffY = 0.0;
    CGPathMoveToPoint(pathRef, NULL, 0, startOffY);
    
    [bezierFristWave moveToPoint:CGPointMake(0, startOffY)];
    for (CGFloat i = 0.f; i <= w * 2; i++) {
        orignOffY = waveHeight * cosf(2 * M_PI /w * i) ;
        [bezierFristWave addLineToPoint:CGPointMake(i, orignOffY)];
    }
    [bezierFristWave addLineToPoint:CGPointMake(w * 2, orignOffY)];
    [bezierFristWave addLineToPoint:CGPointMake(w * 2, h)];
    [bezierFristWave addLineToPoint:CGPointMake(0, h)];
    [bezierFristWave addLineToPoint:CGPointMake(0, startOffY)];
    [bezierFristWave closePath];
    return bezierFristWave.CGPath;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showBackLayer:(id)sender {
    self.backWaveLayer.hidden = NO;
}


@end
