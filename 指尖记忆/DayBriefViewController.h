//
//  DayBriefViewController.h
//  指尖记忆
//
//  Created by Comex on 16/2/13.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DayBriefViewController;

@protocol DayBriefViewControllerDelegate <NSObject>

@optional
- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent;

@end

typedef void (^BackBlock)(DayBriefViewController *vc);


@interface DayBriefViewController : UIViewController

@property (nonatomic, weak) id<DayBriefViewControllerDelegate>delegate;

@property (nonatomic, copy) BackBlock backBlock;

@end
