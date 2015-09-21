//
//  Receipt.m
//  GrayMail
//
//  Created by Poonam Hattangady on 9/19/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import "Receipt.h"

@implementation Receipt

@dynamic storeName;
@dynamic purchaseAmount;
@dynamic purchaseDate;
@dynamic dateCreated;
@dynamic keywords;
@dynamic receiptImage;


- (void) configureWithStoreName:(NSString *)storeName amount:(NSNumber *)amount purchaseDate:(NSDate*)purchaseDate keywords:(NSString *)keywords image:(UIImage *)receiptImage
{
    self.storeName = storeName;
    self.purchaseAmount = amount;
    self.purchaseDate = purchaseDate;
    self.keywords = keywords;
    self.dateCreated = [NSDate date];
    self.receiptImage = UIImagePNGRepresentation(receiptImage);
}

-(void) configureFromDictionary:(NSDictionary *)dictionary;
{
    self.storeName  = [dictionary valueForKey:@"storeName"];
    self.purchaseAmount  = [dictionary valueForKey:@"purchaseAmount"];
    self.purchaseDate  = [dictionary valueForKey:@"purchaseDate"];
    self.keywords  = [dictionary valueForKey:@"keywords"];
    self.dateCreated  = [dictionary valueForKey:@"dateCreated"];
    self.receiptImage = UIImagePNGRepresentation([UIImage imageNamed:@"promotions.png"]);
}

+ (NSArray *)allReceipts
{
    NSMutableArray *receipts = [NSMutableArray new];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    for (int i = 0; i < 10; i++)
    {
        [offsetComponents setDay:(-1 * i)];
        NSDate *dateToUse = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
        
        // add item1
        Receipt *receipt1 = [Receipt new];
        [ receipt1 configureWithStoreName:@"Express" amount:@(20 * (i + 1)) purchaseDate:dateToUse keywords:@"Jeans" image:nil];
        [receipts addObject:receipt1];
        
        // add item2
        Receipt *receipt2 = [Receipt new];
        [ receipt2 configureWithStoreName:@"Madewell" amount:@(20 * (i + 1)) purchaseDate:dateToUse keywords:@"Jeans" image:nil];
        [receipts addObject:receipt2];
    }
    
    return receipts;
}

@end
