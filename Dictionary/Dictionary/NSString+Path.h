//
//  NSString+Path.h
//  Note
//
//  Created by rannger on 14-3-8.
//  Copyright (c) 2014年 rannger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)
/**
 *  path of document directory
 *
 *  @return app's document directory path.
 */
+ (NSString *)documentsDirectory;
@end
