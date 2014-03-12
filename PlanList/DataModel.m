//
//  DataModel.m
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (id)init
{
    if (self = [super init]) {
        self.lists = [NSMutableArray array];
    }
    
    return self;
}

@end
