//
//  CurveView.m
//  指尖记忆
//
//  Created by Comex on 16/2/19.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import "CurveView.h"
#import "CurveLayer.h"

@interface CurveView()

@property (nonatomic,strong)CurveLayer *curveLayer;

@end

@implementation CurveView

+ (Class)layerClass {
    return [CurveLayer class];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setProgress:(CGFloat)progress{
    self.curveLayer.progress = progress;
//    NSLog(@"progress:%f", progress);
    [self.curveLayer setNeedsDisplay];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.curveLayer = [CurveLayer layer];
    self.curveLayer.frame = self.bounds;
    self.curveLayer.contentsScale = [UIScreen mainScreen].scale;
    self.curveLayer.progress = 0.0f;
    [self.curveLayer setNeedsDisplay];
    [self.layer addSublayer:self.curveLayer];
}

@end
