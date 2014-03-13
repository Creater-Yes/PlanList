//
//  ItemsInDetailListViewController.m
//  PlanList
//
//  Created by dingql on 14-3-13.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "ItemsInDetailListViewController.h"

@interface ItemsInDetailListViewController ()
@property(nonatomic, copy) NSString * itemName;
@property(nonatomic, assign) BOOL shoudRemind;
@property(nonatomic, strong) NSDate * issueDate;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddItems)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(CancelItems)];

    if (_item == nil) {
        self.title = @"Add Items";
        _issueDate = [NSDate date];
    }
    else
    {
        self.title = @"Edit Items";
    }
}

- (void)AddItems
{
    [self.delegate  ItemsController:self didFinishAddItem:_item];
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
        textField.tag = 2000;
        textField.placeholder = @"Enter Item name";
        textField.text = _itemName;
        
        [cell.contentView addSubview:textField];
    }
    else if (indexPath.row == 1){
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 50, 20)];
        label.font = [UIFont boldSystemFontOfSize:15.0f];
        label.text = @"Remind Me";
        
        UISwitch * mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(253, 7, 51, 31)];
        mySwitch.on = _shoudRemind;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:mySwitch];
    }
    else{
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 50, 20)];
        label.font = [UIFont boldSystemFontOfSize:15.0f];
        label.text = @"Issue Date";
        
        UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 12, 200, 20)];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        
        dateLabel.text = [dateFormatter stringFromDate:_issueDate];
    }
    
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
