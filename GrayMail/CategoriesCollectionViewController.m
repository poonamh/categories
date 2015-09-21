//
//  CategoriesCollectionViewController.m
//  GrayMail
//
//  Created by Poonam Hattangady on 9/19/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import "CategoriesCollectionViewController.h"
#import "MailCategory.h"
#import "CategoryCollectionViewCell.h"
#import "ReceiptsTableViewController.h"


@interface CategoriesCollectionViewController ()

@property NSArray *categories;
@property MailCategory *selectedCategory;

@end


@implementation CategoriesCollectionViewController

static NSString * const reuseIdentifier = @"CategoryCell";

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categories = [MailCategory allCategories];

    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    // [self.collectionView registerClass:[CategoryCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.selectedCategory = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCollectionViewCell *cell = (CategoryCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    MailCategory *category = (MailCategory*) [self.categories objectAtIndex:indexPath.row];

    // Configure the cell
    [cell configureWithCategory:category];    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCategory = [self.categories objectAtIndex:indexPath.row];
    switch (indexPath.row)
    {
        case 1:
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Receipts" bundle:nil];
            ReceiptsTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ReceiptsViewController"];
            vc.managedObjectContext = self.managedObjectContext;
            vc.category = self.selectedCategory;
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
        {
            [self performSegueWithIdentifier:@"ComingSoonSegue" sender:self];
            self.navigationController.navigationBarHidden = NO;
            break;
        }
    }
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ComingSoonSegue"])
    {
        // Get reference to the destination view controller
        UINavigationController *navController = [segue destinationViewController];
        UIViewController *vc =  navController.topViewController;
        
        // Pass any objects to the view controller here, like...
        vc.view.backgroundColor = self.selectedCategory.primaryColor;
    }
}

@end
