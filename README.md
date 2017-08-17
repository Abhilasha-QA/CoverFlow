# CoverFlow
![coverflow](https://user-images.githubusercontent.com/4393462/29405802-9c921660-835c-11e7-9edc-b0df915b4f68.gif)
# Usage
1. Import CustomFlowLayout and PhotoCollectionViewCell module to your MIViewController class
   
         #import "CustomFlowLayout.h"
         #import "PhotoCollectionViewCell.h"

         @interface MIViewController : UIViewController<FlowLayoutDelegate>
         {
             IBOutlet UICollectionView *collCoverFlow;
         }
     
 2. Add CustomFlowLayout and PhotoCollectionViewCell to MIViewController, then set delegate for it
 
         - (void)initialize
            {
                self.title = @"Cover Flow";

                arrImages = [[NSMutableArray alloc] init];
                [self addItemInArray];

                //... Collection view registerNib

                [collCoverFlow registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];

                //... Set Custom Layout Flow of Collection view

                CustomFlowLayout *cLayout = [[CustomFlowLayout alloc] init];
                cLayout.delegate = self;
                [collCoverFlow setCollectionViewLayout:cLayout animated:NO];
            }

3. Add Iteams in array to MIViewController (Here we can add bundle images but you can use URL instead of this).

         // Add iteams
         - (void)addItemInArray
         {
             [arrImages addObjectsFromArray:@[@{@"image":@"1.jpg"},
                                              @{@"image":@"2.jpg"},
                                              @{@"image":@"3.jpg"},
                                              @{@"image":@"4.jpg"},
                                              @{@"image":@"5.jpg"}]];
         }
         
4. Add CollectionView Delegate to MIViewController

         #pragma mark
         #pragma mark - CollectionView Delegate

         - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
         {
             //... total image + 1 for Last cell is Tap to Reload
             return arrImages.count + 1;
         }

         - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
         {
             //... Propotional height and width of collection view cell according Device
             int size = CScreenWidth * 304 / 375;
             return CGSizeMake(size ,size);
         }

         - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
         {
             static NSString *identifier = @"PhotoCollectionViewCell";
             PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

             //... Configure cell

             cell.tag = indexPath.row;

             if (indexPath.row == arrImages.count)
             {
                 //... Tap to Reload
                 cell.lblReload.hidden = NO;
                 cell.imageView.hidden = YES;
             }
             else
             {
                 //... Image cell
                 cell.lblReload.hidden = YES;
                 cell.imageView.hidden = NO;
                 NSDictionary *dictData = arrImages[indexPath.row];
                 cell.imageView.image = [UIImage imageNamed:[dictData valueForKey:@"image"]];
             }

             return cell;
         }

         - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
         {
             if (arrImages.count == 0)
             {
                 //... Last cell for Tap To Reload
                 //... When arrImage count is 0
                 [self addItemInArray];
                 [collCoverFlow reloadData];
             }
         }

5. Add Custom Flow layout Delegate to MIViewController

            #pragma mark
            #pragma mark - Custom Flow layout Delegate

            - (BOOL)shouldCellMoveUpForIndexPath:(NSIndexPath *)indexpath
            {
                //... arrImage count greater than 0 return YES else return NO
                //... return YES that means Cell of indexpath is movable

                return arrImages.count != 0;
            }

            - (void)cellDidMovedUp:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
            {
                //...Remove item from Array and Reload Collection view
                [arrImages removeObjectAtIndex:indexPath.row];
                [collCoverFlow reloadData];
            }
