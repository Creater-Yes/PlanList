//
//  ItemsOfPlanListViewController.h
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlanList;
@class ItemsOfPlanListViewController;

@protocol ItemsOfPlanListViewControllerDelegate <NSObject>

- (void)ItemsOfPlanListController:(ItemsOfPlanListViewController *)controller didFinishAddPlanList:(PlanList *)list;

- (void)ItemsOfPlanListController:(ItemsOfPlanListViewController *)controller didFinishEditPlanList:(PlanList *)list;

- (void)ItemsOfPlanListControllerDidCancel:(ItemsOfPlanListViewController *)controller;

@end

@interface ItemsOfPlanListViewController : UITableViewController
@property(nonatomic, strong) PlanList * list;
@property(nonatomic, assign) id<ItemsOfPlanListViewControllerDelegate> delegate;
@end
