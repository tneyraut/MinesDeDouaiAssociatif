//
//  TicketModel.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 01/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TicketModelProtocol <NSObject>

- (void) ticketDone:(NSArray *)items;

@end

@interface TicketModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id<TicketModelProtocol> delegate;

@property(nonatomic, weak) NSString *API_url;

- (void) createTicket:(NSDictionary*)dictionary;

- (void) getTicketsOpenedByUserID:(int)user_id;

- (void) getTicketsClosedByUserID:(int)user_id;

- (void) getAllTicketsOpened;

- (void) getAllTicketsClosed;

- (void) getTicketByID:(int)ticket_id;

- (void) sendMessage:(NSString *)message ticket_id:(int)ticket_id;

- (void) changerStatusTicket:(int)ticket_id status:(NSString *)status;

- (void) affecterTicket:(int)ticket_id user_id:(int)user_id;

- (void) desaffecterTicket:(int)ticket_id;

@end
