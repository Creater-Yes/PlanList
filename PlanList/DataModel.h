//
//  DataModel.h
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property(nonatomic, strong) NSMutableArray * lists;

- (void)savePlanLists;
- (int)indexOfSelectedPlanlist;
- (void)setIndexOfSelectedPlanlist:(int)index;
+ (int)nextPlanlistItemID;
@end
