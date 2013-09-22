//
//  ViewController.m
//  AlbumCollection
//
//  Created by Hiroki Yoshifuji on 2013/09/19.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "ViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "Album.h"
#import "ThumbnailCell.h"
#import "HeaderView.h"
#import "TitleView.h"
#import "StackLayout.h"

@interface ViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSMutableArray* albums;
@property (nonatomic) UICollectionViewFlowLayout* flowLayout;
@property (nonatomic) StackLayout* stackLayout;
@end

@implementation ViewController
- (IBAction)segmentValueChange:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.collectionView setCollectionViewLayout:self.flowLayout];
        [self.collectionView reloadData];
    } else {
        [self.collectionView setCollectionViewLayout:self.stackLayout];
        [self.collectionView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.collectionView.allowsMultipleSelection = YES;
    
    self.flowLayout = [UICollectionViewFlowLayout new];
    
    StackLayout* stackLayout = [StackLayout new];
    stackLayout.sectionSize = CGSizeMake(100, 100);
    stackLayout.titleReferenceSize = CGSizeMake(100, 25);
    [self.collectionView setCollectionViewLayout:stackLayout];
    self.stackLayout = stackLayout;
    
    UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.collectionView addGestureRecognizer:pinchGesture];
    
    [self.collectionView registerClass:[TitleView class] forSupplementaryViewOfKind:StackLayoutElementKindTitle withReuseIdentifier:@"TitleView"];
    
    [self loadAlubm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    Album* album = self.albums[section];
    return [album.thumbnails count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.albums count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ThumbnailCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbnailCell"
                                                                    forIndexPath:indexPath];
    Album* album = self.albums[indexPath.section];
    UIImage* thumbnail = album.thumbnails[indexPath.item];
    cell.imageView.image = thumbnail;
    
    return cell;
}


// UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Album* album = self.albums[indexPath.section];
    UIImage* thumbnail = album.thumbnails[indexPath.item];
    
    return [ThumbnailCell sizeForImageSize:thumbnail.size];
}


- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HeaderView* headerView =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:@"HeaderView"
                                                  forIndexPath:indexPath];
        Album* album = self.albums[indexPath.section];
        headerView.titleLabel.text = album.title;
        return headerView;
    } else if ([kind isEqualToString:StackLayoutElementKindTitle]) {
        TitleView* titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                  withReuseIdentifier:@"TitleView"
                                                                         forIndexPath:indexPath];
        Album* album = self.albums[indexPath.section];
        titleView.titleLabel.text = album.title;
        return titleView;
    }
    return nil;
}

- (IBAction)delete:(id)sender {
    
    [self.collectionView performBatchUpdates:^{
        NSArray* indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSMutableArray* deleteObjects = @[].mutableCopy;
        for (NSIndexPath *indexPath in indexPaths) {
            Album* album = self.albums[indexPath.section];
            [deleteObjects addObject:album.thumbnails[indexPath.item]];
        }
        
        for (Album* album in self.albums) {
            NSMutableArray* tmpArray = album.thumbnails.mutableCopy;
            [tmpArray removeObjectsInArray:deleteObjects];
            album.thumbnails = tmpArray;
        }
        
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer*)sender
{
    StackLayout* layout = (StackLayout*)self.collectionView.collectionViewLayout;
    if (sender.state == UIGestureRecognizerStateBegan) {
        layout.pinchPoint = [sender locationInView:self.collectionView];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        layout.pinchScale = [sender scale];
    } else {
        layout.pinchScale = 0;
    }
}

- (void)loadAlubm {
    ALAssetsLibrary* library = [ALAssetsLibrary new];
    self.albums = @[].mutableCopy;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock =
    ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            NSMutableArray* thumbs = [NSMutableArray array];
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    UIImage* thumbnail
                    = [UIImage imageWithCGImage:result.aspectRatioThumbnail scale:self.view.window.screen.scale orientation:UIImageOrientationUp];
                    [thumbs addObject:thumbnail];
                } else {
                    Album* album = [Album new];
                    album.title = [group valueForProperty:ALAssetsGroupPropertyName];
                    album.thumbnails = [NSArray arrayWithArray:thumbs];
                    [self.albums addObject:album];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });
                }
            }];
        }
    };
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                           usingBlock:resultsBlock
                         failureBlock:^(NSError *error) {
                               NSLog(@"No groups");
                           }];
}
@end
