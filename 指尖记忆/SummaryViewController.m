//
//  SummaryViewController.m
//  指尖记忆
//
//  Created by Comex on 16/2/13.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import "SummaryViewController.h"
#import "PresentDownTransitionAnimation.h"
#import "InteractiveTransition.h"

@interface SummaryViewController () <UITableViewDataSource,UITableViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) InteractiveTransition *interactiveDismiss;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *quesList;

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.transitioningDelegate = self;
    
    _blockNum = 8;
    
    //初始化 interactiveDismiss
//    _interactiveDismiss = [InteractiveTransition interactiveTransitionWithTransitionType:InteractiveTransitionTypeDismiss GestureDirection:InteractiveTransitionGestureDirectionDown];
//    typeof(self) weakSelf = self;
//    _interactiveDismiss.dismissConifg = ^(){
//        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//    };
//    [_interactiveDismiss addPanGestureForViewController:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

-(void)tapGestureRecognizer:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark lazy load
- (NSArray *) quesList {
    
    if (!_quesList) {
        _quesList = @[@"今天我完成了什么？",
                      @"今天我锻炼身体了吗？",
                      @"今天我为家人做了什么？",
                      @"今天我关心朋友了吗？",
                      @"今天花了多少钱？",
                      @"今天吃什么好吃的了？",
                      @"我让明天更美好了吗？",
                      @"今天最好的三件事是什么？"];
    }
    return _quesList;
}

#pragma mark UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _blockNum;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableView"];
    }
    
    cell.textLabel.text = self.quesList[indexPath.row];
    
    return cell;
}

#pragma mark UITableViewDelegate

#pragma mark UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [PresentDownTransitionAnimation transitionWithTransitionType:PresentTransitionTypePresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [PresentDownTransitionAnimation transitionWithTransitionType:PresentTransitionTypeDismiss];
}

//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
//    return _interactiveDismiss.interation ? _interactiveDismiss : nil;
//}
@end
