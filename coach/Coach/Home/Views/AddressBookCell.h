//
//  AddressBookCell.h
//  Coach
//
//  Created by gaobin on 16/8/1.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "PersonModel.h"
#import <UIKit/UIKit.h>

@class AddressBookCell;

@protocol AddressBookCellDelegate <NSObject>

- (void)AddressBookCell:(AddressBookCell *)cell clickSubjectBgView:(UIView *)subjectBgView;

@end

@interface AddressBookCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *isSelectBtn;
@property (weak, nonatomic) IBOutlet UILabel *namaLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *subjectBgView;
@property (weak, nonatomic) IBOutlet UILabel *subjectLab;
@property (weak, nonatomic) IBOutlet UIButton *subjectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subjectTrailing;

@property (nonatomic,strong)PersonModel *personModel;

@property (nonatomic,assign) id delegate;

@end
