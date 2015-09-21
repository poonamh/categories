//
//  Receipt.h
//  GrayMail
//
//  Created by Poonam Hattangady on 9/19/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface Receipt : NSManagedObject

@property NSString *storeName;
@property NSNumber *purchaseAmount;
@property NSDate *purchaseDate;
@property NSDate *dateCreated;
@property NSString *keywords;
@property NSData *receiptImage;

- (void) configureWithStoreName:(NSString *)storeName amount:(NSNumber *)amount purchaseDate:(NSDate*)purchaseDate keywords:(NSString *)keywords image:(UIImage *)receiptImage;
-(void) configureFromDictionary:(NSDictionary *)dictionary;

@end
