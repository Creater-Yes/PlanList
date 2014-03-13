//
//  ItemsInDetailListViewController.h
//  PlanList
//
//  Created by dingql on 14-3-13.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlanListItem;
@class ItemsInDetailListViewController;

@protocol ItemsInDetailListViewControllerDelegate <NSObject>

- (void)ItemsController:(ItemsInDetailListViewController *)controller didFinishAddItem:(PlanListItem *)item;

- (void)ItemsController:(ItemsInDetailListViewController *)controller didFinishEditItem:(PlanListItem *)item;

- (void)ItemsControllerDidCancel:(ItemsInDetailListViewController *)controller;

@end

@interface ItemsInDetailListViewController : UITableViewController
@property(nonatomic, assign) id<ItemsInDetailListViewControllerDelegate> delegate;
@property(nonatomic, strong) PlanListItem * item;
@end
