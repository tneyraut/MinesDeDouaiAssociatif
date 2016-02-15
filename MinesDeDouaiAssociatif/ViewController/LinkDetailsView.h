//
//  LinkDetailsView.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 18/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Link.h"

@interface LinkDetailsView : UITableViewController

@property(nonatomic, weak) Link *linkSelected;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) NSString *API_url;

@end
