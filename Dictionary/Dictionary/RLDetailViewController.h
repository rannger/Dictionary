//
//  RLDetailViewController.h
//  Dictionary
//
//  Created by rannger on 14-3-14.
//  Copyright (c) 2014年 rannger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLWord;
@interface RLDetailViewController : UITableViewController
{
    RLWord* detail;
}

@property (nonatomic,strong) RLWord* detail;

@end
