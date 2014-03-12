//
//  PlanList.m
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "PlanList.h"

@implementation PlanList

- (id)init
{
    if (self = [super init]) {
        self.listTitle = @"";
        self.listIconName = @"NO Icon";
        self.items = [NSMutableArray array];
    }
    return self;
}

@end
