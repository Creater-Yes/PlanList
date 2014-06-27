//
//  MainViewController.h
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface MainViewController : UIViewController

@property(nonatomic, strong) DataModel * data;
@end


@interface UISearchDisplayController (catlog)
- (id)initWithSearchBar:(UISearchBar *)searchBar contentsControllerOfMy:(UIViewController *)viewController;
@end