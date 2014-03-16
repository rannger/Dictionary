//
//  RLWord.m
//  Dictionary
//
//  Created by rannger on 14-3-10.
//  Copyright (c) 2014年 rannger. All rights reserved.
//

#import "RLWord.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "RLDB.h"

@implementation RLWord
@synthesize wordId;
@synthesize word;
@synthesize attr;
@synthesize protoType;
@synthesize descList;


+ (NSArray*)wordByFirstChar:(NSString*)prefix
{
    static NSString* sqlTemplate=@"select id,word from words indexed by wordi where word like '%@%%' collate nocase;";
    static NSString* sqlCountTemplate=@"select count(*) from words indexed by wordi where word like '%@%%' collate nocase;";
    NSString* sql=[NSString stringWithFormat:sqlTemplate,prefix];
    NSString* sqlCount=[NSString stringWithFormat:sqlCountTemplate,prefix];
    FMDatabase* db=[RLDB getDB];
    NSInteger count=[db intForQuery:sqlCount];
    FMResultSet* resultSet=[db executeQuery:sql];
    NSMutableArray* array=[NSMutableArray arrayWithCapacity:count];
    while ([resultSet next]) {
        RLWord* item=[[RLWord alloc] init];
        item.wordId=[resultSet intForColumn:@"id"];
        item.word=[resultSet stringForColumn:@"word"];
        [array addObject:item];
    }
    [resultSet close];
    [db close];
    
    return [NSArray arrayWithArray:array];
}

- (void)loadAllInfo:(void (^)(RLWord* word))finishBlock
{
    static NSString* selectWordItem=@"select id,attr,prototype from worditem indexed by worditemi where wordid=%d";
    static NSString* selectWordDescItem=@"select explanation from worddesc indexed by worddesci where wordid=%d and worditemid=%d;";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Here your non-main thread.
        NSString* sql=[NSString stringWithFormat:selectWordItem,self.wordId];
        FMDatabase* db=[RLDB getDB];
        FMResultSet* resultSet=[db executeQuery:sql];
        NSInteger worditemId=0;
        while ([resultSet next]) {
            worditemId=[resultSet intForColumn:@"id"];
            self.attr=[resultSet stringForColumn:@"attr"];
            self.protoType=[resultSet stringForColumn:@"prototype"];
        }
        [resultSet close];
        NSMutableArray* array=[NSMutableArray arrayWithCapacity:5];
        NSString* sql2=[NSString stringWithFormat:selectWordDescItem,self.wordId,worditemId];
        resultSet=[db executeQuery:sql2];
        while ([resultSet next]) {
            NSString* desc=[resultSet stringForColumn:@"explanation"];
            [array addObject:desc];
        }
        self.descList=[NSArray arrayWithArray:array];
        [db close];
        dispatch_async(dispatch_get_main_queue(), ^{
            finishBlock(self);
        });
    });
}

- (BOOL)fav
{
    static NSString* sqlTemplate=@"insert or replace into fav (wordid) values (%d);";
    NSString* sql=[NSString stringWithFormat:sqlTemplate,wordId];
    FMDatabase* db=[RLDB getDB];
    BOOL retval=[db executeUpdate:sql];
    
    [db close];
    return retval;
}

- (BOOL)unfav
{
    static NSString* sqlTemplate=@"delete from fav where wordid=%d;";
    NSString* sql=[NSString stringWithFormat:sqlTemplate,wordId];
    FMDatabase* db=[RLDB getDB];
    BOOL retval=[db executeUpdate:sql];
    
    [db close];
    return retval;
}

+ (NSArray*)allFavWords
{
    static NSString* sql=@"select id,word from words where id in (select wordid from fav);";
    FMDatabase* db=[RLDB getDB];
    FMResultSet* resultSet=[db executeQuery:sql];
    NSMutableArray* array=[NSMutableArray arrayWithCapacity:100];
    while ([resultSet next]) {
        RLWord* item=[[RLWord alloc] init];
        item.wordId=[resultSet intForColumn:@"id"];
        item.word=[resultSet stringForColumn:@"word"];
        [array addObject:item];
    }
    [db close];
    return [NSArray arrayWithArray:array];
}

- (BOOL)isCollect
{
    static NSString* sqlTemplate=@"select count(id) from fav where wordid=%d;";
    FMDatabase* db=[RLDB getDB];
    NSString* sql=[NSString stringWithFormat:sqlTemplate,wordId];
    BOOL retval=[db intForQuery:sql]>=1;
    [db close];
    return retval;
}

@end
