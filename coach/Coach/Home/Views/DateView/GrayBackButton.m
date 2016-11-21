//
//  GrayBackButton.m
//  Coach
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "GrayBackButton.h"

#import "EarnExtraFisrtCell.h"
#import "EarnExtraSecondCell.h"
#import "EarnExtraThirdCell.h"
#import "EarnExtraFourthCell.h"
#import "EarnExtraFifthCell.h"

@interface GrayBackButton ()<UITableViewDelegate,UITableViewDataSource>
{
    
}

@end

@implementation GrayBackButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithSubViews];
    }
    return self;
}

- (void)initWithSubViews
{
    _addHoursTable = [[UITableView alloc]initWithFrame:CGRectMake((kScreenWidth-292)/2, (kScreenHeight-390)/2, 292, 390) style:UITableViewStylePlain];
    _addHoursTable.delegate = self;
    _addHoursTable.dataSource = self;
    _addHoursTable.layer.cornerRadius = 8.0;
    _addHoursTable.scrollEnabled = NO;
    _addHoursTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_addHoursTable];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _addHoursTable.frame.size.width, 46)];
    //    topView.backgroundColor = [UIColor redColor];
    _addHoursTable.tableHeaderView = topView;
    
    UILabel * chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake((topView.frame.size.width-80)/2, 15, 80, 16)];
    //    chooseLabel.backgroundColor = [UIColor orangeColor];
    chooseLabel.text = @"添加学时";
    chooseLabel.textColor = rgb(35, 105, 255);
    chooseLabel.font = Font18;
    [topView addSubview:chooseLabel];
    
    UIButton * cancelBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(topView.frame.size.width-15-15, 15, 15, 15);
    //    cancelBtn.backgroundColor = [UIColor redColor];
    cancelBtn.contentMode = UIViewContentModeScaleAspectFit;
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"earn_close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelBtn];
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chooseLabel.frame)+14, topView.frame.size.width, 1)];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#b7d6ff"];
    [topView addSubview:lineLabel];
    
    UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _addHoursTable.frame.size.width, 76)];
    downView.backgroundColor = [UIColor whiteColor];
    _addHoursTable.tableFooterView = downView;
    
    UIButton * saveBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake((_addHoursTable.frame.size.width-105)/2, 10, 105, 37);
    saveBtn.layer.cornerRadius = 18.5;
    saveBtn.titleLabel.font = Font15;
    saveBtn.backgroundColor = [UIColor colorWithHexString:@"#2e83ff"];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(pressSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:saveBtn];
    
}

- (void)cancelBtnClick
{
    
}

- (void)pressSaveBtn
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 5){
        return 60;
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        static NSString * string = @"cellone";
        EarnExtraFisrtCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraFisrtCell" owner:self options:nil]lastObject];
        }
        
        //        EarnOneCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        //        if (cell == nil) {
        //            cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnOneCell" owner:self options:nil]lastObject];
        //        }
        //        cell.backgroundColor = [UIColor cyanColor];
        return cell;
    }else if (indexPath.row == 1){
        static NSString * string = @"celltwo";
        EarnExtraSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraSecondCell" owner:self options:nil]lastObject];
        }
        //        cell.backgroundColor = [UIColor cyanColor];
        return cell;
        
    }else if (indexPath.row == 2){
        static NSString * string = @"cellthree";
        EarnExtraThirdCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraThirdCell" owner:self options:nil]lastObject];
        }
        //        cell.backgroundColor = [UIColor cyanColor];
        return cell;
        
    }else if(indexPath.row == 3){
        static NSString * string = @"cellfour";
        EarnExtraFourthCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraFourthCell" owner:self options:nil]lastObject];
        }
        return cell;
    }else if(indexPath.row == 4){
        static NSString * string = @"cellfive";
        EarnExtraFourthCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraFourthCell" owner:self options:nil]lastObject];
        }
        cell.infoLabel.text = @"价格:";
        cell.personLabel.text = @"元/人";
        return cell;
    }else{
        
        static NSString * string = @"cellsix";
        EarnExtraFifthCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EarnExtraFifthCell" owner:self options:nil]lastObject];
        }
        return cell;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
