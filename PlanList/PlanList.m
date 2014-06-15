//
//  PlanList.m
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "PlanList.h"
#import "PlanListItem.h"

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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.listIconName = [aDecoder decodeObjectForKey:@"iconName"];
        self.listTitle = [aDecoder decodeObjectForKey:@"title"];
        self.items = [aDecoder decodeObjectForKey:@"items"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_listTitle forKey:@"title"];
    [aCoder encodeObject:_listIconName forKey:@"iconName"];
    [aCoder encodeObject:_items forKey:@"items"];
}

@end
