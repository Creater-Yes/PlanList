//
//  DatePickerViewController.h
//  PlanList
//
//  Created by dingql on 14-3-16.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerViewController;

@protocol DatePickerViewControllerDelegate <NSObject>

- (void)DatePicker:(DatePickerViewController *)controller didFinishPickDate:(NSDate *)date;

@end

@interface DatePickerViewController : UIViewController
@property(nonatomic, strong) NSDate * date;
@property(nonatomic, assign) id<DatePickerViewControllerDelegate> delegate;
@end
