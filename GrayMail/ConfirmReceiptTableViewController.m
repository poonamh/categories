//
//  ConfirmReceiptTableViewController.m
//  GrayMail
//
//  Created by Poonam Hattangady on 9/20/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import "ConfirmReceiptTableViewController.h"
#import "Receipt.h"
#import "ReceiptFieldTableViewCell.h"

@interface ConfirmReceiptTableViewController ()


@property Receipt *receipt;
@property MailCategory *mailCategory;
@property NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIImageView *receiptImage;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation ConfirmReceiptTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.receipt.receiptImage == nil)
    {
        self.receiptImage.image = [UIImage imageNamed:@"date.png"];
    }
    else
    {
        self.receiptImage.image = [UIImage imageWithData:self.receipt.receiptImage];
    }
    
    CGSize stringsize = [@"Confirm" sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:18.0] }];

    [self.cancelButton setFrame:CGRectMake(
                                           self.cancelButton.frame.origin.x,
                                           self.cancelButton.frame.origin.y,
                                           stringsize.width + 40,
                                           stringsize.height + 20)];
    
    [self.confirmButton setFrame:CGRectMake(
                                           self.confirmButton.frame.origin.x,
                                           self.confirmButton.frame.origin.y,
                                           stringsize.width + 40,
                                           stringsize.height + 20)];
}

- (void) configureWithReceipt:(Receipt *)receipt mailCategory:(MailCategory *)mailCategory managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
{
    self.receipt = receipt;
    self.mailCategory = mailCategory;
    self.managedObjectContext = managedObjectContext;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReceiptFieldTableViewCell *cell = (ReceiptFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FieldCell" forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.row)
    {
        case 0:
            [cell configureWithField:@"Date" dateValue:self.receipt.purchaseDate imageName:@"date.png"];
            break;
            
        case 1:
            [cell configureWithField:@"Store name" textValue:self.receipt.storeName imageName:@"store.png"];
            break;
            
        case 2:
            [cell configureWithField:@"Amount" numValue:self.receipt.purchaseAmount imageName:@"amount.png"];
            break;
        
        case 3:
            [cell configureWithField:@"Keywords" textValue:self.receipt.keywords imageName:@"keywords.png"];
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Cancel/Confirm
- (IBAction)cancelTapped:(id)sender {
}

- (IBAction)confirmTapped:(id)sender {
    self.canSaveReceipt = YES;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


@end



