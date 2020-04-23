//
//  FCHotelCommentHeader.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHotelCommentHeader.h"

@implementation FCHotelCommentHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)lookMoreClicked:(UIButton *)sender {
    if (self.lookMoreCall) {
        self.lookMoreCall();
    }
}

@end
