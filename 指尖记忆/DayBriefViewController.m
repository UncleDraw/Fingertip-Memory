//
//  DayBriefViewController.m
//  指尖记忆
//
//  Created by Comex on 16/2/13.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import "DayBriefViewController.h"
#import "WeekCollectionViewCell.h"
#import "TotalCollectionViewCell.h"
#import "PresentTransitionAnimation.h"
#import "DayDetailViewController.h"
#import "InteractiveTransition.h"

@interface DayBriefViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) IBOutlet UIView *topView;
@property (nonatomic, weak) IBOutlet UICollectionView *weekCollection;
@property (nonatomic, weak) IBOutlet UICollectionView *totalCollection;
@property (nonatomic, weak) IBOutlet UILabel *sayingLabel;
@property (nonatomic, weak) IBOutlet UILabel * nameLabel;

@property (nonatomic, strong) NSArray *weekList;
@property (nonatomic, strong) NSArray *dayList;
@property (nonatomic, strong) NSArray *totalNameList;
@property (nonatomic, strong) NSArray *totalNumList;

@property (nonatomic, strong) InteractiveTransition *interactiveDismiss;

@property (nonatomic, strong) UIView *snapshot;

@end

@implementation DayBriefViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weekCollection.delegate = self;
    self.weekCollection.dataSource = self;
    self.totalCollection.delegate = self;
    self.totalCollection.dataSource =self;
    
//    self.transitioningDelegate = self;

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunused-variable"
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addGestureToSnapshot) userInfo:nil repeats:NO];
#pragma clang diagnostic pop
    
}

- (void) addGestureToSnapshot {
    
    //UITransitianView，也就是动画中的containerView，在控制器转场动画开始后，用于容纳presented控制器的View。
    //在这个动画中，UITransitianView包含了DayBriefViewController的view和snapshot（在动画中是UIReplicantView），所以这步就为了找出snapshot
    NSArray *subviews = self.view.superview.subviews;
    UIView *snapshot = subviews.lastObject;
    
    //给snapshot添加手势，让其处理dismiss
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [snapshot addGestureRecognizer:tapGesture];
    
    //初始化 interactiveDismiss
    _interactiveDismiss = [InteractiveTransition interactiveTransitionWithTransitionType:InteractiveTransitionTypeDismiss GestureDirection:InteractiveTransitionGestureDirectionUp];
    typeof(self) weakSelf = self;
    _interactiveDismiss.dismissConifg = ^(){
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [_interactiveDismiss addPanGestureForView:snapshot];
}

- (void) handleGesture:(UITapGestureRecognizer*)tap{
//    NSLog(@"tap handling...");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark lazy load
- (NSArray *) weekList {
    
    if (!_weekList) {
        _weekList = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    }
    return _weekList;
}

- (NSArray *) dayList {
    
    if (!_dayList) {
        _dayList = @[@"8",@"9",@"10",@"11",@"12",@"13",@"14"];
    }
    return _dayList;
}

- (NSArray *) totalNameList {
    
    if (!_totalNameList) {
        _totalNameList = @[@"日记", @"格子", @"问题", @"照片"];
    }
    return _totalNameList;
}

- (NSArray *) totalNumList {
    
    if (!_totalNumList) {
        _totalNumList = @[@"2", @"12", @"8", @"0"];
    }
    return _totalNumList;
}

#pragma mark UICollectionViewDataSource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.weekCollection) {
        return 7;
    } else {
        return 4;
    }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.weekCollection) {
        
        WeekCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"week" forIndexPath:indexPath];
        
        cell.weekLabel.text = self.weekList[indexPath.row];
        cell.dayLabel.text = self.dayList[indexPath.row];
        
        if ([cell.weekLabel.text isEqualToString:@"周二"]) {
            cell.weekLabel.textColor = [UIColor greenColor];
            cell.dayLabel.textColor = [UIColor greenColor];
        }
        return cell;
        
    } else {
        
        TotalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"total" forIndexPath:indexPath];
        
        cell.totalNameLabel.text = self.totalNameList[indexPath.row];
        cell.totalNumLabel.text = self.totalNumList[indexPath.row];
        
        return cell;
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.weekCollection) {
     
        CGFloat cellW =(SCREEN_WIDTH - 40 - 8) / 7;
        CGFloat cellH = self.weekCollection.bounds.size.height - 2;
        
        return CGSizeMake(cellW, cellH);
        
    } else {
        CGFloat cellW = (SCREEN_WIDTH - 3) / 2;
        CGFloat cellH = (self.totalCollection.bounds.size.height - 3) / 2;
        return CGSizeMake(cellW, cellH);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
#pragma mark UICollectionViewDelegate


#pragma mark UIViewControllerTransitioningDelegate
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
//    return [PresentTransitionAnimation transitionWithTransitionType:PresentTransitionTypePresent];
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
//    return [PresentTransitionAnimation transitionWithTransitionType:PresentTransitionTypeDismiss];
//}
//
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _interactiveDismiss.interation ? _interactiveDismiss : nil;
}
//
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
//    InteractiveTransition *_interactivePresent = [_delegate interactiveTransitionForPresent];
//    return _interactivePresent.interation ? _interactivePresent : nil;
//}

#pragma mark DayDetailViewControllerDelegate
- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForDismiss {
    return _interactiveDismiss;
}

@end
