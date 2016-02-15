//
//  TicketModel.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 01/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "TicketModel.h"

#import "Ticket.h"
#import "User.h"
#import "Message.h"

@interface TicketModel()

@property(nonatomic, strong) NSMutableData *downloadedDataTicket;

@property(nonatomic) BOOL downloadMessages;

@property(nonatomic) BOOL airMember;

@end

@implementation TicketModel

- (void) createTicket:(NSDictionary *)dictionary
{
    NSString *title = [[dictionary objectForKey:@"title"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *type = [[dictionary objectForKey:@"type"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *url = [[[@"title="
                       stringByAppendingString:title]
                      stringByAppendingString:@"&type="]
                     stringByAppendingString:type];
    
    if ([type isEqualToString:@"Site%20des%20élèves"])
    {
        NSString *objet = [[dictionary objectForKey:@"objet"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        url = [[url stringByAppendingString:@"&objet="] stringByAppendingString:objet];
        
        if ([objet isEqualToString:@"createAssociation"])
        {
            NSString *nouveauNomAssociation = [[dictionary objectForKey:@"newNomAssociation"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSString *president = [[dictionary objectForKey:@"president"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSString *description = [[dictionary objectForKey:@"description"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            url = [[[[[[url stringByAppendingString:@"&newNomAssociation="]
                       stringByAppendingString:nouveauNomAssociation]
                      stringByAppendingString:@"&president="]
                     stringByAppendingString:president]
                    stringByAppendingString:@"&description="]
                   stringByAppendingString:description];
        }
        
        else if ([objet isEqualToString:@"bug"])
        {
            NSString *description = [[dictionary objectForKey:@"description"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            url = [[url stringByAppendingString:@"&description="]
                   stringByAppendingString:description];
        }
    }
    
    else if ([type isEqualToString:@"Alias"])
    {
        NSString *objet = [[dictionary objectForKey:@"objet"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        url = [[url stringByAppendingString:@"&objet="]
               stringByAppendingString:objet];
        
        if ([objet isEqualToString:@"create"])
        {
            NSString *description = [[dictionary objectForKey:@"description"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSString *adresse = [[dictionary objectForKey:@"adresse"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSString *addAdresses = [[dictionary objectForKey:@"addAdresses"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            url = [[[[[[url stringByAppendingString:@"&description="]
                       stringByAppendingString:description]
                      stringByAppendingString:@"&adresse="]
                     stringByAppendingString:adresse]
                    stringByAppendingString:@"&addAdresses="]
                   stringByAppendingString:addAdresses];
        }
        
        else if ([objet isEqualToString:@"update"])
        {
            NSString *adresse = [[dictionary objectForKey:@"adresse"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSString *addAdresses = [[dictionary objectForKey:@"addAdresses"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSString *removeAdresses = [[dictionary objectForKey:@"removeAdresses"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSString *reset = [[dictionary objectForKey:@"reset"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            url = [[[[[[[[url stringByAppendingString:@"&adresse="]
                         stringByAppendingString:adresse]
                        stringByAppendingString:@"&addAdresses="]
                       stringByAppendingString:addAdresses]
                      stringByAppendingString:@"&removeAdresses="]
                     stringByAppendingString:removeAdresses]
                    stringByAppendingString:@"&reset="]
                   stringByAppendingString:reset];
        }
        
        else if ([objet isEqualToString:@"delete"] || [objet isEqualToString:@"createCompte"])
        {
            NSString *adresse = [[dictionary objectForKey:@"adresse"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            url = [[url stringByAppendingString:@"&adresse="]
                   stringByAppendingString:adresse];
        }
    }
    
    else if ([type isEqualToString:@"Hébergement"])
    {
        NSString *typeHebergement = [[dictionary objectForKey:@"typeHebergement"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *nomProjet = [[dictionary objectForKey:@"nomProjet"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *description = [[dictionary objectForKey:@"description"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *typeDepot = [[dictionary objectForKey:@"typeDepot"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        BOOL creerBDD = NO;
        if ([[dictionary objectForKey:@"creerBDD"] isEqualToString:@"Oui"])
        {
            creerBDD = YES;
        }
        
        url = [[[[[[[[[[url stringByAppendingString:@"&typeHebergement="]
                       stringByAppendingString:typeHebergement]
                      stringByAppendingString:@"&nomProjet="]
                     stringByAppendingString:nomProjet]
                    stringByAppendingString:@"&description="]
                   stringByAppendingString:description]
                  stringByAppendingString:@"&typeDepot="]
                 stringByAppendingString:typeDepot]
                stringByAppendingString:@"&creerDepot="]
               stringByAppendingString:[NSString stringWithFormat:@"%d", creerBDD]];
    }
    
    else if ([type isEqualToString:@"Autre"])
    {
        NSString *description = [[dictionary objectForKey:@"description"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        url = [[url stringByAppendingString:@"&description="]
               stringByAppendingString:description];
    }
    
    else if ([type isEqualToString:@"Mot%20de%20passe"])
    {
        NSString *email = [[dictionary objectForKey:@"email"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
       
        NSString *description = [[dictionary objectForKey:@"description"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        url = [[[[url stringByAppendingString:@"&email="]
                 stringByAppendingString:email]
                stringByAppendingString:@"&description="]
               stringByAppendingString:description];
    }
    
    else if ([type isEqualToString:@"Problème%20technique"])
    {
        NSString *description = [[dictionary objectForKey:@"description"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        url = [[url stringByAppendingString:@"&description="]
               stringByAppendingString:description];
    }
    
    else if ([type isEqualToString:@"Problème%20réseau"])
    {
        NSString *description = [[dictionary objectForKey:@"description"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *typeConnexion = [[dictionary objectForKey:@"typeConnexion"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *dateInterruptionConnexion = [[dictionary objectForKey:@"dateInterruptionConnexion"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *typeMateriel = [[dictionary objectForKey:@"typeMateriel"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *logicielsInstalled = [[dictionary objectForKey:@"logicielsInstalled"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *tutoSuivi = [[dictionary objectForKey:@"tutoSuivi"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *detecteReseau = [[dictionary objectForKey:@"detecteReseau"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *detecteReseauVoisin = [[dictionary objectForKey:@"detecteReseauVoisin"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *listeChambres = [[dictionary objectForKey:@"listeChambres"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *autreChambre = [[dictionary objectForKey:@"autreChambre"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        url = [[[[[[[[[[[[[[[[[[[[url stringByAppendingString:@"&description="]
                                 stringByAppendingString:description]
                                stringByAppendingString:@"&typeConnexion="]
                               stringByAppendingString:typeConnexion]
                              stringByAppendingString:@"&dateInterruptionConnexion="]
                             stringByAppendingString:dateInterruptionConnexion]
                            stringByAppendingString:@"&typeMateriel="]
                           stringByAppendingString:typeMateriel]
                          stringByAppendingString:@"&logicielsInstalled="]
                         stringByAppendingString:logicielsInstalled]
                        stringByAppendingString:@"&tutoSuivi="]
                       stringByAppendingString:tutoSuivi]
                      stringByAppendingString:@"&detecteReseau="]
                     stringByAppendingString:detecteReseau]
                    stringByAppendingString:@"&detecteReseauVoisin="]
                   stringByAppendingString:detecteReseauVoisin]
                  stringByAppendingString:@"&listeChambre="]
                 stringByAppendingString:listeChambres]
                stringByAppendingString:@"&autreChambre="]
               stringByAppendingString:autreChambre];
    }
    
    NSData *postData = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ticket/create", self.API_url]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) getTicketsOpenedByUserID:(int)user_id
{
    self.airMember = NO;
    
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@ticket/list?author_id=%d&open=%d&respoOnly=%d", self.API_url, user_id, 1, 0]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getTicketsClosedByUserID:(int)user_id
{
    self.airMember = NO;
    
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@ticket/list?author_id=%d&open=%d&respoOnly=%d", self.API_url, user_id, 0, 0]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getAllTicketsOpened
{
    self.airMember = YES;
    
    self.downloadMessages = NO;
    
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@ticket/list?open=%d&respoOnly=%d", self.API_url, 1, 0]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getAllTicketsClosed
{
    self.airMember = YES;
    
    self.downloadMessages = NO;
    
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@ticket/list?open=%d&respoOnly=%d", self.API_url, 0, 0]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getTicketByID:(int)ticket_id
{
    self.downloadMessages = YES;
    
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@ticket/view?id=%d", self.API_url, ticket_id]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) sendMessage:(NSString *)message ticket_id:(int)ticket_id
{
    NSString *url = [NSString stringWithFormat:@"id=%d&content=%@", ticket_id, message];
    
    NSData *postData = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ticket/sendMessage", self.API_url]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) changerStatusTicket:(int)ticket_id status:(NSString *)status
{
    NSString *url = [NSString stringWithFormat:@"id=%d&status=%@", ticket_id, status];
    
    NSData *postData = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ticket/changeStatus", self.API_url]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) affecterTicket:(int)ticket_id user_id:(int)user_id
{
    NSString *url = [NSString stringWithFormat:@"id=%d&user_id=%d", ticket_id, user_id];
    
    NSData *postData = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ticket/affectTo", self.API_url]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) desaffecterTicket:(int)ticket_id
{
    NSString *url = [NSString stringWithFormat:@"id=%d", ticket_id];
    
    NSData *postData = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ticket/unaffect", self.API_url]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadedDataTicket appendData:data];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.downloadedDataTicket = [[NSMutableData alloc] init];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSError* error;
    
    NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:self.downloadedDataTicket options:NSJSONReadingAllowFragments error:&error];
    
    if (self.downloadMessages)
    {
        NSArray *messages = jsonArray[@"messages"];
        
        for (int i=0;i<messages.count;i++)
        {
            NSDictionary *messageDictionary = messages[i];
            
            Message *message = [[Message alloc] init];
            
            message.message_id = [messageDictionary[@"id"] intValue];
            
            NSDictionary *author = messageDictionary[@"author"];
            
            message.author_id = [author[@"id"] intValue];
            
            message.message = messageDictionary[@"content"];
            
            message.date = messageDictionary[@"updatedAt"];
            
            [array addObject:message];
        }
        
        if (self.delegate)
        {
            [self.delegate ticketDone:array];
        }
        
        return;
    }
    
    NSArray *tickets;
    if (self.airMember)
    {
        tickets = jsonArray[@"tickets"];
    }
    else
    {
        tickets = jsonArray[@"tickets"];
    }
    
    for (int i=0;i<tickets.count;i++)
    {
        Ticket *ticket = [[Ticket alloc] init];
        
        NSDictionary *ticketDictionary = tickets[i];
        
        NSDictionary *createur = ticketDictionary[@"author"];
        
        User *user_createur = [[User alloc] init];
        
        user_createur.user_id = [createur[@"id"] intValue];
        
        user_createur.chambre = createur[@"chambre"];
        
        user_createur.avatar = createur[@"avatar"];
        
        user_createur.prenom = createur[@"prenom"];
        
        user_createur.nom = createur[@"nom"];
        
        user_createur.residence = createur[@"residence"];
        
        ticket.createur = user_createur;
        
        if (ticketDictionary[@"affectedTo"])
        {
            NSDictionary *affectedTo = ticketDictionary[@"affectedTo"];
            
            User *airMember = [[User alloc] init];
            
            airMember.user_id = [affectedTo[@"id"] intValue];
            
            airMember.chambre = affectedTo[@"chambre"];
            
            airMember.avatar = affectedTo[@"avatar"];
            
            airMember.prenom = affectedTo[@"prenom"];
            
            airMember.nom = affectedTo[@"nom"];
            
            airMember.residence = affectedTo[@"residence"];
            
            ticket.airMember = airMember;
        }
        
        ticket.dateCreation = ticketDictionary[@"createdAt"];
        
        ticket.ticket_id = [ticketDictionary[@"id"] intValue];
        
        ticket.isPublic = [ticketDictionary[@"isPublic"] boolValue];
        
        ticket.title = ticketDictionary[@"title"];
        
        ticket.status = ticketDictionary[@"status"];
        
        NSArray *typeArray = ticketDictionary[@"tags"];
        
        if (typeArray.count != 0)
        {
            ticket.labelType = typeArray[0];
        }
        else
        {
            ticket.labelType = @"sans tag";
        }
        
        [array addObject:ticket];
    }
    
    if (self.delegate)
    {
        [self.delegate ticketDone:array];
    }
}

@end
