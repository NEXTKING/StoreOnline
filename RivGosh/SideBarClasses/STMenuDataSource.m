//
//  STMenuDataSource.m
//  dphHermes
//
//  Created by Denis Kurochkin on 05.11.15.
//
//

#import "STMenuDataSource.h"
#import "DSPF_SideMenuCell_technopark.h"
#import "DSPF_SideMenuHeader_technopark.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "AboutViewController.h"
#import "TerminalViewController.h"

@interface STMenuDataSource()
{
}

@end

@implementation STMenuDataSource

@synthesize headerView = _headerView;

- (id) init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *cellsArray          = [NSMutableArray new];
        AppDelegate *appDelegate      = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        DSPF_Workspace *currentWorkspace    = [appDelegate workspace];
        
        
        {
                DSPF_SideMenuCell_technopark *cell = [[[NSBundle mainBundle] loadNibNamed:@"DSPF_SideMenuCell_technopark" owner:nil options:nil] objectAtIndex:0];
                cell.menuTitle.text = @"Корзина";
                cell.menuIcon.image = [UIImage imageNamed:@"hose.png"];
                cell.cellAction = ^{
                    [currentWorkspace switchBackToWorkspace];
                };
                
                [cellsArray addObject:cell];
        }
             {
                DSPF_SideMenuCell_technopark *cell = [[[NSBundle mainBundle] loadNibNamed:@"DSPF_SideMenuCell_technopark" owner:nil options:nil] objectAtIndex:0];
                cell.menuTitle.text = @"Настройки";
                cell.menuIcon.image = [UIImage imageNamed:@"data.png"];
                cell.cellAction = ^{
                    SettingsViewController *truckInfo = [[SettingsViewController alloc] init];
                    [currentWorkspace switchToExternalViewController:truckInfo];
                };
                
                [cellsArray addObject:cell];
            }
            /*{
                DSPF_SideMenuCell_technopark *cell = [[[NSBundle mainBundle] loadNibNamed:@"DSPF_SideMenuCell_technopark" owner:nil options:nil] objectAtIndex:0];
                cell.menuTitle.text = @"Сверка итогов";
                cell.menuIcon.image = [UIImage imageNamed:@"chat.png"];
                cell.cellAction = ^{
             
               };
                
                [cellsArray addObject:cell];
            }*/
            {
                DSPF_SideMenuCell_technopark *cell = [[[NSBundle mainBundle] loadNibNamed:@"DSPF_SideMenuCell_technopark" owner:nil options:nil] objectAtIndex:0];
                cell.menuTitle.text = @"Терминал";
                cell.menuIcon.image = [UIImage imageNamed:@"equipment.png"];
                cell.cellAction = ^{
                    
                    TerminalViewController *terminalVC = [TerminalViewController new];
                    [currentWorkspace switchToExternalViewController:terminalVC];
                    
                };
                
                [cellsArray addObject:cell];
            }
            {
                DSPF_SideMenuCell_technopark *cell = [[[NSBundle mainBundle] loadNibNamed:@"DSPF_SideMenuCell_technopark" owner:nil options:nil] objectAtIndex:0];
                cell.menuTitle.text = @"О Программе";
                cell.menuIcon.image = [UIImage imageNamed:@"exit.png"];
                cell.cellAction = ^{
                    AboutViewController* about = [AboutViewController new];
                    [currentWorkspace switchToExternalViewController:about];
                };
                [cellsArray addObject:cell];
            }
        {
            DSPF_SideMenuCell_technopark *cell = [[[NSBundle mainBundle] loadNibNamed:@"DSPF_SideMenuCell_technopark" owner:nil options:nil] objectAtIndex:0];
            cell.menuTitle.text = @"Смена Пользователя";
            cell.menuIcon.image = [UIImage imageNamed:@"exit.png"];
            __weak UITableViewCell* weakCell = cell;
            cell.cellAction = ^{
                 UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Смена пользователя" message:@"Вы уверены, что хотите выйти?" preferredStyle:UIAlertControllerStyleActionSheet];
                
                [actionSheet addAction:[UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [weakCell setSelected:NO animated:YES];
                    [currentWorkspace switchBackToWorkspace];
                    [currentWorkspace.navigationController popToRootViewControllerAnimated:YES];
                    // Cancel button tappped.
                }]];
                [actionSheet addAction:[UIAlertAction actionWithTitle:@"Нет" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [weakCell setSelected:NO animated:YES];
                    // Cancel button tappped.
                }]];
                
                [currentWorkspace.navigationController presentViewController:actionSheet animated:YES completion:nil];
                
            };
            [cellsArray addObject:cell];
        }
        
        
        //HeaderView
        DSPF_SideMenuHeader_technopark* header = [[[NSBundle mainBundle] loadNibNamed:@"DSPF_SideMenuHeader_technopark" owner:nil options:nil] objectAtIndex:0];
       // User* currentUser = [User userWithUserID:[NSUserDefaults currentUserID] inCtx:ctx()];
        
        _headerView = header;
        [self update];
        
        _cells = cellsArray;
    }
    return self;
}


- (void) update
{
    DSPF_SideMenuHeader_technopark* header = (DSPF_SideMenuHeader_technopark*)_headerView;
    
    header.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
    header.cashLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"CashName"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"CashName"]:@"-";
    header.cashboxLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"CashboxName"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"CashboxName"]:@"-";
    header.storeLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"StoreName"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"StoreName"]:@"-";
}

- (void) dealloc
{
}

@end
