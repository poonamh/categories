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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showImage:(UIImage *)image;
{
    self.image = image;
}

-(void) showImageWithData:(NSData *)imageData;
{
    self.image = [UIImage imageWithData:imageData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
