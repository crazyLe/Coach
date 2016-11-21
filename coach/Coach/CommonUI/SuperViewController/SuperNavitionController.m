//
//  SuperNavitionController.m
//  idea
//
//  Created by xls on 16/1/27.
//  Copyright © 2016年 mobisoft. All rights reserved.
//

#import "SuperNavitionController.h"

@interface SuperNavitionController ()

@end

@implementation SuperNavitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器

        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    

    [super pushViewController:viewController animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
