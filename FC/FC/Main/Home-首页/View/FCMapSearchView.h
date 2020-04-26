//
//  FCMapSearchView.h
//  FC
//
//  Created by huaxin-01 on 2020/4/26.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^searchClickedCall)(NSInteger type,NSString *txt);
@interface FCMapSearchView : UIView
@property (nonatomic, copy) searchClickedCall searchClickedCall;
@end

NS_ASSUME_NONNULL_END
