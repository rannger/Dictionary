//
//  RLDB.m
//  Dictionary
//
//  Created by rannger on 14-3-10.
//  Copyright (c) 2014年 rannger. All rights reserved.
//

#import "RLDB.h"
#import "NSString+Path.h"
#import "FMDatabase.h"
#import "GZIP.h"

@implementation RLDB

+ (NSString*)databasePath
{
    static NSString* databaseName=@"word.db";
    return [[NSString documentsDirectory] stringByAppendingPathComponent:databaseName];
}

+ (FMDatabase*)getDB
{
    FMDatabase* db= [FMDatabase databaseWithPath:[[self class] databasePath]];
    [db open];
    return db;
}

+ (void)copyDic
{

    NSString* dictPathInDocumentDir=[self databasePath];
    NSFileManager* fileMgr=[NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:dictPathInDocumentDir]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Here your non-main thread.
            NSString* dictPathInBundle=[[NSBundle mainBundle] pathForResource:@"word.db.gz" ofType:nil];
            NSData* data=[NSData dataWithContentsOfFile:dictPathInBundle];
            NSData* unzipData=[data gunzippedData];
            NSAssert(unzipData, @"can't unzipData");
            NSError* error=nil;
            BOOL result=[unzipData writeToFile:dictPathInDocumentDir atomically:YES];
            //        BOOL result=[fileMgr copyItemAtPath:dictPathInBundle toPath:dictPathInDocumentDir error:&error];
            NSAssert(result, @"%@",error);
            unzipData=nil;
            data=nil;
        });

    }
}



@end
