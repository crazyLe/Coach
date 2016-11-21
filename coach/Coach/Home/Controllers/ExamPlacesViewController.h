//
//  ExamPlacesViewController.h
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "SuperViewController.h"

typedef NS_ENUM(NSInteger ,ExamPlacesType){
    
    ExamPlacesBuy ,
    ExamPlacesSell
};

@interface ExamPlacesViewController : SuperViewController

@property (nonatomic, strong) NSString *numString;

@end
