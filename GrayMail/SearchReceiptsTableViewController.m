//
//  SearchReceiptsTableViewController.m
//  GrayMail
//
//  Created by Poonam Hattangady on 9/20/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SearchReceiptsTableViewController.h"
#import "Receipt.h"
#import "ReceiptViewCell.h"
#import "ReceiptConstants.h"
#import "ImageViewController.h"

@interface SearchReceiptsTableViewController ()<UISearchResultsUpdating, UISearchBarDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) UISearchController *searchController;

@property Receipt *selectedReceipt;

@end

// static NSString *ReceiptCellIdentifier = @"ReceiptCell";

@implementation SearchReceiptsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:ReceiptCellIdentifier bundle:nil] forCellReuseIdentifier:ReceiptCellIdentifier];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];

    self.searchController.active = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.searchFetchRequest = nil;
}

#pragma mark -
#pragma mark === Table view data source ===
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiptViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReceiptCellIdentifier forIndexPath:indexPath];
    
    Receipt *currentReceipt = [self.filteredList objectAtIndex:indexPath.row];
    [cell configureWithReceipt:currentReceipt];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    self.selectedReceipt = (Receipt *)[self.filteredList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:ShowImageSegue sender:self];
}


#pragma mark -
#pragma mark === Search ===
#pragma mark -

- (NSFetchRequest *)searchFetchRequest
{
    if (_searchFetchRequest != nil)
    {
        return _searchFetchRequest;
    }
    
    _searchFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:ReceiptModelName inManagedObjectContext:self.managedObjectContext];
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:SortPropertyName ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    
    return _searchFetchRequest;
}

#pragma mark -
#pragma mark === UISearchBarDelegate ===
#pragma mark -

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self performSegueWithIdentifier:@"SearchToReceipts" sender:self];
}

#pragma mark -
#pragma mark === UISearchResultsUpdating ===
#pragma mark -

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString];
    [self.tableView reloadData];
}

- (void)searchForText:(NSString *)searchText
{
    if (self.managedObjectContext)
    {
        NSString *predicateFormat = @"%K CONTAINS[cd] %@";
        NSString *searchAttribute = DefaultSearchPropertyName;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
        [self.searchFetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        self.filteredList = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: ShowImageSegue])
    {
        UINavigationController *navController = [segue destinationViewController];
        ImageViewController * vc = (ImageViewController *)navController.topViewController;
        
        [vc showImageWithData:self.selectedReceipt.receiptImage];
    }
}


@end
