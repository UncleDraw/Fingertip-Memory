//
//  PresentDownTransitionAnimation.m
//  指尖记忆
//
//  Created by Comex on 16/2/21.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import "PresentDownTransitionAnimation.h"

@interface PresentDownTransitionAnimation ()

@property (nonatomic, assign) PresentTransitionType type;

@end

@implementation PresentDownTransitionAnimation

+ (instancetype)transitionWithTransitionType:(PresentTransitionType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(PresentTransitionType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

#pragma mark UIViewControllerAnimatedTransitioning
//动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return _type == PresentTransitionTypePresent ? 0.5 : 0.5;
}

//动画过程
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    switch (_type) {
        case PresentTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
            
        case PresentTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}

#pragma mark 实现present和dismiss动画
/**
 *  实现present动画
 */
//- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
//    
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    
//    UIView *snapshot = [fromVC.view snapshotViewAfterScreenUpdates:NO];
//    snapshot.frame = fromVC.view.frame;
//    
//    UIView *containerView = [transitionContext containerView];
//    [containerView addSubview:snapshot];
//    [containerView addSubview:toVC.view];
//    
//    toVC.view.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
//    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
//        
////        snapshot.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT);
//        toVC.view.transform = CGAffineTransformIdentity;
//        
//    } completion:^(BOOL finished) {
//        
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//        if ([transitionContext transitionWasCancelled]) {
//
//            [snapshot removeFromSuperview];
//        }
//    }];
//}
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    /*
     fromVC UINavigationController 的根视图控制器---->ViewController
     toVC --->SecondViewController
     */
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    UIView *snapshot = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = fromView.frame;
    
    UIView* containerView = [transitionContext containerView];
    //获取fromVC（ViewController）的frame
    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    //底部滑进 离屏滑入 即y坐标 从height --->0
    CGRect offScreenFrame = frame;
    CGRect finalScreenFrame = frame;
    offScreenFrame.origin.y = offScreenFrame.size.height;
    finalScreenFrame.origin.y = 200;
    
    toView.frame = offScreenFrame;
    
    fromView.hidden = YES;
    
    [containerView addSubview:snapshot];
    [containerView insertSubview:toView aboveSubview:snapshot];
    
    //三维变化
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-1000;
    //x y方向各缩放比例为0.95
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    //x方向旋转15°
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = 1.0/-1000;
    //沿Y方向向上移动
    t2 = CATransform3DTranslate(t2, 0, -fromView.frame.size.height*0.08, 0);
    //在x y方向各缩放比例为0.8
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    //UIView关键帧过渡动画 总的持续时间：1.0
    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        //开始时间：1.0*0.0 持续时间：1.0*0.4
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.4f animations:^{
            //执行t1动画 缩放并旋转角度
            snapshot.layer.transform = t1;
            //fromView的透明度
            snapshot.alpha = 0.6;
        }];
        //开始时间：1.0*0.1 持续时间：1.0*0.5
        [UIView addKeyframeWithRelativeStartTime:0.1f relativeDuration:0.5f animations:^{
            //执行t2动画 向上平移和缩放
            snapshot.layer.transform = t2;
        }];
        //开始时间：1.0*0.0 持续时间：1.0*1.0
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:1.0f animations:^{
            //toView向上滑入
            toView.frame = finalScreenFrame;
        }];
        
    } completion:^(BOOL finished) {
        //过渡动画结束
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            
            fromVC.view.hidden = NO;
            [snapshot removeFromSuperview];
        }
    }];
}

/**
 *  实现dimiss动画
 */
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    toView.frame = frame;
    
    CGRect frameOffScreen = frame;
    frameOffScreen.origin.y = frame.size.height;
    
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-1000;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    
    UIView *containerView = [transitionContext containerView];
    NSArray *subviewsArray = containerView.subviews;
    UIView *snapshot = subviewsArray[MIN(subviewsArray.count, MAX(0, subviewsArray.count - 2))];
    
    //关键帧过渡动画
    [UIView animateKeyframesWithDuration:1.0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:1.0f animations:^{
            //滑出屏幕
            fromView.frame = frameOffScreen;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.35f relativeDuration:0.35f animations:^{
            //执行t1,沿着x,y放大，沿x旋转
            snapshot.layer.transform = t1;
            //透明度变为1.0
            snapshot.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.75f relativeDuration:0.25f animations:^{
            //还原3D状态
            snapshot.layer.transform = CATransform3DIdentity;
        }];
    } completion:^(BOOL finished) {
        
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
            toVC.view.hidden = NO;
            [snapshot removeFromSuperview];
        }
    }];
}

@end
