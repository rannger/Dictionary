//
//  CoreFunctions.c
//  Note
//
//  Created by rannger on 14-3-8.
//  Copyright (c) 2014年 rannger. All rights reserved.
//

#import "CoreFunctions.h"

BOOL IsStringWithAnyText(id obj)
{
    return [obj isKindOfClass:[NSString class]]&&[obj length]>0;
}

BOOL IsArrayWithAnyObj(id obj)
{
    return [obj isKindOfClass:[NSArray class]]&&[obj count]>0;
}
