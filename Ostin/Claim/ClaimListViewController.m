//
//  ClaimListViewController.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ClaimListViewController.h"
#import "ClaimItemCell.h"
#import "ClaimItemInformation.h"
#import "ClaimItemInformationCell.h"
#import "AsyncImageView.h"
#import "MCPServer.h"
#import "DTDevices.h"

#import "TransitionDelegate.h"
#import "ImageViewController.h"

#import "WYStoryboardPopoverSegue.h"
#import "OstinSettingsViewController.h"
#import "SettingGroupCase.h"
#import "SettingGroupSync.h"
#import "SettingGroupUser.h"
#import "SettingGroupManualInput.h"

@interface ClaimListViewController () <UITableViewDelegate, UITableViewDataSource, AcceptancesDataSourceDelegate>
{
    UIActivityIndicatorView *_activityIndicator;
    WYPopoverController *_settingsPopover;
    NSTimer *_timer;
    BOOL scrolingInProgress;
}
@property (nonatomic, strong) ClaimDataSource *dataSource;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *changeClaimStateButton;
@end

@implementation ClaimListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClaimItemCell" bundle:nil] forCellReuseIdentifier:@"ClaimItemCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClaimItemInformationCell" bundle:nil] forCellReuseIdentifier:@"ClaimItemInformationCell"];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:60];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    _dataSource = [[ClaimDataSource alloc] initWithAcceptanceItem:_rootItem];
    _dataSource.delegate = self;
    
    [self initializeView];
    [self showLoadingIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self subscribeToScanNotifications];
    [self.dataSource update];
    
    if (!self.dataSource.rootItem)
        [self initializeTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unsubscribeFromScanNotifications];
    
    if (!self.dataSource.rootItem)
        [self destroyTimer];
}

- (void)initializeView
{
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    
    if (self.dataSource.rootItem)
    {
        _changeClaimStateButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:self action:@selector(changeClaimStateButtonAction:)];
        _changeClaimStateButton.enabled = NO;
        self.navigationItem.rightBarButtonItems = @[menuButton, _changeClaimStateButton];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = menuButton;
    }
}

- (void)initializeTimer
{
    if (_timer)
        [_timer invalidate];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)destroyTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark Notifications

- (void)subscribeToScanNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveScanNotification:) name:@"BarcodeScanNotification" object:nil];
}

- (void)unsubscribeFromScanNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BarcodeScanNotification" object:nil];
}

- (void)didReceiveScanNotification:(NSNotification *)notification
{
    NSString *barcode = notification.object[@"barcode"];
    NSNumber *type = notification.object[@"type"];

    if (_rootItem.startDate && !_rootItem.endDate)
        [self.dataSource didScannedBarcode:barcode type:type.intValue];
}

