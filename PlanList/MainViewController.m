//
//  MainViewController.m
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "MainViewController.h"
#import "PlanList.h"
#import "ListsOfPlanListViewController.h"
#import "PlanListItem.h"
#import "DetailListViewController.h"


@interface MainViewController () <ListsOfPlanListViewControllerDelegate, UINavigationControllerDelegate>

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
    
    int index = [self.data indexOfSelectedPlanlist];
    if (index >= 0 && index < [self.data.lists count]) {
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow: index inSection:0]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"PlanList";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddlistToPlanList)];
}

- (void)AddlistToPlanList
{
    ListsOfPlanListViewController * listsOfPlanList = [[ListsOfPlanListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    listsOfPlanList.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:listsOfPlanList];
    
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
    ListsOfPlanListViewController * listsController = [[ListsOfPlanListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    listsController.delegate = self;
    listsController.list = [_data.lists objectAtIndex:indexPath.row];
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:listsController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    [self.data setIndexOfSelectedPlanlist:(int)indexPath.row];
    DetailListViewController * detailController = [[DetailListViewController alloc]initWithStyle:UITableViewStylePlain];
    detailController.list = [_data.lists objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailController animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_data.lists removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - ItemsOfPlanListViewController Delegate

- (void)ListsOfPlanListController:(ListsOfPlanListViewController *)controller didFinishAddPlanList:(PlanList *)list
{
    [self.data.lists insertObject:list atIndex:0];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)ListsOfPlanListController:(ListsOfPlanListViewController *)controller didFinishEditPlanList:(PlanList *)list
{
    NSInteger index = [self.data.lists indexOfObject:list];
    [self.data.lists replaceObjectAtIndex:index withObject:list];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)ListsOfPlanListControllerDidCancel:(ListsOfPlanListViewController *)controller
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self) {
        [self.data setIndexOfSelectedPlanlist:-1];
    }
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
