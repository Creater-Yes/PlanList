//
//  AppDelegate.h
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController * navigationController;
@property (nonatomic, strong) DataModel * data;
@end
