//
//  RLWord.h
//  Dictionary
//
//  Created by rannger on 14-3-10.
//  Copyright (c) 2014年 rannger. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  word object
 */
@interface RLWord : NSObject
{
    NSInteger wordId;
    NSString* word;
    NSString* attr;
    NSString* protoType;
    NSArray* descList;
}
/**
 *  word's id in database
 */
@property (nonatomic) NSInteger wordId;
@property (nonatomic,copy) NSString* word;
@property (nonatomic,copy) NSString* attr;
@property (nonatomic,copy) NSString* protoType;
@property (nonatomic,strong) NSArray* descList;
+ (NSArray*)wordByFirstChar:(NSString*)prefix;
- (void)loadAllInfo:(void (^)(RLWord* word))finishBlock;
- (BOOL)fav;
+ (NSArray*)allFavWords;
- (BOOL)isCollect;
- (BOOL)unfav;
@end