#pragma mark - UITableViewDataSource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource numberOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.dataSource itemAtIndex:indexPath.row];
    
    if ([item isKindOfClass:[ClaimItem class]])
    {
        ClaimItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClaimItemCell"];
        [cell configureWithAcceptanceItem:item];
        
        return cell;
    }
    else if ([item isKindOfClass:[ClaimItemInformation class]])
    {
        ClaimItemInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClaimItemInformationCell"];
        [cell configureWithAcceptanceItem:item cancelButtonEnabled:(_rootItem.startDate && !_rootItem.endDate)];
        cell.zoomEnabled = NO;
        
        if ([item descriptionForKey:@"pictureURLString"])
        {
            NSString *pictureURLString = [item descriptionForKey:@"pictureURLString"];
            
            //_pictureImageView.imageURL = [NSURL URLWithString:pictureURLString];
            NSURL* imageURL = [NSURL URLWithString:pictureURLString];
            [cell.pictureImageView  setImageURL:imageURL
                                    successBlock:^(UIImage* image)
             {
                 cell.pictureImageView.image = image;
                 cell.zoomEnabled = YES;
                 
             }
                                    failureBlock:^(NSError* error)
             {
                 NSLog(@"fail");
             }];
        }
        
        
        __weak ClaimItemInformationCell* _cell = cell;
        cell.actionBlock = ^{
            
             CGRect imageFrame = [_cell.pictureImageView convertRect:_cell.imageView.bounds toView:self.navigationController.view];
            imageFrame.size = _cell.pictureImageView.frame.size;
            NSLog(@"%@", NSStringFromCGRect(_cell.pictureImageView.frame));
            TransitionDelegate* trDelegate = [TransitionDelegate new];
            trDelegate.initialFrame = imageFrame;
            ImageViewController* imageVC = [ImageViewController new];
            imageVC.image = _cell.pictureImageView.image;
            __weak ImageViewController *_imageVC = imageVC;
            imageVC.transitioningDelegate = trDelegate;
            imageVC.tapAction = ^{
                TransitionDelegate *trDelegate = [TransitionDelegate new];
                trDelegate.initialFrame = imageFrame;
                
                _imageVC.transitioningDelegate = trDelegate;
                [self dismissViewControllerAnimated:YES completion:nil];
            };
            
            [self presentViewController:imageVC animated:YES completion:nil];
        };
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[ClaimItemInformationCell class]])
    {
        ClaimItemInformationCell *_cell = (ClaimItemInformationCell *)cell;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:_cell.pictureImageView];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    id item = [self.dataSource itemAtIndex:indexPath.row];
    if ([item isKindOfClass:[ClaimItem class]])
    {
        ClaimListViewController *vc = [[UIStoryboard storyboardWithName:@"IM_Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClaimVC"];
        vc.rootItem = item;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([item isKindOfClass:[ClaimItemInformation class]])
    {
        if (_rootItem.startDate && !_rootItem.endDate)
            [self showCancelReasonPickerForClaimItemInformation:item];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrolingInProgress = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    scrolingInProgress = NO;
}

#pragma mark - AcceptancesDataSource delegate

- (void)acceptancesDataSourceDidUpdate
{
    [self.tableView reloadData];
    [self hideLoadingIndicator];
}

- (void)acceptancesDataSourceDidDeleteItemsAtIndexes:(NSArray *)indexesForDelete addedItemsAtIndexes:(NSArray *)indexesForInsert
{
    [self hideLoadingIndicator];
    
    NSMutableArray *indexPathsForDelete = [NSMutableArray new];
    NSMutableArray *indexPathsForInsert = [NSMutableArray new];
    for (NSNumber *index in indexesForDelete)
        [indexPathsForDelete addObject:[NSIndexPath indexPathForRow:index.intValue inSection:0]];
    for (NSNumber *index in indexesForInsert)
        [indexPathsForInsert addObject:[NSIndexPath indexPathForRow:index.intValue inSection:0]];
    
    [self.tableView beginUpdates];
    if (indexPathsForDelete.count > 0)
        [self.tableView deleteRowsAtIndexPaths:indexPathsForDelete withRowAnimation:UITableViewRowAnimationAutomatic];
    if (indexPathsForInsert.count > 0)
        [self.tableView insertRowsAtIndexPaths:indexPathsForInsert withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)acceptancesDataSourceDidUpdateItemAtIndex:(NSUInteger)index
{
    DTDevices *dtDev = [DTDevices sharedDevice];
    int data[]={300,70,500,70,700,70,900,70};
    [dtDev playSound:100 beepData:data length:sizeof(data) error:nil];
    
    NSIndexPath *indexPathForUpdatedItem = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathForUpdatedItem] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollToRowAtIndexPath:indexPathForUpdatedItem atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)acceptancesDataSourceErrorOccurred:(NSString *)errorMessage
{
    DTDevices *dtDev = [DTDevices sharedDevice];
    int data[]={800,400,0,200,800,400};
    [dtDev playSound:100 beepData:data length:sizeof(data) error:nil];
    
    [self showAlertWithMessage:errorMessage];
}

#pragma mark - Actions

- (void)changeClaimStateButtonAction:(id)sender
{
    NSDate *now = [NSDate date];
    NSDate *startDate = _rootItem.startDate ? _rootItem.startDate : now;
    NSDate *endDate = _rootItem.startDate ? now : nil;
    NSString *userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
    
    __weak typeof(self) wself = self;
    [self showLoadingIndicator];
    [[MCPServer instance] saveClaimWithID:_rootItem.claimID userID:userID startDate:startDate endDate:endDate completion:^(BOOL success, NSString *errorMessage) {
        
        if (success)
        {
            wself.rootItem.startDate = startDate;
            wself.rootItem.endDate = endDate;
            [wself updateVisibleRows];
        }
        else
        {
            [wself showInfoAlertWithMessage:errorMessage];
        }
        [wself hideLoadingIndicator];
    }];
}

- (void)menuButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"MelonPopover" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MelonPopover"])
    {
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        
        OstinSettingsViewController* destinationViewController = (OstinSettingsViewController *)segue.destinationViewController;
        destinationViewController.preferredContentSize = CGSizeMake(260, 300);
        
        SettingGroupCase *caseSettings = [[SettingGroupCase alloc] init];
        SettingGroupSync *syncSettings = [[SettingGroupSync alloc] init];
        SettingGroupUser *userSettings = [[SettingGroupUser alloc] init];
        SettingGroupManualInput *manualInputSettings = [[SettingGroupManualInput alloc] init];
        manualInputSettings.settingActions[0].action = ^
        {
            if (_rootItem.startDate && !_rootItem.endDate)
            {
                [self showManualInputAlert];
                [_settingsPopover dismissPopoverAnimated:YES];
            }
            else
            {
                [self showAlertWithMessage:@"Задание не взято в работу"];
                [_settingsPopover dismissPopoverAnimated:YES];
            }
        };
        
        if (self.dataSource.rootItem)
            destinationViewController.settingsGroups = @[manualInputSettings, userSettings, caseSettings, syncSettings];
        else
            destinationViewController.settingsGroups = @[userSettings, caseSettings, syncSettings];
        
        _settingsPopover = [popoverSegue popoverControllerWithSender:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
    }
}

- (void)timerAction
{
    if (!scrolingInProgress)
        [self updateVisibleRows];
}

#pragma mark - UI

- (void)updateClaimStateButton
{
    if (self.rootItem)
    {
        if (_rootItem.startDate == nil)
        {
            _changeClaimStateButton.title = @"Взять в работу";
            _changeClaimStateButton.enabled = YES;
        }
        else if (_rootItem.endDate == nil)
        {
            _changeClaimStateButton.title = @"Завершить";
            _changeClaimStateButton.enabled = YES;
        }
        else
        {
            _changeClaimStateButton.title = @"Завершено";
            _changeClaimStateButton.enabled = NO;
        }
    }
}

- (void)showCancelReasonPickerForClaimItemInformation:(ClaimItemInformation *)claimItemInfo
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Причина отклонения" message:@"Укажите причину отклонения" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"Витринный экземпляр" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [claimItemInfo setCancelReason:@"12430299"];
        [self updateVisibleRows];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Комплект" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [claimItemInfo setCancelReason:@"14820299"];
        [self updateVisibleRows];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Не найдено в РМ/Не хватает количества" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [claimItemInfo setCancelReason:@"14030299"];
        [self updateVisibleRows];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Нет в наличии на ФРЦ/РРЦ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [claimItemInfo setCancelReason:@"14050299"];
        [self updateVisibleRows];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Недостатки/не хватает комплектующих" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [claimItemInfo setCancelReason:@"14060299"];
        [self updateVisibleRows];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"На остатках \"0\"" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [claimItemInfo setCancelReason:@"14070299"];
        [self updateVisibleRows];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Инвентаризация" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [claimItemInfo setCancelReason:@"15420299"];
        [self updateVisibleRows];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Товар упакован к отправке" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [claimItemInfo setCancelReason:@"15670299"];
        [self updateVisibleRows];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showManualInputAlert
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ручной ввод" message:@"Введите код товара" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Отправить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [self.dataSource processItemCode:alert.textFields[0].text];
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField* textField){}];
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateVisibleRows
{
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)showLoadingIndicator
{
    if (_activityIndicator == nil)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.center = self.view.center;
    }
    
    [self.view addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    [self.tableView setScrollEnabled:NO];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [_changeClaimStateButton setEnabled:NO];
}

- (void)hideLoadingIndicator
{
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
    [self.tableView setScrollEnabled:YES];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self updateClaimStateButton];
}

- (void)showAlertWithMessage:(NSString*)message
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ac dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)showInfoAlertWithMessage:(NSString*)message
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancelAction];
    [self presentViewController:ac animated:YES completion:nil];
}

@end
