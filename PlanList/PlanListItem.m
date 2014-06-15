//
//  PlanListItem.m
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "PlanListItem.h"

@implementation PlanListItem

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.itemName = [aDecoder decodeObjectForKey:@"itemName"];
        self.itemRemindDate = [aDecoder decodeObjectForKey:@"remindDate"];
        self.itemShoudRemind = [aDecoder decodeBoolForKey:@"shouldRemind"];
        self.itemState = [aDecoder decodeBoolForKey:@"itemState"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_itemName forKey:@"itemName"];
    [aCoder encodeObject:_itemRemindDate forKey:@"remindDate"];
    [aCoder encodeBool:_itemShoudRemind forKey:@"shouldRemind"];
    [aCoder encodeBool:_itemState forKey:@"itemState"];
}

@end
