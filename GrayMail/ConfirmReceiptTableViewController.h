//
//  ConfirmReceiptTableViewController.h
//  GrayMail
//
//  Created by Poonam Hattangady on 9/20/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Receipt.h"
#import "MailCategory.h"

@interface ConfirmReceiptTableViewController : UITableViewController

@property BOOL canSaveReceipt;

- (void) configureWithReceipt:(Receipt *)receipt mailCategory:(MailCategory *)mailCategory managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
