//
//  RLMasterViewController.m
//  Dictionary
//
//  Created by rannger on 14-3-10.
//  Copyright (c) 2014年 rannger. All rights reserved.
//

#import "RLMasterViewController.h"
#import "RLWordsTableViewController.h"
#import "RLDetailViewController.h"
#import "RLWord.h"
#import "CoreFunctions.h"

@interface RLMasterViewController () {
    NSArray *_objects;
    NSMutableArray* searchResult;
    UIBarButtonItem* item;
    UISearchDisplayController* searchDisplayController;
}
@end

@implementation RLMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title=@"Index";
    _objects = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X"];
    [self.tableView reloadData];
    
    UISearchBar* searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44+20)];
    searchBar.delegate=self;
    searchBar.barTintColor=[UIColor blackColor];
    item=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                                                        target:self
                                                                        action:@selector(favs)];
    
    searchDisplayController=[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.searchResultsDelegate=self;
    searchDisplayController.searchResultsDataSource=self;
    searchDisplayController.delegate=self;
    searchDisplayController.displaysSearchBarInNavigationBar=YES;
    self.searchDisplayController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchResult=[NSMutableArray arrayWithCapacity:100];
    [self setFavBtn];
}

- (void)setFavBtn
{
    self.navigationItem.rightBarButtonItem=item;
}

- (void)favs
{
    RLWordsTableViewController* ctrl=[[RLWordsTableViewController alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *list=[RLWord allFavWords];
        dispatch_async(dispatch_get_main_queue(), ^{
            ctrl.words=list;
            [ctrl reload];
        });
    });
    [self.navigationController pushViewController:ctrl animated:YES];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.tableView) {
        return [_objects count];
    }
    return searchResult.count;
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
    
    if (tableView==self.tableView) {
        NSString *object = _objects[indexPath.row];
        cell.textLabel.text = object;
        cell.textLabel.font=[UIFont fontWithName:@"BanglaSangamMN-Bold" size:20];
        cell.textLabel.numberOfLines=0;
        cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    }
    else
    {
        RLWord* word=[searchResult objectAtIndex:indexPath.row];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = word.word;
        cell.textLabel.font=[UIFont fontWithName:@"BanglaSangamMN-Bold" size:20];
        cell.textLabel.numberOfLines=0;
        cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==self.tableView) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *list=[RLWord wordByFirstChar:_objects[indexPath.row]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [searchResult removeAllObjects];
                [searchResult addObjectsFromArray:list];
                self.searchDisplayController.searchBar.text=_objects[indexPath.row];
                self.navigationItem.rightBarButtonItem=nil;
                [searchDisplayController setActive:YES];
            });
        });
    }
    else
    {
        RLWord* word=[searchResult objectAtIndex:indexPath.row];
        RLDetailViewController* ctrl=[[RLDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.detail=word;
        [self.navigationController pushViewController:ctrl animated:YES];
        [self.searchDisplayController setActive:NO];
        [self setFavBtn];
    }

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

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    if (self.navigationItem.rightBarButtonItem==item) {
         self.navigationItem.rightBarButtonItem=nil;
    }
   
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    if (self.navigationItem.rightBarButtonItem==item) {
        self.navigationItem.rightBarButtonItem=nil;
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [searchResult removeAllObjects];
    if (IsStringWithAnyText(searchText)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *list=[RLWord wordByFirstChar:searchText];
            dispatch_async(dispatch_get_main_queue(), ^{
                [searchResult addObjectsFromArray:list];
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
        });
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchResult removeAllObjects];
    [self setFavBtn];
    [self.searchDisplayController setActive:NO];

}

@end
