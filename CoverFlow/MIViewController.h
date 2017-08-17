//
//  MIViewController.h
//  CoverFlow
//
//  Created by Mindinventory on 6/12/17.
//  Copyright © 2017 MindInventory. All rights reserved.



#import <UIKit/UIKit.h>
#import "CustomFlowLayout.h"

@interface MIViewController : UIViewController<FlowLayoutDelegate>
{
    IBOutlet UICollectionView *collCoverFlow;
}
@end
