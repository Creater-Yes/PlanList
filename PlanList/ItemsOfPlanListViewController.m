//
//  ItemsOfPlanListViewController.m
//  PlanList
//
//  Created by dingql on 14-3-12.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "ItemsOfPlanListViewController.h"
#import "PlanList.h"
#import "IconPickerViewController.h"

@interface ItemsOfPlanListViewController () <UITextFieldDelegate, IconPickerViewControllerDelegate>
@property(nonatomic, copy) NSString * iconPicked;
@end

@implementation ItemsOfPlanListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    UITextField * textField = (UITextField *)[self.tableView viewWithTag:1000];
    [textField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(AddPlanList)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(CancelPlanList)];

    if (_list == nil) {
        self.title = @"Add PlanList";
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else{
        self.title = @"Edit PlanList";
    }
    
    
}

#pragma mark - Target -- Action
- (void)AddPlanList
{
    UITextField * textField = (UITextField *)[self.tableView viewWithTag:1000];
    if (_list == nil) {
        self.list = [[PlanList alloc]init];
        _list.listTitle = textField.text;
        _list.listIconName = _iconPicked;
        [self.delegate ItemsOfPlanListController:self didFinishAddPlanList:_list];

    }
    else{
        self.list.listTitle = textField.text;
        [self.delegate ItemsOfPlanListController:self didFinishEditPlanList:_list];
    }
}

- (void)CancelPlanList
{
    [self.delegate ItemsOfPlanListControllerDidCancel:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.row == 0) {
        
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 12, 180, 20)];
        textField.tag = 1000;
        textField.delegate = self;
        textField.placeholder = @"Enter PlanList name";
        textField.text = _list.listTitle;
        textField.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:textField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.row == 1){
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 50, 20)];
        label.font = [UIFont boldSystemFontOfSize:18.0f];
        label.text = @"Icon";
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(250, 2, 40, 40)];
        NSString * iconName = _list.listIconName ? _list.listIconName : @"Folder";
        imageView.image = [UIImage imageNamed:iconName];
        
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:imageView];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        IconPickerViewController * iconPicker = [[IconPickerViewController alloc]initWithStyle:UITableViewStylePlain];
        iconPicker.delegate = self;
        
        [self.navigationController pushViewController:iconPicker animated:YES];
        
    }
}

- (void)IconPickerViewController:(IconPickerViewController *)controller DidFinishPickIcon:(NSString *)iconName
{
    self.iconPicked = iconName;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
