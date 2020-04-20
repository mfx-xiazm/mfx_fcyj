//
//  FCHouseFollow.h
//  FC
//
//  Created by huaxin-01 on 2020/4/20.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCHouseFollow : NSObject
/** 用户头像 */
@property(nonatomic,copy)NSString *portrait;
/** 用户昵称 */
@property(nonatomic,copy)NSString *nick;
/** 时间 */
@property(nonatomic,copy)NSString *creatTime;
/** 内容文本 */
@property(nonatomic,copy)NSString *dsp;
/** 备注信息 */
@property(nonatomic,copy)NSString *followTxt;
/** 照片数组 */
@property(nonatomic,strong)NSArray *photos;
/** 是否已展开 */
@property (nonatomic, assign) BOOL isOpening;
@end

NS_ASSUME_NONNULL_END
