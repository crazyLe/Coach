//
//  MCoachThirdCell.h
//  Coach
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MCoachThirdCellDelegate <NSObject>

- (void)clickMCoachThirdCellDelegateUploadBtn:(UIButton *)uploadBtn WithIndex:(NSInteger)index;

@end

@interface MCoachThirdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *caseImageView;
@property (weak, nonatomic) IBOutlet UILabel *caseLabel;

@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign) id<MCoachThirdCellDelegate>delegate;

@end
