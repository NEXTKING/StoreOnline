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

@interface SearchViewController () <UISearchBarDelegate, SearchDelegate>
{
    NSArray* _searchResults;
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
    [self performSegueWithIdentifier:@"DetailDescriptionSegue" sender:indexPath];
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
    if ([searchText length] == 0)
    {
        _searchResults = nil;
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    ItemSearchAttribute searchAttribute = ItemSearchAttributeName | ItemSearchAttributeArticle | ItemSearchAttributeItemCode;
    [[MCPServer instance] search:self forQuery:searchBar.text withAttribute:searchAttribute];
    [searchBar resignFirstResponder];
}

#pragma mark - Search delegate

- (void)searchComplete:(int)result attribute:(ItemSearchAttribute)searchAttribute items:(NSArray *)items
{
    if (result == 1)
    {
        _searchResults = items;
        [self.tableView reloadData];
    }
    else
    {
        
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailDescriptionSegue"])
    {
        OstinViewController* ostinVC = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        
        ItemInformation* itemInfo = _searchResults[indexPath.row];
        ostinVC.externalBarcode = itemInfo.barcode;
    }
}

@end
