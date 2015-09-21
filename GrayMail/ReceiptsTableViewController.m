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
#import "SearchReceiptsTableViewController.h"
#import "ReceiptConstants.h"

@interface ReceiptsTableViewController () <NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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

@end

@implementation ReceiptsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:ReceiptCellIdentifier bundle:nil] forCellReuseIdentifier:ReceiptCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self updateSortOrderLabel];
    
    self.navigationController.navigationBarHidden = NO;
    self.digitizeLabel.backgroundColor = self.category.primaryColor;
    self.receiptsHeaderLabel.backgroundColor = self.category.primaryColor;
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

#pragma mark -
#pragma mark === Table view data source ===
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiptViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReceiptCellIdentifier forIndexPath:indexPath];
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
        if (![context save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    self.selectedReceipt = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:ShowImageSegue sender:self];
}

- (void)configureCell:(ReceiptViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Receipt *currentReceipt = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureWithReceipt:currentReceipt];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:ReceiptModelName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:SortPropertyName ascending:self.ascendingSort];
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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:ReceiptModelName inManagedObjectContext:context];
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

    [self performSegueWithIdentifier:ConfirmReceiptSegue sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:ConfirmReceiptSegue])
    {
        UINavigationController *navController = [segue destinationViewController];
        ConfirmReceiptTableViewController *vc =  (ConfirmReceiptTableViewController *)navController.topViewController;
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        
        [vc configureWithReceipt:self.receiptToConfirm mailCategory:self.category managedObjectContext:context];
    }
    else if ([[segue identifier] isEqualToString: ShowImageSegue])
    {
        UINavigationController *navController = [segue destinationViewController];
        ImageViewController * vc = (ImageViewController *)navController.topViewController;
        
        [vc showImageWithData:self.selectedReceipt.receiptImage];
    }
    else if ([[segue identifier] isEqualToString:SearchReceiptsSegue])
    {
        UINavigationController *navController = [segue destinationViewController];
        SearchReceiptsTableViewController *vc = (SearchReceiptsTableViewController *)navController.topViewController;
        
        vc.managedObjectContext = [self.fetchedResultsController managedObjectContext];
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
