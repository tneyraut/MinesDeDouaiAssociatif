//
//  FormulaireDemandeProblemeView.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 01/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TicketModel.h"
#import "TicketMenuView.h"

@interface FormulaireDemandeProblemeView : UITableViewController <UITableViewDataSource, UITableViewDelegate, TicketModelProtocol>

@property(nonatomic, weak) TicketMenuView *ticketMenuView;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) NSString *API_url;

@end
