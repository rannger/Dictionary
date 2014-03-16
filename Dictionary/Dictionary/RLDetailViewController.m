//
//  RLDetailViewController.m
//  Dictionary
//
//  Created by rannger on 14-3-14.
//  Copyright (c) 2014年 rannger. All rights reserved.
//

#import "RLDetailViewController.h"
#import "RLWord.h"
#import "CoreFunctions.h"

@interface RLDetailViewController ()
{
    NSArray* descList;
}

@end

@implementation RLDetailViewController
@synthesize detail;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.detail loadAllInfo:^(RLWord *word) {
        NSMutableArray* array=[NSMutableArray arrayWithCapacity:20];
        [array addObject:@[word.word]];
        {
            NSMutableArray* list=[NSMutableArray arrayWithCapacity:2];
            if (IsStringWithAnyText(word.attr)) {
                [list addObject:[NSString stringWithFormat:@"词性：%@",word.attr]];
            }
            if (IsStringWithAnyText(word.protoType)) {
                [list addObject:[NSString stringWithFormat:@"原型：%@",word.protoType]];
            }
            [array addObject:list];
        }
        NSMutableArray* list=[NSMutableArray arrayWithObject:@"解释："];
        [list addObjectsFromArray:word.descList];
        [array addObject:list];
        descList=[[NSArray alloc] initWithArray:array];
        [self.tableView reloadData];
    }];

    if ([detail isCollect]) {
        UIBarButtonItem* item=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                            target:self
                                                                            action:@selector(remove)];
        self.navigationItem.rightBarButtonItem=item;
    }
    else
    {
        UIBarButtonItem* item=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(collect)];
        self.navigationItem.rightBarButtonItem=item;
    }

}


- (void)collect
{
    if ([self.detail fav]) {
        UIBarButtonItem* item=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                            target:self
                                                                            action:@selector(remove)];
        self.navigationItem.rightBarButtonItem=item;
    }

}

- (void)remove
{
    if ([self.detail unfav]) {
        UIBarButtonItem* item=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(collect)];
        self.navigationItem.rightBarButtonItem=item;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [descList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [descList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        cell.textLabel.font=[UIFont fontWithName:@"Verdana-Italic" size:30];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.numberOfLines=0;
        cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    }
    else
    {
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        cell.textLabel.font=[UIFont fontWithName:@"BanglaSangamMN-Bold" size:20];
        cell.textLabel.numberOfLines=0;
        cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    }
    

    cell.textLabel.text=descList[indexPath.section][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 20;
    }
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* string=descList[indexPath.section][indexPath.row];
    if (indexPath.section==0) {
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Verdana-Italic" size:30] forKey: NSFontAttributeName];
        
        CGSize expectedLabelSize2 = [string boundingRectWithSize:CGSizeMake(165, CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:stringAttributes context:nil].size;
        return expectedLabelSize2.height>44?expectedLabelSize2.height:44;
    }
    else
    {
        
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"BanglaSangamMN-Bold" size:20] forKey: NSFontAttributeName];
        
        CGSize expectedLabelSize2 = [string boundingRectWithSize:CGSizeMake(180, CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:stringAttributes context:nil].size;
        return expectedLabelSize2.height>44?expectedLabelSize2.height:44;
    }
    return 44;
}

@end
