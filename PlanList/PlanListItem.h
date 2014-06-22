//
//  PlanListItem.h
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanListItem : NSObject<NSCoding>
@property(nonatomic, copy) NSString * itemName;
@property(nonatomic, assign) BOOL itemState;
@property(nonatomic, assign) BOOL itemShoudRemind;
@property(nonatomic, strong) NSDate * itemRemindDate;
@property(nonatomic, assign) int itemID;

- (void)scheduleNotification;
@end
