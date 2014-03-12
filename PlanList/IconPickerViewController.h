//
//  IconPickerViewController.h
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IconPickerViewController;

@protocol IconPickerViewControllerDelegate <NSObject>

- (void)IconPickerViewController:(IconPickerViewController *)controller DidFinishPickIcon:(NSString *)iconName;

@end

@interface IconPickerViewController : UITableViewController
@property(nonatomic, assign) id<IconPickerViewControllerDelegate> delegate;
@end
