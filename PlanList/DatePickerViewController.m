//
//  DatePickerViewController.m
//  PlanList
//
//  Created by dingql on 14-3-16.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.delegate DatePicker:self didFinishPickDate:_date];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 186, 200, 40)];
    label.tag = 3000;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterMediumStyle;
    label.text = [formatter stringFromDate:self.date];
    
    UIDatePicker * datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 270, 320, 210)];
    datePicker.date = self.date;
    [datePicker addTarget:self action:@selector(UpdateDateLabel:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:label];
    [self.view addSubview:datePicker];
	
}

- (void)UpdateDateLabel:(UIDatePicker *)datePicker
{
    UILabel * label = (UILabel *)[self.view viewWithTag:3000];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterMediumStyle;
    label.text = [formatter stringFromDate:datePicker.date];
    self.date = datePicker.date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}

@end
