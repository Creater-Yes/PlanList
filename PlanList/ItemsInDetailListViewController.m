//
//  ItemsInDetailListViewController.m
//  PlanList
//
//  Created by dingql on 14-3-13.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "ItemsInDetailListViewController.h"
#import "PlanListItem.h"
#import "DatePickerViewController.h"

@interface ItemsInDetailListViewController () <UITextFieldDelegate, DatePickerViewControllerDelegate>
@property(nonatomic, copy) NSString * itemName;
@property(nonatomic, assign) BOOL shoudRemind;
@property(nonatomic, strong) NSDate * issueDate;
@property(nonatomic, assign) BOOL isChecked;
@end

@implementation ItemsInDetailListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UITextField * textField = (UITextField *)[self.tableView viewWithTag:2000];
    [textField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(AddItems)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(CancelItems)];

    if (_item == nil) {
        self.title = @"Add Items";
        _issueDate = [NSDate date];
        _shoudRemind = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        self.title = @"Edit Items";
        _itemName = self.item.itemName;
        _shoudRemind = self.item.itemShoudRemind;
        _issueDate = self.item.itemRemindDate;
        _isChecked = self.item.itemState;
    }
}

- (void)AddItems
{
    UITextField * textField = (UITextField *)[self.tableView viewWithTag:2000];
    if (_item == nil) {
        self.item = [[PlanListItem alloc]init];
        self.item.itemName = textField.text;
        self.item.itemShoudRemind = _shoudRemind;
        self.item.itemRemindDate = _issueDate;
        self.item.itemState = NO;
        [_item scheduleNotification];
        
        [self.delegate  ItemsController:self didFinishAddItem:_item];
    }
    else{
        self.item.itemName = textField.text;
        self.item.itemShoudRemind = _shoudRemind;
        self.item.itemRemindDate = _issueDate;
        self.item.itemState = _isChecked;
        [_item scheduleNotification];
        
        [self.delegate ItemsController:self didFinishEditItem:_item];
    }

}

- (void)CancelItems
{
    [self.delegate ItemsControllerDidCancel:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.navigationItem.rightBarButtonItem.enabled = str.length > 0;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 12, 180, 20)];
        textField.delegate = self;
        textField.tag = 2000;
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"Enter Item name";
        textField.text = _itemName;
        
        [cell.contentView addSubview:textField];
    }
    else if (indexPath.row == 1){
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 80, 20)];
        label.font = [UIFont boldSystemFontOfSize:15.0f];
        label.text = @"Remind Me";
        
        UISwitch * mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(253, 7, 51, 31)];
        mySwitch.on = _shoudRemind;
        [mySwitch addTarget:self action:@selector(SwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:mySwitch];
    }
    else{
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 80, 20)];
        label.font = [UIFont boldSystemFontOfSize:15.0f];
        label.text = @"Issue Date";
        
        UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 12, 200, 20)];
        dateLabel.textColor = [UIColor blueColor];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        
        dateLabel.text = [dateFormatter stringFromDate:_issueDate];
        
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:dateLabel];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)SwitchValueChanged:(UISwitch *)sender
{
    _shoudRemind = sender.on;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        DatePickerViewController * datePicker = [[DatePickerViewController alloc]init];
        datePicker.date = self.issueDate;
        datePicker.delegate = self;
        
        [self.navigationController pushViewController:datePicker animated:YES];
    }
}

- (void)DatePicker:(DatePickerViewController *)controller didFinishPickDate:(NSDate *)date
{
    self.issueDate = date;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
