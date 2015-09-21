//
//  ReceiptFieldTableViewCell.m
//  GrayMail
//
//  Created by Poonam Hattangady on 9/20/15.
//  Copyright (c) 2015 Poonam Hattangady. All rights reserved.
//

#import "ReceiptFieldTableViewCell.h"

@interface ReceiptFieldTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *fieldImage;
@property (weak, nonatomic) IBOutlet UILabel *fieldNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@property NSString *fieldName;
@property NSString *textValue;
@property UIImage *receiptImage;

@end

@implementation ReceiptFieldTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.fieldImage.frame = CGRectMake(self.fieldImage.frame.origin.x, self.fieldImage.frame.origin.y, 70, 70);
    self.fieldImage.contentMode = UIViewContentModeScaleAspectFill;
    self.fieldImage.clipsToBounds = YES;
}

- (void)configureBasicWithFieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue imageName:(NSString *)imageName
{
    self.fieldName = fieldName;
    self.textValue = fieldValue;
    self.receiptImage = [UIImage imageNamed:imageName];
    
    self.fieldImage.image = self.receiptImage;
    self.fieldNameLabel.text = self.fieldName;
    self.valueTextField.text = self.textValue;
    
    self.valueTextField.inputView = nil;
    self.valueTextField.keyboardType = UIKeyboardTypeAlphabet;
}

- (void) configureWithField:(NSString *)fieldName textValue:(NSString*)fieldValue imageName:(NSString*)imageName;
{
    [self configureBasicWithFieldName:fieldName fieldValue:fieldValue imageName:imageName];
}

- (void) configureWithField:(NSString *)fieldName dateValue:(NSDate *)dateValue imageName:(NSString*)imageName;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [self configureBasicWithFieldName:fieldName fieldValue:[dateFormatter stringFromDate:dateValue] imageName:imageName];
    
    UIDatePicker *picker = [UIDatePicker new];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.date = dateValue;
    self.valueTextField.inputView = picker;
}

- (void) configureWithField:(NSString *)fieldName numValue:(NSNumber *)numValue imageName:(NSString*)imageName;
{
    [self configureBasicWithFieldName:fieldName fieldValue:[numValue stringValue] imageName:imageName];
    self.valueTextField.keyboardType = UIKeyboardTypeDecimalPad;
}

@end

