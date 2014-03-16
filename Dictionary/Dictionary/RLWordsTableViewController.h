//
//  RLWordsTableViewController.h
//  Dictionary
//
//  Created by rannger on 14-3-15.
//  Copyright (c) 2014年 rannger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLWordsTableViewController : UITableViewController <UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSArray* words;
}

@property (nonatomic,strong) NSArray* words;
- (void)reload;
@end
