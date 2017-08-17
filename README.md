# CoverFlow
![coverflow](https://user-images.githubusercontent.com/4393462/29405802-9c921660-835c-11e7-9edc-b0df915b4f68.gif)
# Usage
1. Import CustomFlowLayout module to your MIViewController class
   
         #import "CustomFlowLayout.h"

         @interface MIViewController : UIViewController<FlowLayoutDelegate>
         {
             IBOutlet UICollectionView *collCoverFlow;
         }
     
 2.Add CustomFlowLayout to MIViewController, then set delegate for it
 
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

3.Add Iteams in array(Here we can add bundle images but you can use URL instead of this).

         // Add iteams
         - (void)addItemInArray
         {
             [arrImages addObjectsFromArray:@[@{@"image":@"1.jpg"},
                                              @{@"image":@"2.jpg"},
                                              @{@"image":@"3.jpg"},
                                              @{@"image":@"4.jpg"},
                                              @{@"image":@"5.jpg"}]];
         }
