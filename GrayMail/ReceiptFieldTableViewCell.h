//
//  ReceiptFieldTableViewCell.h
//  GrayMail
//
//  Created by Poonam Hattangady on 9/20/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptFieldTableViewCell : UITableViewCell

- (void) configureWithField:(NSString *)fieldName textValue:(NSString*)fieldValue imageName:(NSString*)imageName;
- (void) configureWithField:(NSString *)fieldName dateValue:(NSDate *)dateValue imageName:(NSString*)imageName;
- (void) configureWithField:(NSString *)fieldName numValue:(NSNumber *)numValue imageName:(NSString*)imageName;

@end
