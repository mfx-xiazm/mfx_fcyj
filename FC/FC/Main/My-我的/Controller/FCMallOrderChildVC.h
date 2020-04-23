//
//  FCMallOrderChildVC.h
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "HXBaseViewController.h"
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCMallOrderChildVC : HXBaseViewController <JXCategoryListContentViewDelegate>
@property (nonatomic, copy) NSArray *cateTitles;
@end

NS_ASSUME_NONNULL_END
