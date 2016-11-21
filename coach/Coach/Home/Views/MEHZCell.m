//
//  MEHZCell.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "MEHZCell.h"
#import "UIColor+Hex.h"

#import "Utilities.h"

@implementation MEHZCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _personnum.layer.cornerRadius = 5;
    _personnum.layer.borderColor = [UIColor colorWithHexString:@"#fea700"].CGColor;
    _personnum.layer.borderWidth = 1.0;
    
    _placestatue.layer.cornerRadius = 5;
    _placestatue.layer.borderColor = [UIColor colorWithHexString:@"#ff6866"].CGColor;
    _placestatue.layer.borderWidth = 1.0;
}
- (IBAction)ownClick:(UIButton *)sender {
    
    self.push(_examQuotaRelease);
}
- (void)setExamQuotaRelease:(ExamQuotaReleaseModel *)examQuotaRelease {
    
    _examQuotaRelease = examQuotaRelease;
    
    self.place.text = examQuotaRelease.address;
    self.personnum.text = [examQuotaRelease.peopleNum isEqualToString:@"0"]?nil:[NSString stringWithFormat:@"%@人",examQuotaRelease.peopleNum];
    self.personnum.text = [NSString stringWithFormat:@"%@人", isEmptyStr(examQuotaRelease.peopleNum)?@"":examQuotaRelease.peopleNum];
    self.placestatue.text = examQuotaRelease.region;
    self.explain.text = examQuotaRelease.content;
    NSString * timeString = [Utilities calculateTimeWithFaceTimeDayTarget:examQuotaRelease.addtime];
    self.time.text = timeString;
    
    
    
}
//- (void)setQuotaCooperate:(QuotaCooperateModel *)quotaCooperate {
//    
//    _quotaCooperate = quotaCooperate;
//    
//    self.place.text = quotaCooperate.adress;
//    self.personnum.text = [quotaCooperate.peopleNum isEqualToString:@"0"]?nil:[NSString stringWithFormat:@"%@人",quotaCooperate.peopleNum];
//    self.personnum.text = [NSString stringWithFormat:@"%@人",quotaCooperate.peopleNum];
//    self.placestatue.text = quotaCooperate.region;
//    self.explain.text = quotaCooperate.content;
//    NSString * timeString = [Utilities calculateTimeWithFaceTimeDayTarget:quotaCooperate.addtime];
//    self.time.text = timeString;
//
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
