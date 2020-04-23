//
//  FCBillInfoView.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCBillInfoView.h"

@implementation FCBillInfoView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)dissmissClicked:(SPButton *)sender {
    if (self.dissmissCall) {
        self.dissmissCall();
    }
}

@end
