//
//  TicketMenuView.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 07/09/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@interface TicketMenuView : UITableViewController

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) User *user;

@property(nonatomic, weak) NSString *API_url;

@end
