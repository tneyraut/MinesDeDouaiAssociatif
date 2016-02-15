//
//  PartenairesView.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 11/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartenairesView : UITableViewController

@property(nonatomic, weak) NSArray *data;

@property(nonatomic, strong) NSMutableArray *imagesArray;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) NSString *API_url;

@end
