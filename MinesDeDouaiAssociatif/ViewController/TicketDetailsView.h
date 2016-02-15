//
//  TicketDetailsView.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 08/09/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TicketModel.h"

#import "Ticket.h"

@interface TicketDetailsView : UITableViewController <UITableViewDelegate, UITableViewDataSource, TicketModelProtocol>

@property(nonatomic, weak) Ticket *ticketSelected;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) User *user;

@property(nonatomic, weak) NSString *API_url;

@end
