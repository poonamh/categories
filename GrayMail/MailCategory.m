//
//  MailCategory.m
//  GrayMail
//
//  Created by Poonam Hattangady on 9/19/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import "MailCategory.h"

#define _RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation MailCategory

+ (MailCategory *) categoryWithName:(NSString*)name image:(UIImage*)image primaryColor:(UIColor *)color;
{
    MailCategory *category = [MailCategory new];
    category.name = name;
    category.image = image;
    category.primaryColor = color;
    
    return category;
}

+ (NSArray *) allCategories;
{
    MailCategory *promotions = [MailCategory categoryWithName:@"Promotions"
                                             image:[UIImage imageNamed:@"promotions.png"]
                                             primaryColor:_RGB(41, 70, 130, 1)];
    
    MailCategory *receipts = [MailCategory  categoryWithName:@"Receipts"
                                            image:[UIImage
                                            imageNamed:@"receipts.png"]
                                            primaryColor:_RGB(71, 128, 191, 1)];
    
    MailCategory *finance = [MailCategory  categoryWithName:@"Finance"
                                           image:[UIImage imageNamed:@"finance.png"]
                                           primaryColor:_RGB(87, 148, 51, 1)];
    
    MailCategory *shipping = [MailCategory  categoryWithName:@"Shipping"
                                            image:[UIImage imageNamed:@"shipping.png"]
                                            primaryColor:_RGB(199, 90, 33, 1)];
    
    MailCategory *documents = [MailCategory categoryWithName:@"Documents"
                                            image:[UIImage imageNamed:@"documents.png"]
                                            primaryColor:_RGB(209, 150, 12, 1)];
    
    MailCategory *travel = [MailCategory    categoryWithName:@"Travel"
                                            image:[UIImage imageNamed:@"travel.png"]
                                            primaryColor:_RGB(86, 25, 135, 1)];
    
    
    NSMutableArray *categories = [NSMutableArray arrayWithObjects:
                                  promotions,
                                  receipts,
                                  finance,
                                  shipping,
                                  documents,
                                  travel,
                                  nil];
    return categories;
}

@end
