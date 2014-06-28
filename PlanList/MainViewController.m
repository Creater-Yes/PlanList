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
#import "AFNetworkActivityIndicatorManager.h"


static NSString * const baseURLString = @"http://192.168.1.102/app/index.php/admin/User/index";

@interface MainViewController () <ListsOfPlanListViewControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)UISearchBar * searchBar;
@property(nonatomic, strong)UISearchDisplayController * searchDisplay;
@property(nonatomic, strong)NSMutableArray * filterArray;
@end

@implementation MainViewController


- (id)init
{
    if (self = [super init]) {
        self.data = [[DataModel alloc] init];
        self.filterArray = [NSMutableArray array];
        
        self.title = @"PlanList";
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

- (void)testNetworking
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    NSURL * url = [NSURL URLWithString:baseURLString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", (NSArray *)responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"获取信息错误" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddlistToPlanList)];

//    UIBarButtonItem * btnBack = [[UIBarButtonItem alloc]init];
//    btnBack.title = @"";
//    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"backBtn"];
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"backBtn"];
//    self.navigationItem.backBarButtonItem = btnBack;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 手动设置搜索条
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    self.searchBar.showsScopeBar = NO;
    [self.searchBar sizeToFit];
    self.searchBar.placeholder = @"请输入要搜素的内容";
    self.searchBar.scopeButtonTitles = @[@"All", @"Drinks", @"Folder", @"Trips"];
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = _searchBar;
    
    UISearchDisplayController * searchDisplay = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    searchDisplay.delegate = self;
    searchDisplay.searchResultsDelegate = self;
    searchDisplay.searchResultsDataSource = self;
    self.searchDisplay = searchDisplay;
    
    // 搜素栏初始隐藏
    self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(_searchBar.bounds));
    
    //[self testNetworking];
    NSLog(@"searchDisplay:%@, searchController:%@", _searchDisplay, self.searchDisplayController);
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

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    // 根据搜索栏的内容和范围更新过滤后的数组。
    // 先将过滤后的数组清空
    [self.filterArray removeAllObjects];
    
    // 用 NSPredicate 来过滤数组
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.listTitle contains[c] %@", searchText];
    NSArray * tempArray = [_data.lists filteredArrayUsingPredicate: predicate];
    if (![scope isEqual:@"All"]) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.listIconName contains[c] %@", scope];
        tempArray = [tempArray filteredArrayUsingPredicate: predicate];
    }
    
    _filterArray = [tempArray mutableCopy];
}

#pragma - UISearchBar Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{

    [self filterContentForSearchText:self.searchDisplayController.searchBar.text
                               scope:self.searchDisplayController.searchBar.scopeButtonTitles[searchOption]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{

    [self filterContentForSearchText:searchString
                               scope:self.searchDisplayController.searchBar.scopeButtonTitles[self.searchDisplayController.searchBar.selectedScopeButtonIndex]];
    return YES;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"searchDisplayControllerWillBeginSearch:%@", controller);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        count = (int)_filterArray.count;
    }
    else{
        count = (int)_data.lists.count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    PlanList * list;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        list = (PlanList *)(_filterArray[indexPath.row]);
    }
    else{
        list = (PlanList *)(_data.lists[indexPath.row]);
    }
    
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
    listsController.list = _data.lists[indexPath.row];
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:listsController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    [self.data setIndexOfSelectedPlanlist:(int)indexPath.row];
    DetailListViewController * detailController = [[DetailListViewController alloc]initWithStyle:UITableViewStylePlain];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        detailController.list = _filterArray[indexPath.row];
    }
    else{
        detailController.list = _data.lists[indexPath.row];
    }
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
    NSInteger index = [_data.lists indexOfObject:list];
    //[self.data.lists replaceObjectAtIndex:index withObject:list];
    _data.lists[index] = list;
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
