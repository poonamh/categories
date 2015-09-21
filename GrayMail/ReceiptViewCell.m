//
//  ReceiptViewCell.m
//  GrayMail
//
//  Created by Poonam Hattangady on 9/19/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import "ReceiptViewCell.h"

@interface ReceiptViewCell()
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayOfWeekLabel;

@end


@implementation ReceiptViewCell

- (void) configureWithReceipt:(Receipt *)receipt
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.storeNameLabel.text = receipt.storeName;
    self.amountLabel.text = [formatter stringFromNumber:receipt.purchaseAmount];
    self.dateLabel.text = [dateFormatter stringFromDate:receipt.purchaseDate];
    
    [dateFormatter setDateFormat:@"EEEE"];
    self.dayOfWeekLabel.text = [dateFormatter stringFromDate:receipt.purchaseDate];
}

@end
