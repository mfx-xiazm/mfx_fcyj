//
//  FCHouseFollowCell.m
//  FC
//
//  Created by huaxin-01 on 2020/4/20.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHouseFollowCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "FCHouseFollowLayout.h"

@interface FCHouseFollowCell ()
/** 内容视图 */
@property (nonatomic, strong) UIView *contentBgView;
/** 头像 */
@property (nonatomic , strong) UIImageView *avatarView;
/** 昵称 */
@property (nonatomic , strong) YYLabel *nickName;
/** 时间 */
@property (nonatomic , strong) YYLabel *createTime;
/** 文本内容 */
@property (nonatomic , strong) YYLabel *summaryContent;
/** 文本内容 */
@property (nonatomic , strong) YYLabel *textContent;
/** 九宫格 */
@property (nonatomic , strong) SDWeiXinPhotoContainerView *picContainerView;
/** 展开 */
@property (nonatomic , strong) SPButton *expand;
/** 分割线 */
@property (nonatomic , strong) UIView *dividingLine;
@end
@implementation FCHouseFollowCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HouseFollowCell";
    FCHouseFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 创建子控件
        [self setUpSubViews];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentBgView.frame = CGRectMake(kMomentMarginLeftRight, kMomentMarginLeftRight/2.0, self.hxn_width-kMomentMarginLeftRight*2, self.hxn_height-kMomentMarginLeftRight);
}

