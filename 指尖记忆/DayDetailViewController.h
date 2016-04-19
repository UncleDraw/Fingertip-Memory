//
//  DayDetailViewController.h
//  旅行记忆
//
//  Created by Comex on 16/2/3.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DayDetailViewControllerDelegate <NSObject>

@optional
- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForDismiss;

@end

@interface DayDetailViewController : UIViewController

@property (nonatomic, weak) id<DayDetailViewControllerDelegate>delegate;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIView *toolView;

@end
