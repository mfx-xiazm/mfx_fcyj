//
//  FCHouseFollow.m
//  FC
//
//  Created by huaxin-01 on 2020/4/20.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHouseFollow.h"

@implementation FCHouseFollow
-(void)setNick:(NSString *)nick
{
    _nick = nick;
    _isOpening = YES;
}
-(void)setIsOpening:(BOOL)isOpening
{
    _isOpening = isOpening;
}
@end
