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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReceiptFieldTableViewCell *cell = (ReceiptFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FieldCell" forIndexPath:indexPath];
    
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

#pragma mark - Cancel/Confirm
- (IBAction)cancelTapped:(id)sender {
}

- (IBAction)confirmTapped:(id)sender {
    self.canSaveReceipt = YES;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}


@end



