//
//  FCSignCodeVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/18.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCSignCodeVC.h"
#import "SGQRCodeObtain.h"

@interface FCSignCodeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

@end

@implementation FCSignCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"签约二维码"];
    self.codeImage.image = [SGQRCodeObtain generateQRCodeWithData:@"二维码数据" size:self.codeImage.hxn_size.width*3];
}
@end
