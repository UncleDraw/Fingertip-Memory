//
//  CurveLayer.h
//  指尖记忆
//
//  Created by Comex on 16/2/19.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface CurveLayer : CALayer

/**
 *  CurveLayer的进度 0~1
 */
@property(nonatomic,assign)CGFloat progress;

@end
