//
//  FCHotelComment.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHotelComment.h"

@implementation FCHotelComment
-(void)setDsp:(NSString *)dsp
{
    if (!dsp) {
        return;
    }
    _dsp = dsp;
    if (!_dsp.length) {
        _dsp = @"";
    }
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:_dsp];
    text.yy_font = [UIFont systemFontOfSize:13];// 文字大小
    text.yy_lineSpacing = 5;//行高
    
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(HX_SCREEN_WIDTH - 12*2, CGFLOAT_MAX)];
    
    YYTextLayout * layout = [YYTextLayout layoutWithContainer:container text:text];
    
    // 默认最多显示6行，大于6行折叠，并显示全文按钮
    if (layout.rowCount <= 6) {
        _shouldShowMoreButton = NO;
    }else{
        _shouldShowMoreButton = YES;
    }
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}
@end
