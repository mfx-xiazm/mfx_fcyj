//
//  FCAddOutContractVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/16.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCAddOutContractVC.h"
#import "HXPlaceholderTextView.h"
#import "ZJPickerView.h"
#import "FCContractTemplateVC.h"
#import "FCChooseHouseVC.h"
#import "FCChooseClientVC.h"
#import "FCGoodsJointVC.h"

@interface FCAddOutContractVC ()
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;

@end

@implementation FCAddOutContractVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"添加合同"];
    self.remark.placeholder = @"请输入电子合同补充字段";
}
- (IBAction)contractSetClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        [self showContractTypePicker];
    }else if (sender.tag == 2) {
        FCContractTemplateVC *tvc = [FCContractTemplateVC new];
        [self.navigationController pushViewController:tvc animated:YES];
    }else if (sender.tag == 3) {
        FCChooseClientVC *tvc = [FCChooseClientVC new];
        [self.navigationController pushViewController:tvc animated:YES];
    }else if (sender.tag == 4) {
        FCChooseHouseVC *tvc = [FCChooseHouseVC new];
        [self.navigationController pushViewController:tvc animated:YES];
    }else{
        FCGoodsJointVC *tvc = [FCGoodsJointVC new];
        [self.navigationController pushViewController:tvc animated:YES];
    }
}
-(void)showContractTypePicker
{
    // 1.Custom propery（自定义属性）
    NSDictionary *propertyDict = @{
                                   ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
                                   ZJPickerViewPropertySureBtnTitleKey  : @"确定",
                                   //ZJPickerViewPropertyTipLabelTextKey  : (textKey&&textKey.length)?textKey:@"选择贷款年限", // 提示内容
                                   ZJPickerViewPropertyTipLabelTextKey  :@"选择合同性质", // 提示内容
                                   ZJPickerViewPropertyCanceBtnTitleColorKey : UIColorFromRGB(0x999999),
                                   ZJPickerViewPropertySureBtnTitleColorKey : UIColorFromRGB(0x845D32),
                                   ZJPickerViewPropertyTipLabelTextColorKey :
                                       UIColorFromRGB(0x131D2D),
                                   ZJPickerViewPropertyLineViewBackgroundColorKey : UIColorFromRGB(0xCCCCCC),
                                   ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:13.0f],
                                   ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:13.0f],
                                   ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:13.0f],
                                   ZJPickerViewPropertyPickerViewHeightKey : @260.0f,
                                   ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
                                   ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x845D32), NSFontAttributeName : [UIFont systemFontOfSize:13.0f]},
                                   ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x999999), NSFontAttributeName : [UIFont systemFontOfSize:13.0f]},
                                   ZJPickerViewPropertySelectRowLineBackgroundColorKey : UIColorFromRGB(0xCCCCCC),
                                   ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                   ZJPickerViewPropertyIsShowSelectContentKey : @YES,
                                   ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
                                   ZJPickerViewPropertyIsAnimationShowKey : @YES};
    
    // 2.Show（显示）
//    hx_weakify(self);
    [ZJPickerView zj_showWithDataList:@[@"新签合同",@"续签合同",@"新签合同",@"续签合同",@"新签合同",@"续签合同"] propertyDict:propertyDict completion:^(NSString *selectContent) {
//        hx_strongify(weakSelf);
        // show select content|
//        NSArray *results = [selectContent componentsSeparatedByString:@"|"];
//
//        NSArray *years = [results.firstObject componentsSeparatedByString:@","];
//
//        NSArray *rows = [results.lastObject componentsSeparatedByString:@","];
//
//        years.firstObject rows.firstObject
    }];
}


@end
