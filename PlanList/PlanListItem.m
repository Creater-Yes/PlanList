//
//  PlanListItem.m
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "PlanListItem.h"
#import "DataModel.h"

@implementation PlanListItem

- (id)init
{
    if (self = [super init]) {
        self.itemID = [DataModel nextPlanlistItemID];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.itemName = [aDecoder decodeObjectForKey:@"itemName"];
        self.itemRemindDate = [aDecoder decodeObjectForKey:@"remindDate"];
        self.itemShoudRemind = [aDecoder decodeBoolForKey:@"shouldRemind"];
        self.itemState = [aDecoder decodeBoolForKey:@"itemState"];
        self.itemID = [aDecoder decodeIntForKey:@"itemID"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_itemName forKey:@"itemName"];
    [aCoder encodeObject:_itemRemindDate forKey:@"remindDate"];
    [aCoder encodeBool:_itemShoudRemind forKey:@"shouldRemind"];
    [aCoder encodeBool:_itemState forKey:@"itemState"];
    [aCoder encodeInt:_itemID forKey:@"itemID"];
}

- (UILocalNotification *)notificationForThisItem
{
    NSArray * allNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    for (UILocalNotification * notification in allNotifications) {
        NSNumber * number = [notification.userInfo objectForKey:@"ItemID"];
        if (number != nil && number.intValue == self.itemID) {
            return notification;
        }
    }
    return nil;
}

- (void)scheduleNotification
{
    UILocalNotification * existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        NSLog(@"Found an existing notification %@", existingNotification);
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
    }
    if (_itemShoudRemind && [_itemRemindDate compare:[NSDate date]] != NSOrderedAscending) {
        UILocalNotification * localNotification = [[UILocalNotification alloc]init];
        localNotification.fireDate = _itemRemindDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = _itemName;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:_itemID] forKey:@"ItemID"];
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
        NSLog(@"Scheduled notification %@ for itemID %d", localNotification, _itemID);
    }
}

- (void)dealloc
{
    UILocalNotification * existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        NSLog(@"Removing existing notification %@", existingNotification);
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
    }
}


@end
