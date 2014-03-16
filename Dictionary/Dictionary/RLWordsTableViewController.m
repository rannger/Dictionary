//
//  RLWordsTableViewController.m
//  Dictionary
//
//  Created by rannger on 14-3-15.
//  Copyright (c) 2014年 rannger. All rights reserved.
//

#import "RLWordsTableViewController.h"
#import "RLWord.h"
#import "CoreFunctions.h"
#import "RLDetailViewController.h"

@interface RLWordsTableViewController ()
{
    NSMutableArray* searchResult;
    UISearchDisplayController* searchDisplayController;
}

@end

@implementation RLWordsTableViewController
@synthesize words;

- (void)dealloc
{
    words=nil;
    searchResult=nil;
    searchDisplayController=nil;
}

- (id)init
{
    self=[super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UISearchBar* searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44+20)];
    searchBar.delegate=self;
    searchBar.barTintColor=[UIColor blackColor];

    searchDisplayController=[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.searchResultsDelegate=self;
    searchDisplayController.searchResultsDataSource=self;
    searchDisplayController.delegate=self;
    searchDisplayController.displaysSearchBarInNavigationBar=YES;
    self.searchDisplayController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    if (!IsArrayWithAnyObj(words)) {
        [self.tableView reloadData];
    }
}

- (void)reload
{
    searchResult=[[NSMutableArray alloc] initWithCapacity:[words count]];
     [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.tableView) {
        return [words count];
    }
    return [searchResult count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    RLWord* word=nil;
    if (tableView==self.tableView) {
        word=words[indexPath.row];
    }
    else
    {
        word=searchResult[indexPath.row];
    }
    cell.textLabel.text=word.word;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        RLWord* word=nil;
    if (tableView==self.tableView) {
        word=words[indexPath.row];
    }
    else
    {
        word=searchResult[indexPath.row];
    }
    RLDetailViewController* ctrl=[[RLDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.detail=word;
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark - UISearchDisplayDelegate
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    [controller.searchBar setShowsCancelButton:YES animated:YES];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [controller.searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    [searchResult removeAllObjects];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchDisplayController setActive:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [searchResult removeAllObjects];
    if (IsStringWithAnyText(searchText)) {
        for (RLWord* word in words) {
            if ([word.word hasPrefix:searchText]) {
                [searchResult addObject:word];
            }
        }
        
    }
    [self.searchDisplayController.searchResultsTableView reloadData];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.searchDisplayController setActive:NO];
}

@end
