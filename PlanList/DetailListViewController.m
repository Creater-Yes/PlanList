//
//  DetailListViewController.m
//  PlanList
//
//  Created by dingql on 14-3-13.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "DetailListViewController.h"
#import "PlanList.h"
#import "ItemsInDetailListViewController.h"
#import "PlanListItem.h"

@interface DetailListViewController () <ItemsInDetailListViewControllerDelegate>

@end

@implementation DetailListViewController

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
    
    self.title = _list.listTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddPlanListItem)];
}

- (void)AddPlanListItem
{
    ItemsInDetailListViewController * itemsController = [[ItemsInDetailListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    itemsController.delegate = self;
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:itemsController];
    [self presentViewController:nav animated:YES completion:nil];
    
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
    return _list.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    UILabel * label = nil;
    UILabel * titleLabel = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 10, 20)];
        label.tag = 1050;
        label.font = [UIFont boldSystemFontOfSize:15.0f];
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 12, 50, 20)];
        titleLabel.tag = 1051;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:titleLabel];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    PlanListItem * item = _list.items[indexPath.row];
    
    label = (UILabel *)[cell.contentView viewWithTag:1050];
    label.text = item.itemState ? @"√" : @"";
    
    titleLabel = (UILabel *)[cell.contentView viewWithTag:1051];
    titleLabel.text = item.itemName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ItemsInDetailListViewController * itemsController = [[ItemsInDetailListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    itemsController.delegate = self;
    itemsController.item = _list.items[indexPath.row];
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:itemsController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlanListItem * item = _list.items[indexPath.row];
    item.itemState = !item.itemState;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_list.items removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - ItemsInDetailListViewController Delegate

- (void)ItemsController:(ItemsInDetailListViewController *)controller didFinishAddItem:(PlanListItem *)item
{
    [self.list.items insertObject:item atIndex:0];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)ItemsController:(ItemsInDetailListViewController *)controller didFinishEditItem:(PlanListItem *)item
{
    NSInteger index = [_list.items indexOfObject:item];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)ItemsControllerDidCancel:(ItemsInDetailListViewController *)controller
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
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
