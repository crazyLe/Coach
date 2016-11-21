//
//  EditThirdDetailCell.h
//  Coach
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardTgaModel;

@interface EditThirdDetailCell : UITableViewCell

@property (nonatomic,assign) NSInteger index;

@property (nonatomic, strong)CardTgaModel * tgaModel;

@end
