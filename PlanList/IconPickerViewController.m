//
//  IconPickerViewController.m
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "IconPickerViewController.h"

@interface IconPickerViewController ()
@property(nonatomic, strong) NSArray * icons;
@end

@implementation IconPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Icon pick";
    
    self.icons = @[@"Appointments", @"Birthdays", @"Chores", @"Drinks", @"Folder", @"Groceries",
                   @"Inbox", @"No Icon", @"Photos", @"Trips"];
}

- (void)IconPickCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _icons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:_icons[indexPath.row]];
    cell.textLabel.text = _icons[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.delegate IconPickerViewController:self DidFinishPickIcon:_icons[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
