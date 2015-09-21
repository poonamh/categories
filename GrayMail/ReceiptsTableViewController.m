//
//  MyReceiptsTableViewController.m
//  GrayMail
//
//  Created by Poonam Hattangady on 9/19/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import "ReceiptsTableViewController.h"
#import "Receipt.h"
#import "ReceiptViewCell.h"
#import "ConfirmReceiptTableViewController.h"
#import "ImageViewController.h"

@interface ReceiptsTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *fromFileButton;
@property (weak, nonatomic) IBOutlet UIButton *fromLibraryButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *sortOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *digitizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiptsHeaderLabel;
@property (weak, nonatomic) IBOutlet UIView *headerContainerView;

@property Receipt *receiptToConfirm;
@property Receipt *selectedReceipt;
@property BOOL ascendingSort;
@property BOOL sortOrderChanged;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation ReceiptsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // No search results controller to display the search results in the current view
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self updateSortOrderLabel];
    
    self.navigationController.navigationBarHidden = NO;
    self.digitizeLabel.backgroundColor = self.category.primaryColor;
    self.receiptsHeaderLabel.backgroundColor = self.category.primaryColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.searchFetchRequest = nil;
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

#pragma mark -
#pragma mark === Table view data source ===
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active)
    {
        return 1;
    }
    else
    {
        return [[self.fetchedResultsController sections] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active)
    {
        return [self.filteredList count];
    }
    else
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiptViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiptCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    // return YES;
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    self.selectedReceipt = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowImageSegue" sender:self];
}

- (void)configureCell:(ReceiptViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Receipt *currentReceipt = nil;
    if (self.searchController.active)
    {
        currentReceipt = [self.filteredList objectAtIndex:indexPath.row];
    }
    else
    {
        currentReceipt = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    [cell configureWithReceipt:currentReceipt];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"purchaseDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    
    return _searchFetchRequest;
}

#pragma mark -
#pragma mark === Fetched results controller ===
#pragma mark -

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil && self.sortOrderChanged == NO) {
        return _fetchedResultsController;
    }
    
    self.sortOrderChanged = NO;
    NSString *cacheName = self.ascendingSort ? @"MasterAsc" : @"MasterDesc";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"purchaseDate" ascending:self.ascendingSort];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil cacheName:cacheName];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(ReceiptViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */


#pragma mark - Digitize your receipt

- (IBAction)addReceiptTapped:(id)sender {
    if (sender == self.fromFileButton)
    {
        // NOP for now.
    }
    else if (sender == self.fromLibraryButton
             && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if (sender == self.takePhotoButton
             && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark - UIImagePickerControllerDelegate delegates
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:context];
    Receipt *receipt = (Receipt *) [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:(-2)];
    NSDate *dateToUse = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    
    receipt.purchaseDate = dateToUse;
    receipt.storeName = @"West Elm";
    receipt.purchaseAmount = @(100.00);
    receipt.keywords = @"item1, item2, item3";
    receipt.receiptImage = UIImagePNGRepresentation(image);
    
    self.receiptToConfirm = receipt;

    [self performSegueWithIdentifier:@"ConfirmReceiptSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ConfirmReceiptSegue"])
    {
        // Get reference to the destination view controller
        UINavigationController *navController = [segue destinationViewController];
        ConfirmReceiptTableViewController *vc =  (ConfirmReceiptTableViewController *)navController.topViewController;
        
        // Pass any objects to the view controller here, like...
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [vc configureWithReceipt:self.receiptToConfirm mailCategory:self.category managedObjectContext:context];
    }
    else if ([[segue identifier] isEqualToString: @"ShowImageSegue"])
    {
        // Get reference to the destination view controller
        UINavigationController *navController = [segue destinationViewController];
        ImageViewController * vc = (ImageViewController *)navController.topViewController;
        [vc showImageWithData:self.selectedReceipt.receiptImage];
    }
}

#pragma mark -
#pragma mark === UISearchBarDelegate ===
#pragma mark -

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
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
        NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
        NSString *searchAttribute = @"storeName";
        
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

#pragma mark - Sort order
- (IBAction)sortOrderTapped:(id)sender {
    self.sortOrderChanged = YES;
    self.ascendingSort = !self.ascendingSort;
    [self updateSortOrderLabel];
    
    // Trigger new fetch results controller being created
    [self fetchedResultsController];
    [self.tableView reloadData];
    [self updateSortOrderLabel];
}

- (void) updateSortOrderLabel
{
    self.sortOrderButton.titleLabel.text = self.ascendingSort ? @"Date Asc" : @"Date Desc";
}
@end
