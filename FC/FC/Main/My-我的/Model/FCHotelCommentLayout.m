//
//  FCHotelCommentLayout.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHotelCommentLayout.h"
#import "SDWeiXinPhotoContainerView.h"

@implementation FCHotelCommentLayout
- (instancetype)initWithModel:(FCHotelComment *)model
{
    self = [super init];
    if (self) {
        _comment = model;
        [self resetLayout];
    }
    return self;
}
- (void)resetLayout
{
    _height = 0;
    
    _height += kMomentTopPadding;
    _height += kMomentPortraitWidthAndHeight;
    _height += kMomentMarginPadding;
    
    // 计算文本布局
    [self layoutText];
    _height += _textLayout.textBoundingSize.height;
    
    // 计算是否应该加上展示全文的高度
    if (_comment.shouldShowMoreButton) { // 如果要显示全文按钮
        _height += kMomentLineSpacing;
        _height += kMomentHandleButtonHeight;
    }
    // 计算图片布局
    if (_comment.photos.count != 0) {
        [self layoutPicture];
        _height += kMomentMarginPadding;
        _height += _photoContainerSize.height;
    }
    
    _height += kMomentMarginPadding;
}
// 计算文本详情
- (void)layoutText
{
    _textLayout = nil;
    
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:_comment.dsp];
    text.yy_font = [UIFont systemFontOfSize:13];
    text.yy_color = UIColorFromRGB(0x999999);
    text.yy_lineSpacing = kMomentLineSpacing;
    
    // 未展开时最多显示6行
    NSInteger lineCount = 6;
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(HX_SCREEN_WIDTH - kMomentMarginLeftRight*2, _comment.isOpening ? CGFLOAT_MAX : 16 * lineCount + kMomentLineSpacing * (lineCount - 1))];
    // 阶段的类型，超出部分按尾部截段
    container.truncationType = YYTextTruncationTypeEnd;
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
}
// 计算图片
- (void)layoutPicture
{
    self.photoContainerSize = CGSizeZero;
    self.photoContainerSize = [SDWeiXinPhotoContainerView getContainerSizeWithPicPathStringsArray:_comment.photos];
}
@end
