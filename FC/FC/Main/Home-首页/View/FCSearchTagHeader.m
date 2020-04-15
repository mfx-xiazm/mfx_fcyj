//
//  FCSearchTagHeader.m
//  FC
//
//  Created by huaxin-01 on 2020/4/15.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCSearchTagHeader.h"

@implementation FCSearchTagHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)cliearClicked:(UIButton *)sender {
    if (self.clearHistoryCall) {
        self.clearHistoryCall();
    }
}
@end
