//
//  NotificationNameConst.m
//  醉了么
//
//  Created by zuweizhong  on 16/6/4.
//  Copyright © 2016年 Hefei JiuYi Network Technology Co.,Ltd. All rights reserved.
//

NSString  * const kUpdateHeadNotification = @"ccdds";

NSString  * const kRefreshProductIsCollectionStatus = @"scdsc";

NSString * StringFromCGPoint(CGPoint point)
{
    CGFloat x = point.x;
    CGFloat y = point.y;
    return [NSString stringWithFormat:@"x:%f  y:%f",x,y];
}






