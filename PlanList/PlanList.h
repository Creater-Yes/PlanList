//
//  PlanList.h
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanList : NSObject
@property(nonatomic, copy) NSString * listTitle;
@property(nonatomic, copy) NSString * listIconName;
@property(nonatomic, strong) NSMutableArray * items;
@end
