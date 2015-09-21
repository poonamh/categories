//
//  ReceiptViewCell.h
//  GrayMail
//
//  Created by Poonam Hattangady on 9/19/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Receipt.h"

@interface ReceiptViewCell : UITableViewCell

- (void) configureWithReceipt:(Receipt *)receipt;

@end
