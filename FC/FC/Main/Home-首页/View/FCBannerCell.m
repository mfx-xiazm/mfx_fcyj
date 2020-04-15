//
//  FCBannerCell.m
//  FC
//
//  Created by huaxin-01 on 2020/4/15.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCBannerCell.h"

@interface FCBannerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *content_img;

@end
@implementation FCBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.content_img sd_setImageWithURL:[NSURL URLWithString:@"http://a3.att.hudong.com/14/75/01300000164186121366756803686.jpg"]];
}

@end
