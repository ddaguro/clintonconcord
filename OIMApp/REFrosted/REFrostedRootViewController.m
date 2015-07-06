//
//  REFrostedRootViewController.m
//  Switch
//
//  Created by Ali Hamza on 11/06/2015.
//  Copyright (c) 2015 FourSpan Technologies. All rights reserved.
//

#import "REFrostedRootViewController.h"

@interface REFrostedRootViewController ()

@end

@implementation REFrostedRootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"REFrostedNavigationController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
}

@end
