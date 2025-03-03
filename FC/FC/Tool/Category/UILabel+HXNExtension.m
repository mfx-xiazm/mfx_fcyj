//
//  UILabel+HXNExtension.m
//  HX
//
//  Created by hxrc on 16/11/12.
//  Copyright © 2016年 xgt. All rights reserved.
//

#import "UILabel+HXNExtension.h"

@implementation UILabel (HXNExtension)
// 改变某些文字颜色
-(void)setColorAttributedText:(NSString *)allStr andChangeStr:(NSString *)changeStr andColor:(UIColor *)color
{
    NSString *string = changeStr;//要单独改变的字体颜色
    NSRange range = [allStr rangeOfString:string];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = attStr;
}
// 改变某些文字颜色
-(void)setColorAttributedText:(NSString *)allStr andChangeRange:(NSRange )range andColor:(UIColor *)color
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = attStr;
}

// 改变某些文字大小
-(void)setFontAttributedText:(NSString *)allStr andChangeStr:(NSString *)changeStr andFont:(UIFont *)font
{
    NSString *string = changeStr;//要单独改变的字体颜色
    NSRange range = [allStr rangeOfString:string];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    [attStr addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = attStr;
}

-(void)setFontAttributedText:(NSString *)allStr andChangeRange:(NSRange )range andFont:(UIFont *)font
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    [attStr addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = attStr;
}

// 改变某些文字大小和颜色
-(void)setFontAndColorAttributedText:(NSString *)allStr andChangeStr:(NSString *)changeStr andColor:(UIColor *)color andFont:(UIFont *)font
{
    NSString *string = changeStr;//要单独改变的字体颜色
    NSRange range = [allStr rangeOfString:string];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attStr addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = attStr;
}

-(void)setTextWithLineSpace:(CGFloat)lineSpace withString:(NSString*)str withFont:(UIFont*)font {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    
//    // 添加表情
//    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//    // 表情图片
//    attch.image = [UIImage imageNamed:@"d_aini"];
//    // 设置图片大小
//    attch.bounds = CGRectMake(0, 0, 32, 32);
//    
//    // 创建带有图片的富文本
//    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
//    [attri appendAttributedString:string];
    
    self.attributedText = attributeStr;
    
    //将lineBreakMode样式改回在末尾显示省略号的样式
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}

-(void)setLabelUnderline:(NSString *)str
{
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:str attributes:attribtDic];
    
    NSRange range = [str rangeOfString:@"￥"];
    if (range.length) {
        [attribtStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:range];
    }
    // 赋值
    self.attributedText = attribtStr;
}

-(void)addFlagLabelWithName:(NSString *)tagName lineSpace:(CGFloat)lineSpace titleString:(NSString*)titleString withFont:(UIFont*)font
{
    //创建NSMutableAttributedString 富文本对象
    NSMutableAttributedString *maTitleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",titleString]];
    //创建一个小标签的Label
    NSString *aa = tagName;
    CGFloat aaW = 12*aa.length +6;
    UILabel *aaL = [UILabel new];
    aaL.frame = CGRectMake(0, 0, aaW*3, 16*3);
    aaL.text = aa;
    aaL.font = [UIFont systemFontOfSize:10*3];
    aaL.textColor = [UIColor whiteColor];
    aaL.backgroundColor = HXControlBg;
    aaL.clipsToBounds = YES;
    aaL.layer.cornerRadius = (16*3)/2.0;
    aaL.textAlignment = NSTextAlignmentCenter;
    //调用方法，转化成Image
    UIImage *image = [self imageWithUIView:aaL];
    //创建Image的富文本格式
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.bounds = CGRectMake(0, -2.5, aaW, 16); //这个-2.5是为了调整下标签跟文字的位置
    attach.image = image;
    //添加到富文本对象里
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    [maTitleString insertAttributedString:imageStr atIndex:0];//加入文字前面
    //[maTitleString appendAttributedString:imageStr];//加入文字后面
    //[maTitleString insertAttributedString:imageStr atIndex:4];//加入文字第4的位置

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    
    [maTitleString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, maTitleString.length)];
    [maTitleString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, maTitleString.length)];

    //注意 ：创建这个Label的时候，frame，font，cornerRadius要设置成所生成的图片的3倍，也就是说要生成一个三倍图，否则生成的图片会虚，同学们可以试一试。
    self.attributedText = maTitleString;
}
//view转成image
- (UIImage*) imageWithUIView:(UIView*) view{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}
@end
