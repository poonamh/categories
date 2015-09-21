//
//  CategoryCollectionViewCell.m
//  GrayMail
//
//  Created by Poonam Hattangady on 9/19/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import "CategoryCollectionViewCell.h"

@interface CategoryCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;

@end

@implementation CategoryCollectionViewCell

-(void) configureWithCategory:(MailCategory *)category
{
    self.category = category;
    self.categoryNameLabel.text = category.name;
    self.categoryImage.image = category.image;
}

@end
