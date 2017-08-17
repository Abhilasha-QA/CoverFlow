# CoverFlow
![coverflow](https://user-images.githubusercontent.com/4393462/29405802-9c921660-835c-11e7-9edc-b0df915b4f68.gif)
# Usage
1. Import CustomFlowLayout module to your MIViewController class
   
     #import "CustomFlowLayout.h"
     
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
