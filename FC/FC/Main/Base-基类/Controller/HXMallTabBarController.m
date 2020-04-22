//
//  HXMallTabBarController.m
//  FC
//
//  Created by huaxin-01 on 2020/4/22.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "HXMallTabBarController.h"
#import "UIImage+HXNExtension.h"
#import "HXNavigationController.h"
#import "FCMallHomeVC.h"
#import "FCMallOrderVC.h"


@interface HXMallTabBarController ()

@end

@implementation HXMallTabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hbd_barHidden = YES;
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    attrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x999999);
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = HXControlBg;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [self setupChildVc:[[FCMallHomeVC alloc] init] title:@"首页" image:@"首页灰" selectedImage:@"首页选中"];
    [self setupChildVc:[[FCMallOrderVC alloc] init] title:@"订单" image:@"订单灰" selectedImage:@"订单选中"];
        
    // 设置透明度和背景颜色
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    self.tabBar.translucent = NO;//这句表示取消tabBar的透明效果。
    [self.tabBar setShadowImage:[UIImage imageWithColor:UIColorFromRGB(0xEEEEEE) size:CGSizeMake(HX_SCREEN_WIDTH, 1)]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    
//    if (@available(iOS 13.0, *)) {
//        UITabBarAppearance *appearance = [UITabBarAppearance new];
//        appearance.shadowColor = UIColorFromRGB(0xEEEEEE);
//        appearance.backgroundColor = [UIColor whiteColor];
                        
//        UITabBarItemStateAppearance *normalAppearance = appearance.stackedLayoutAppearance.normal;
//        normalAppearance.titleTextAttributes = attrs;
//
//        UITabBarItemStateAppearance *selectedAppearance = appearance.stackedLayoutAppearance.selected;
//        selectedAppearance.titleTextAttributes = selectedAttrs;
        
//        self.tabBar.standardAppearance = appearance;
//    }else{
//        UITabBarItem *item = [UITabBarItem appearance];
//        [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
//        [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
        
//        [self.tabBar setShadowImage:[UIImage imageWithColor:UIColorFromRGB(0xEEEEEE) size:CGSizeMake(HX_SCREEN_WIDTH, 1)]];
//        [self.tabBar setBackgroundImage:[UIImage new]];
//    }
    
}
/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.title = title;
    
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 包装一个自定义的导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