#pragma mark - 创建子控制器
- (void)setUpSubViews
{
    self.contentView.backgroundColor = HXGlobalBg;
    [self.contentView addSubview:self.contentBgView];
    [self.contentBgView addSubview:self.avatarView];
    [self.contentBgView addSubview:self.nickName];
    [self.contentBgView addSubview:self.createTime];
    [self.contentBgView addSubview:self.summaryContent];
    [self.contentBgView addSubview:self.textContent];
    [self.contentBgView addSubview:self.picContainerView];
    [self.contentBgView addSubview:self.expand];
    [self.contentBgView addSubview:self.dividingLine];
}
-(UIView *)contentBgView
{
    if(!_contentBgView){
        _contentBgView = [UIView new];
        _contentBgView.backgroundColor = [UIColor whiteColor];
        [_contentBgView setShadowWithCornerRadius:6.f shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.1 shadowRadius:6.f];
        //UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarClicked)];
        //[_avatarView addGestureRecognizer:tapGR];
    }
    return _contentBgView;
}
-(UIImageView *)avatarView
{
    if(!_avatarView){
        _avatarView = [UIImageView new];
        _avatarView.userInteractionEnabled = YES;
        _avatarView.backgroundColor = HXGlobalBg;
        _avatarView.contentMode = UIViewContentModeScaleToFill;
        _avatarView.layer.cornerRadius = kMomentPortraitWidthAndHeight/2.0;
        _avatarView.layer.masksToBounds = YES;
        //UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarClicked)];
        //[_avatarView addGestureRecognizer:tapGR];
    }
    return _avatarView;
}
-(YYLabel *)nickName
{
    if (!_nickName) {
        _nickName = [YYLabel new];
        _nickName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _nickName.textColor = UIColorFromRGB(0x1A1A1A);
        _nickName.userInteractionEnabled = YES;
        //UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nickNameClicked)];
        //[_nickName addGestureRecognizer:tapGR];
    }
    return _nickName;
}
-(YYLabel *)createTime
{
    if (!_createTime) {
        _createTime = [[YYLabel alloc] init];
        _createTime.font = [UIFont systemFontOfSize:12.0f];
        _createTime.textAlignment = NSTextAlignmentLeft;
        _createTime.textColor = UIColorFromRGB(0x999999);
    }
    return _createTime;
}
-(YYLabel *)summaryContent
{
    if (!_summaryContent) {
        _summaryContent = [YYLabel new];
        _summaryContent.backgroundColor = [UIColor whiteColor];
    }
    return _summaryContent;
}
-(YYLabel *)textContent
{
    if (!_textContent) {
        _textContent = [YYLabel new];
        _textContent.backgroundColor = HXGlobalBg;
    }
    return _textContent;
}
-(SDWeiXinPhotoContainerView *)picContainerView
{
    if (!_picContainerView) {
        _picContainerView = [SDWeiXinPhotoContainerView new];
        _picContainerView.hidden = YES;
    }
    return _picContainerView;
}
-(SPButton *)expand
{
    if (!_expand) {
        _expand = [SPButton buttonWithType:UIButtonTypeCustom];
        _expand.imagePosition = SPButtonImagePositionRight;
        [_expand setTitleColor:HXControlBg forState:UIControlStateNormal];
        [_expand setImage:HXGetImage(@"客源收起") forState:UIControlStateNormal];
        [_expand setTitle:@"收起" forState:UIControlStateNormal];
        _expand.titleLabel.font = [UIFont systemFontOfSize:12];
        _expand.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _expand.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_expand addTarget:self action:@selector(expandClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expand;
}
-(UIView *)dividingLine
{
    if (!_dividingLine) {
        _dividingLine = [UIView new];
        _dividingLine.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _dividingLine;
}
#pragma mark - Setter
-(void)setFollowLayout:(FCHouseFollowLayout *)followLayout
{
    _followLayout = followLayout;
    
    UIView * lastView;
    FCHouseFollow *follow = _followLayout.follow;
    
    /*
     #define kMomentTopPadding 15 // 顶部间隙
     #define kMomentMarginPadding 10 // 内容间隙
     #define kMomentPortraitWidthAndHeight 24 // 头像高度
     #define kMomentLineSpacing 5 // 文本行间距
     #define kMomentHandleButtonHeight 30 // 可操作的按钮高度
     */
   
    //头像
    _avatarView.hxn_x = kMomentMarginLeftRight;
    _avatarView.hxn_y = kMomentTopPadding;
    _avatarView.hxn_size = CGSizeMake(kMomentPortraitWidthAndHeight, kMomentPortraitWidthAndHeight);
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:follow.portrait]];
    
    //昵称
    _nickName.text = follow.nick;
    _nickName.hxn_y = kMomentTopPadding + (kMomentPortraitWidthAndHeight-kMomentHandleButtonHeight)/2.0;
    _nickName.hxn_x = _avatarView.hxn_right + kMomentMarginPadding;
    CGSize nameSize = [_nickName sizeThatFits:CGSizeZero];
    _nickName.hxn_width = nameSize.width;
    _nickName.hxn_height = kMomentHandleButtonHeight;
    
    //时间
    _createTime.text = follow.creatTime;
    _createTime.hxn_y = kMomentTopPadding + (kMomentPortraitWidthAndHeight-kMomentHandleButtonHeight)/2.0;
    CGSize timeSize = [_createTime sizeThatFits:CGSizeZero];
    _createTime.hxn_width = timeSize.width;
    _createTime.hxn_x = kMomentContentWidth - kMomentMarginLeftRight - timeSize.width;
    _createTime.hxn_height = kMomentHandleButtonHeight;
    
    //文本内容
    _summaryContent.hxn_x = _avatarView.hxn_right + kMomentMarginPadding;
    _summaryContent.hxn_y = _avatarView.hxn_bottom + kMomentMarginPadding;
    _summaryContent.hxn_width = kMomentContentWidth - kMomentMarginPadding - kMomentMarginLeftRight*2 - kMomentPortraitWidthAndHeight;
    _summaryContent.hxn_height = _followLayout.summaryLayout.textBoundingSize.height;
    _summaryContent.textLayout = _followLayout.summaryLayout;
    lastView = _summaryContent;
    
    if (follow.isOpening) {
        //文本内容
        _textContent.hidden = NO;
        _textContent.hxn_x = _avatarView.hxn_right + kMomentMarginPadding;
        _textContent.hxn_y = lastView.hxn_bottom + kMomentMarginPadding;
        _textContent.hxn_width = kMomentContentWidth - kMomentMarginPadding - kMomentMarginLeftRight*2 - kMomentPortraitWidthAndHeight;
        _textContent.hxn_height = _followLayout.textLayout.textBoundingSize.height;
        _textContent.textLayout = _followLayout.textLayout;
        lastView = _textContent;
        
        //图片集
        if (follow.photos.count != 0) {
            _picContainerView.hidden = NO;
            _picContainerView.hxn_x = _avatarView.hxn_right + kMomentMarginPadding;
            _picContainerView.hxn_y = lastView.hxn_bottom + kMomentMarginPadding;
            _picContainerView.hxn_width = _followLayout.photoContainerSize.width;
            _picContainerView.hxn_height = _followLayout.photoContainerSize.height;
            //_picContainerView.targetVc = self.targetVc;
            _picContainerView.picPathStringsArray = follow.photos;
            
            lastView = _picContainerView;
        }else{
            _picContainerView.hidden = YES;
        }
    }else{
        _textContent.hidden = YES;
        _picContainerView.hidden = YES;
    }
    
    //收起
    if (follow.isOpening) {
        [_expand setTitle:@"收起" forState:UIControlStateNormal];
        [_expand setImage:HXGetImage(@"客源收起") forState:UIControlStateNormal];
    }else{
        [_expand setTitle:@"展开" forState:UIControlStateNormal];
        [_expand setImage:HXGetImage(@"客源展开") forState:UIControlStateNormal];
    }
    _expand.hxn_y = lastView.hxn_bottom + kMomentMarginPadding;
    _expand.hxn_x = _avatarView.hxn_right + kMomentMarginPadding;
    _expand.hxn_width = 70;
    _expand.hxn_height = kMomentHandleButtonHeight;
    
    //分割线
    _dividingLine.hxn_x = 0;
    _dividingLine.hxn_height = .5;
    _dividingLine.hxn_width = kMomentContentWidth;
    _dividingLine.hxn_bottom = _followLayout.height - .5;
}
#pragma mark - 事件处理
- (void)expandClicked:(SPButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickExpandInCell:)]) {
        [self.delegate didClickExpandInCell:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
