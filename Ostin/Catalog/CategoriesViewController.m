//
//  CategoriesViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 20/09/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "CategoriesViewController.h"
#import "MCPServer.h"
#import "CategoriesCollectionCell.h"
#import "GroupInformation.h"

@interface CategoriesViewController () <GroupsDelegate>
{
    NSArray* _groups;
    NSArray* _subgroups;
    NSArray* _brands;
    NSArray* _sex;
    NSArray* _models;
}


@property (nonatomic, assign) CollectionLevel level;

@end

@implementation CategoriesViewController

static NSString * const reuseIdentifier = @"CollectionIdentifier";


- (instancetype) initWithHierarchyLevel:(CollectionLevel)level
{
    self = [super init];
    
    if (self)
    {
        self.level = level;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoriesCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self requestData];
    
    // Do any additional setup after loading the view.
}

- (void) requestData
{
    switch (_level) {
        case CLGroups:
            [[MCPServer instance] groups:self uid:@"300"];
            break;
        case CLSubgroups:
            [[MCPServer instance] subgroups:self uid:@"300"];
            break;
        case CLSex:
            break;
        case CLBrands:
            [[MCPServer instance] brands:self uid:@"300"];
            break;
        case CLModels:
            [[MCPServer instance] groups:self uid:@"300"];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (_level) {
        case CLGroups:
            return _groups.count;
            break;
        case CLSubgroups:
            return _subgroups.count;
            break;
        case CLSex:
            return 2;
            break;
        case CLBrands:
            return _brands.count;
            break;
        case CLModels:
            return _models.count;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoriesCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    
    switch (_level) {
        case CLGroups:
        {
            GroupInformation* group = _groups[indexPath.row];
            cell.nameLabel.text     = group.groupName;
        }
            break;
        case CLSubgroups:
        {
            GroupInformation* group = _subgroups[indexPath.row];
            cell.nameLabel.text     = group.groupName;
        }
            break;
        case CLSex:
        {
            if (indexPath.row == 0)
                cell.nameLabel.text     = @"Мужское";
            else
                cell.nameLabel.text     = @"Женское";
        }
            break;
        case CLBrands:
        {
            GroupInformation* group = _groups[indexPath.row];
            cell.nameLabel.text     = group.groupName;
        }
            break;
        case CLModels:
        {
            GroupInformation* group = _groups[indexPath.row];
            cell.nameLabel.text     = group.groupName;
        }
            break;
            
        default:
            break;
    }
    
    //cell.backgroundColor = [UIColor blackColor];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/


// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_level) {
        case CLGroups:
            [self performSegueWithIdentifier:@"SubgroupsSegue" sender:nil];
            break;
        case CLSubgroups:
            [self performSegueWithIdentifier:@"SexSegue" sender:nil];
            break;
        case CLSex:
            [self performSegueWithIdentifier:@"FinalSegue" sender:nil];
            break;
            
        default:
            break;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if (![segue.destinationViewController isKindOfClass:[CategoriesViewController class]])
        return;
    
    CategoriesViewController* catVC = segue.destinationViewController;
    
    switch (_level) {
        case CLGroups:
            catVC.level = CLSubgroups;
            break;
        case CLSubgroups:
            catVC.level = CLSex;
            break;
        case CLSex:
            catVC.level = CLBrands;
            break;
            
        default:
            break;
    }
}

#pragma mark Network Delegate

- (void) groupsComplete:(int)result groups:(NSArray *)groups
{
    if (result == 0)
    {
        _groups = groups;
        [self.collectionView reloadData];
    }
    else
    {
        
    }
}

- (void) subgroupsComplete:(int)result subgroups:(NSArray *)subgroups
{
    if (result == 0)
    {
        _subgroups = subgroups;
        [self.collectionView reloadData];
    }
    else
    {
        
    }
}

- (void) brandsComplete:(int)result brands:(NSArray *)brands
{
    
}

@end
