//
//  ListeParticipantsView.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 17/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Evenement.h"

#import "ParticipantModel.h"

@interface ListeParticipantsView : UITableViewController <UITableViewDelegate, UITableViewDataSource, ParticipantModelProtocol>

@property(nonatomic, weak) Evenement *evenementSelected;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) NSString *API_url;

@end
