//
//  FCHouseFollowLayout.m
//  FC
//
//  Created by huaxin-01 on 2020/4/20.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHouseFollowLayout.h"
#import "SDWeiXinPhotoContainerView.h"

@implementation FCHouseFollowLayout
- (instancetype)initWithModel:(FCHouseFollow *)model
{
    
    self = [super init];
    if (self) {
        _follow = model;
        [self resetLayout];
    }
    return self;
}
- (void)resetLayout
{
    _height = 0;
    
    _height += kMomentMarginLeftRight/2.0;
    
    _height += kMomentTopPadding;
    _height += kMomentPortraitWidthAndHeight;
    
    _height += kMomentMarginPadding;
    // 计算文本布局
    [self layoutTxt];
    _height += _summaryLayout.textBoundingSize.height;

    if (_follow.isOpening) {
        _height += kMomentMarginPadding;
        [self layoutDsp];
        _height += _textLayout.textBoundingSize.height;
        
        // 计算图片布局
        if (_follow.photos.count != 0) {
            [self layoutPicture];
            _height += kMomentMarginPadding;
            _height += _photoContainerSize.height;
        }
    }

    _height += kMomentMarginPadding;
    _height += kMomentHandleButtonHeight;
    _height += kMomentMarginPadding;
    
    _height += kMomentMarginLeftRight/2.0;
}
// 计算文本详情
- (void)layoutTxt
{
    _summaryLayout = nil;
    
    NSMutableAttributedString *summary = [[NSMutableAttributedString alloc] initWithString:_follow.followTxt];
    summary.yy_font = [UIFont systemFontOfSize:12];
    summary.yy_color = UIColorFromRGB(0x666666);
    summary.yy_lineSpacing = kMomentLineSpacing;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kMomentContentWidth - kMomentMarginLeftRight*2 - kMomentMarginPadding -kMomentPortraitWidthAndHeight, CGFLOAT_MAX) insets:UIEdgeInsetsZero];
    // 阶段的类型，超出部分按尾部截段
    container.truncationType = YYTextTruncationTypeEnd;
    
    _summaryLayout = [YYTextLayout layoutWithContainer:container text:summary];
}
- (void)layoutDsp
{
    _textLayout = nil;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_follow.dsp];
    text.yy_font = [UIFont systemFontOfSize:12];
    text.yy_color = UIColorFromRGB(0x666666);
    text.yy_lineSpacing = kMomentLineSpacing;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kMomentContentWidth - kMomentMarginLeftRight*2 - kMomentMarginPadding -kMomentPortraitWidthAndHeight, CGFLOAT_MAX) insets:UIEdgeInsetsMake(5, 5, 5, 5)];
    // 阶段的类型，超出部分按尾部截段
    container.truncationType = YYTextTruncationTypeEnd;
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
}
// 计算图片
- (void)layoutPicture
{
    self.photoContainerSize = CGSizeZero;
    self.photoContainerSize = [SDWeiXinPhotoContainerView getContainerSizeWithPicPathStringsArray:_follow.photos];
}
@end
