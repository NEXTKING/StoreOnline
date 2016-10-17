//
//  SearchViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 22/09/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "MCPServer.h"
#import "OstinViewController.h"

@interface SearchViewController () <UISearchBarDelegate, SearchDelegate, ItemDescriptionDelegate>
{
    NSArray* _searchResults;
    BOOL isSearchRunning;
    UIActivityIndicatorView *_activityIndicator;
}
@end

@implementation SearchViewController

static NSString * const reuseIdentifier = @"TableCellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:130];
}

- (void)showActivityIndicator
{
    if (_activityIndicator == nil)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.frame = CGRectMake(0, 0, 40, 40);
        _activityIndicator.center = self.tableView.center;
    }
    
    [self.view addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
}

- (void)hideActivityIndicator
{
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
}

- (void)showAlertWithMessage:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    ItemInformation *item = [_searchResults objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = item.name;
    cell.itemCodeLabel.text = [item additionalParameterValueForName:@"itemCode"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemInformation *item = [_searchResults objectAtIndex:indexPath.row];
    [[MCPServer instance] itemDescription:self itemID:item.itemId];
}

#pragma mark - UISearchBar delegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if ([searchBar isFirstResponder])
        [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar isFirstResponder])
        [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (([searchText length] == 0) && !isSearchRunning)
    {
        _searchResults = nil;
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (!isSearchRunning)
    {
        isSearchRunning = YES;
        [self showActivityIndicator];
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ItemSearchAttribute searchAttribute = ItemSearchAttributeName | ItemSearchAttributeArticle | ItemSearchAttributeItemCode;
            [[MCPServer instance] search:wself forQuery:searchBar.text withAttribute:searchAttribute];
        });
    }
    [searchBar resignFirstResponder];
}

#pragma mark - Search delegate

- (void)searchComplete:(int)result attribute:(ItemSearchAttribute)searchAttribute items:(NSArray *)items
{
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        isSearchRunning = NO;
        [wself hideActivityIndicator];
        if (result == 0)
        {
            _searchResults = items;
            [wself.tableView reloadData];
            
            if (items.count == 0)
                [wself showAlertWithMessage:@"По данному запросу не найдено ни одного товара."];
        }
        else
        {
            
        }
    });
}

#pragma mark - Item Description Delegate

- (void)itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    if (result == 0)
    {
        [self performSegueWithIdentifier:@"DetailDescriptionSegue" sender:itemDescription];
    }
    else
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath != nil)
        {
            ItemInformation *itemDescription = [_searchResults objectAtIndex:indexPath.row];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            [self performSegueWithIdentifier:@"DetailDescriptionSegue" sender:itemDescription];
        }
        else
        {
            
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailDescriptionSegue"])
    {
        OstinViewController* ostinVC = segue.destinationViewController;
        ItemInformation* itemInfo = sender;

        ostinVC.currentItemInfo = itemInfo;
    }
}

@end
