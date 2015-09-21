//
//  MailCategory.h
//  GrayMail
//
//  Created by Poonam Hattangady on 9/19/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface MailCategory : NSObject

@property NSString *name;
@property UIImage *image;
@property UIColor *primaryColor;

+ (NSArray *) allCategories;
+ (MailCategory *) categoryWithName:(NSString*)name image:(UIImage*)image primaryColor:(UIColor *)color;

@end
