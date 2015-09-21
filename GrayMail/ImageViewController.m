//
//  ImageViewController.m
//  GrayMail
//
//  Created by Poonam Hattangady on 9/20/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *receiptImage;
@property UIImage *image;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.receiptImage.image = self.image;
}

-(void) showImage:(UIImage *)image;
{
    self.image = image;
}

-(void) showImageWithData:(NSData *)imageData;
{
    self.image = [UIImage imageWithData:imageData];
}

@end
