//
//  InteractiveTransition.h
//  指尖记忆
//
//  Created by Comex on 16/2/15.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureConifg)();
//typedef void(^GestureConifg)(UIViewController *vc);

typedef NS_ENUM(NSUInteger, InteractiveTransitionGestureDirection) {
    InteractiveTransitionGestureDirectionLeft = 0,
    InteractiveTransitionGestureDirectionRight,
    InteractiveTransitionGestureDirectionUp,
    InteractiveTransitionGestureDirectionDown
};

typedef NS_ENUM(NSUInteger, InteractiveTransitionType) {
    InteractiveTransitionTypePresent = 0,
    InteractiveTransitionTypeDismiss,
    InteractiveTransitionTypePush,
    InteractiveTransitionTypePop,
};

@interface InteractiveTransition : UIPercentDrivenInteractiveTransition

/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;
/**促发手势present的时候的config，config中初始化并present需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg presentConifg;
/**促发手势push的时候的config，config中初始化并push需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg pushConifg;
@property (nonatomic, copy) GestureConifg popConifg;
@property (nonatomic, copy) GestureConifg dismissConifg;

//初始化方法
+ (instancetype)interactiveTransitionWithTransitionType:(InteractiveTransitionType)type GestureDirection:(InteractiveTransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(InteractiveTransitionType)type GestureDirection:(InteractiveTransitionGestureDirection)direction;

/** 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;
- (void)addPanGestureForView:(UIView *)snapshot;
@end
