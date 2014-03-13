//
//  MainViewController.m
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "MainViewController.h"
#import "DataModel.h"
#import "PlanList.h"
#import "ItemsOfPlanListViewController.h"
#import "PlanListItem.h"


@interface MainViewController () <ItemsOfPlanListViewControllerDelegate>

@end

@implementation MainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.data = [[DataModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"PlanList";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddItemsToPlanList)];
}

- (void)AddItemsToPlanList
{
    ItemsOfPlanListViewController * itemsOfPlanList = [[ItemsOfPlanListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    itemsOfPlanList.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:itemsOfPlanList];
    
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
    return _data.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    PlanList * list = (PlanList *)([_data.lists objectAtIndex:indexPath.row]);
    cell.imageView.image = [UIImage imageNamed: list.listIconName];
    cell.textLabel.text = list.listTitle;
    
    int count = 0;
    for (PlanListItem * item in list.items) {
        if (!item.itemState) {
            count++;
        }
    }
    
    if (list.items.count == 0) {
        cell.detailTextLabel.text = @"(Empty)";
    }
    else if (count == 0) {
        cell.detailTextLabel.text = @"(All done!)";
    }
    else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%d need to do)", count];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ItemsOfPlanListViewController * itemsController = [[ItemsOfPlanListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    itemsController.delegate = self;
    itemsController.list = [_data.lists objectAtIndex:indexPath.row];
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:itemsController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - ItemsOfPlanListViewController Delegate

- (void)ItemsOfPlanListController:(ItemsOfPlanListViewController *)controller didFinishAddPlanList:(PlanList *)list
{
    [self.data.lists insertObject:list atIndex:0];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)ItemsOfPlanListController:(ItemsOfPlanListViewController *)controller didFinishEditPlanList:(PlanList *)list
{
    NSInteger index = [self.data.lists indexOfObject:list];
    [self.data.lists replaceObjectAtIndex:index withObject:list];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)ItemsOfPlanListControllerDidCancel:(ItemsOfPlanListViewController *)controller
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
