//
//  VouchersCell.h
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/19.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VouchersCell;

@protocol VouchersCellDelegate <NSObject>

- (void)VouchersCell:(VouchersCell *)cell clickRePublicBtn:(UIButton *)republicBtn;

@end

@interface VouchersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftbg;
@property (weak, nonatomic) IBOutlet UIImageView *rightbg;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *send;

@property (weak, nonatomic) IBOutlet UILabel *juan;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id delegate;

@end
