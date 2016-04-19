//
//  CollectionViewHeader.h
//  旅行记忆
//
//  Created by Comex on 16/2/3.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewHeader : UICollectionReusableView

@property (nonatomic, weak) IBOutlet UILabel *dayLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@end
