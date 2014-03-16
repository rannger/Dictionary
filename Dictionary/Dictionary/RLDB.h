//
//  RLDB.h
//  Dictionary
//
//  Created by rannger on 14-3-10.
//  Copyright (c) 2014年 rannger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface RLDB : NSObject
+ (void)copyDic;
+ (FMDatabase*)getDB;
@end
