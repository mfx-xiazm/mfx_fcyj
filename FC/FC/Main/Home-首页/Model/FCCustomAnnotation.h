//
//  FCCustomAnnotation.h
//  FC
//
//  Created by huaxin-01 on 2020/4/26.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCCustomAnnotation : NSObject <MAAnnotation>
///标注view中心坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
///annotation标题
@property (nonatomic, copy) NSString *title;
///annotation副标题
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) UIImage *outImage;
@end

NS_ASSUME_NONNULL_END
