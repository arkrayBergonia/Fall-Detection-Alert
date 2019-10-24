//
//  FallDetectViewController.m
//  Fall Detection Alert
//
//  Created by Francis Jemuel Bergonia on 24/10/2019.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

#import "FallDetectViewController.h"

@interface FallDetectViewController () {
    BOOL introCalled;
}

@end

@implementation FallDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!introCalled) {
        // show intro VC
        introCalled = YES;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"IntroVC"];
        [self presentViewController:ivc animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
