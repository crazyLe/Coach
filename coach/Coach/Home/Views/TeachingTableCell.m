//
//  TeachingTableCell.m
//  Coach
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "TeachingTableCell.h"

@implementation TeachingTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
}

- (void)setArticleModel:(TeachArticleModel *)articleModel
{
    _articleModel = articleModel;
    
    [_topImagView sd_setImageWithURL:[NSURL URLWithString:[_articleModel.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"TSkills_top.png"]];
    _titleLabel.text = articleModel.articleTitle;
    _contentLabel.text = articleModel.articleContent;
    _scanLabel.text = articleModel.articleView;
    _praiseLabel.text = articleModel.articleLike;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
