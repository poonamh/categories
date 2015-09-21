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

@end
