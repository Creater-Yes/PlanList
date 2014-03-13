//
//  DetailListViewController.h
//  PlanList
//
//  Created by dingql on 14-3-13.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlanList;

@interface DetailListViewController : UITableViewController
@property(nonatomic, strong) PlanList * list;
@end
