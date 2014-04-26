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

- (NSString *)documentDirectory
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentDirectory] stringByAppendingPathComponent:@"planlist.plist"];
}

- (void)saveData
{
    
    [self.lists writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadData
{
    NSString * path = [self dataFilePath];
    NSError * error = nil;
    NSData * data = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:&error];
    
    NSAssert(error == nil, @"error:%@", error);
    NSLog(@"data:%@", data);
    
    
}

@end
