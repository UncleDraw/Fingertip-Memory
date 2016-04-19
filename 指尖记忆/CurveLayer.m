//
//  CurveLayer.m
//  指尖记忆
//
//  Created by Comex on 16/2/19.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import "CurveLayer.h"

#define LINE_WITDH 15
#define LINE_HEIGHT 13

@implementation CurveLayer

//也可以在-(void)drawInContext:(CGContextRef)ctx代理方法中绘图
- (void)drawInContext:(CGContextRef)ctx {
    
    [super drawInContext:ctx];
    
    UIGraphicsPushContext(ctx);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *curvePath1 = [UIBezierPath bezierPath];
    UIBezierPath *curvePath2 = [UIBezierPath bezierPath];

    if (self.progress <= 0.5) {
        
        CGPoint orignalPoint = self.position;
        CGPoint leftPoint = CGPointMake(self.position.x - 2 * self.progress * LINE_WITDH, self.position.y);
        CGPoint rightPoint = CGPointMake(self.position.x + 2 * self.progress * LINE_WITDH, self.position.y);
        
        [curvePath1 moveToPoint:orignalPoint];
        [curvePath1 addLineToPoint:leftPoint];
        
        [curvePath2 moveToPoint:orignalPoint];
        [curvePath2 addLineToPoint:rightPoint];
        
    }else if (self.progress > 0.5) {
        
        
        CGPoint leftPoint = CGPointMake(self.position.x - LINE_WITDH, self.position.y);
        CGPoint rightPoint = CGPointMake(self.position.x + LINE_WITDH, self.position.y);
        CGPoint orignalPoint = CGPointMake(self.position.x, self.position.y + LINE_HEIGHT * (self.progress - 0.5)*2);

        [curvePath1 moveToPoint:orignalPoint];
        [curvePath1 addLineToPoint:leftPoint];
        
        [curvePath2 moveToPoint:orignalPoint];
        [curvePath2 addLineToPoint:rightPoint];
    }
    
    CGContextSaveGState(context);
    CGContextRestoreGState(context);
    
    [[UIColor blackColor] setStroke];
    [curvePath1 stroke];
    [curvePath2 stroke];
    
    UIGraphicsPopContext();
}

@end
