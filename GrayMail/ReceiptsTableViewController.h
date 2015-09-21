//
//  MyReceiptsTableViewController.h
//  GrayMail
//
//  Created by Poonam Hattangady on 9/19/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MailCategory.h"


@interface ReceiptsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property MailCategory *category;

@end
