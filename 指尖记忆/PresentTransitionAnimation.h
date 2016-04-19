//
//  PresentTransitionAnimation.h
//  指尖记忆
//
//  Created by Comex on 16/2/15.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, PresentTransitionType) {
    PresentTransitionTypePresent = 0,
    PresentTransitionTypeDismiss
};


@interface PresentTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(PresentTransitionType)type;
- (instancetype)initWithTransitionType:(PresentTransitionType)type;

@end
