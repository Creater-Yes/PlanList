//
//  MainViewController.h
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataModel;

@interface MainViewController : UITableViewController
@property(nonatomic, strong) DataModel * data;
@end
