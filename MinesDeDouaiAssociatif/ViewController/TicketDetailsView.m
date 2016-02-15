//
//  TicketDetailsView.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 08/09/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "TicketDetailsView.h"

#import "SpecificTableViewCell.h"
#import "SpecificTableViewCellWithoutImage.h"

#import "Message.h"

@interface TicketDetailsView () <UIAlertViewDelegate, UIActionSheetDelegate>

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSMutableArray *imageArray;

@property(nonatomic, strong) NSArray *elementArray;

@property(nonatomic, strong) TicketModel *_ticketModel;

@property(nonatomic, strong) NSArray *messageArray;

@property(nonatomic, strong) NSArray *administrationArray;

@property(nonatomic) BOOL sendingMessage;

@property(nonatomic) BOOL affectation;

@property(nonatomic) BOOL desaffectation;

@property(nonatomic) BOOL changementStatus;

@end

@implementation TicketDetailsView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:self.ticketSelected.title];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    [self.navigationController.navigationBar.backItem.backBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:self.ticketSelected.title style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) setAllImage
{
    self.imageArray = [[NSMutableArray alloc] init];
    
    [self.imageArray addObject:NSLocalizedString(@"ICON_NAME_TICKET", @"ICON_NAME_TICKET")];
    
    [self.imageArray addObject:NSLocalizedString(@"ICON_NAME_TYPE", @"ICON_NAME_TYPE")];
    
    [self.imageArray addObject:NSLocalizedString(@"ICON_NAME_CALENDAR", @"ICON_NAME_CALENDAR")];
    
    [self.imageArray addObject:NSLocalizedString(@"ICON_NAME_TITLE", @"ICON_NAME_TITLE")];
    
    [self.imageArray addObject:NSLocalizedString(@"ICON_NAME_AUTEUR_TICKET", @"ICON_NAME_AUTEUR_TICKET")];
    
    [self.imageArray addObject:NSLocalizedString(@"ICON_NAME_AIR_MEMBER", @"ICON_NAME_AIR_MEMBER")];
}

- (void) downloadTicketMessages:(int)ticket_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._ticketModel)
    {
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        self._ticketModel = [[TicketModel alloc] init];
        
        self._ticketModel.API_url = self.API_url;
        
        self._ticketModel.delegate = self;
    }
    
    self.messageArray = [[NSArray alloc] init];
    
    [self._ticketModel getTicketByID:ticket_id];
}

- (void) ticketDone:(NSArray *)items
{
    if (self.sendingMessage)
    {
        self.sendingMessage = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Votre message a bien été envoyé" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        [self.activityIndicatorView stopAnimating];
        
        [self downloadTicketMessages:self.ticketSelected.ticket_id];
        
        return;
    }
    else if (self.affectation)
    {
        self.affectation = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Ce ticket vous est maintenant affecté" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        self.ticketSelected.airMember = self.user;
        
        [self settingElementArray];
        
        [self settingAdministrationArray];
        
        [self.tableView reloadData];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    else if (self.desaffectation)
    {
        self.desaffectation = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Ce ticket vous est maintenant désaffecté" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        self.ticketSelected.airMember = nil;
        
        [self settingElementArray];
        
        [self settingAdministrationArray];
        
        [self.tableView reloadData];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    else if (self.changementStatus)
    {
        self.changementStatus = NO;
        
        [self settingElementArray];
        
        [self.tableView reloadData];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    else if (items.count == 0)
    {
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    
    self.messageArray = items;
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

- (void) buttonSendMessageActionListener
{
    if (self.ticketSelected.airMember && self.ticketSelected.airMember.user_id != self.user.user_id)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Vous n'êtes pas affecté à ce ticket, vous ne pouvez pas envoyer de message..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] init];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    alertView.title = @"Envoie d'un message";
    
    alertView.message = @"Veuillez saisir votre message";
    
    [alertView textFieldAtIndex:0].placeholder = @"votre message...";
    
    [alertView addButtonWithTitle:@"Envoyer"];
    
    [alertView setDelegate:self];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Envoyer"])
    {
        if ([[alertView textFieldAtIndex:0].text isEqualToString:@""])
        {
            UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Veuillez rentrer un contenu à votre message" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [errorView show];
        }
        else
        {
            [self.activityIndicatorView startAnimating];
            
            self.sendingMessage = YES;
            
            [self._ticketModel sendMessage:[alertView textFieldAtIndex:0].text ticket_id:self.ticketSelected.ticket_id];
        }
    }
    
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Oui"] && self.affectation)
    {
        [self.activityIndicatorView startAnimating];
        
        [self._ticketModel affecterTicket:self.ticketSelected.ticket_id user_id:self.user.user_id];
    }
    
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Oui"] && self.desaffectation)
    {
        [self.activityIndicatorView startAnimating];
        
        [self._ticketModel affecterTicket:self.ticketSelected.ticket_id user_id:self.user.user_id];
    }
    
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Non"])
    {
        self.affectation = NO;
        
        self.desaffectation = NO;
    }
}

- (void) settingElementArray
{
    NSString *jour = [self.ticketSelected.dateCreation substringWithRange:NSMakeRange(8, 2)];
    
    NSString *mois = [self.ticketSelected.dateCreation substringWithRange:NSMakeRange(5, 2)];
    
    NSString *annee = [self.ticketSelected.dateCreation substringWithRange:NSMakeRange(0, 4)];
    
    NSString *heure = [self.ticketSelected.dateCreation substringWithRange:NSMakeRange(11, 2)];
    
    NSString *minute = [self.ticketSelected.dateCreation substringWithRange:NSMakeRange(14, 2)];
    
    if (self.ticketSelected.airMember)
    {
        self.elementArray = [[NSArray alloc] initWithObjects:self.ticketSelected.title, self.ticketSelected.labelType, [NSString stringWithFormat:@"Créé le %@/%@/%@ à %@h%@", jour, mois, annee, heure, minute], [@"Status : " stringByAppendingString:self.ticketSelected.status], [NSString stringWithFormat:@"%@ %@", self.ticketSelected.createur.prenom, self.ticketSelected.createur.nom], [NSString stringWithFormat:@"%@ %@", self.ticketSelected.airMember.prenom, self.ticketSelected.airMember.nom], nil];
    }
    else
    {
        self.elementArray = [[NSArray alloc] initWithObjects:self.ticketSelected.title, self.ticketSelected.labelType, [NSString stringWithFormat:@"Créé le %@/%@/%@ à %@h%@", jour, mois, annee, heure, minute], [@"Status : " stringByAppendingString:self.ticketSelected.status], [NSString stringWithFormat:@"%@ %@", self.ticketSelected.createur.prenom, self.ticketSelected.createur.nom], nil];
    }
}

- (void) settingAdministrationArray
{
    if (self.user.airMember)
    {
        if (!self.ticketSelected.airMember)
        {
            self.administrationArray = [[NSArray alloc] initWithObjects:@"S'affecter le ticket", nil];
        }
        else if (self.ticketSelected.airMember.user_id == self.user.user_id)
        {
            self.administrationArray = [[NSArray alloc] initWithObjects:@"Changer le status", @"Se désaffecter le ticket", nil];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cellMessage"];
    
    [self.tableView registerClass:[SpecificTableViewCellWithoutImage class] forCellReuseIdentifier:@"cellWithoutImage"];
    
    [self initialisationView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self settingElementArray];
    
    [self settingAdministrationArray];
    
    self.sendingMessage = NO;
    
    self.affectation = NO;
    
    self.desaffectation = NO;
    
    self.changementStatus = NO;
    
    [self setAllImage];
    
    [self downloadTicketMessages:self.ticketSelected.ticket_id];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonSendMessage = [[UIBarButtonItem alloc] initWithTitle:@"Envoyer un message"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(buttonSendMessageActionListener)];
    
    [buttonSendMessage setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    [self.navigationController.toolbar setItems:@[ flexibleSpace, buttonSendMessage, flexibleSpace ]];
    
    [super viewDidAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.administrationArray)
    {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)
    {
        return self.elementArray.count;
    }
    else if (section == 2)
    {
        return self.administrationArray.count;
    }
    
    return self.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Informations générales";
    }
    else if (section == 2)
    {
        return @"Administration";
    }
    
    return @"Messages";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        SpecificTableViewCellWithoutImage *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWithoutImage" forIndexPath:indexPath];
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.textLabel.numberOfLines = 0;
        
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        
        [cell.textLabel setText:self.administrationArray[indexPath.row]];
        
        return cell;
    }
    
    if (indexPath.section == 0)
    {
        SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.textLabel.numberOfLines = 0;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setText:self.elementArray[indexPath.row]];
        
        [cell.imageView setImage:[UIImage imageNamed:self.imageArray[indexPath.row]]];
        
        return cell;
    }
    
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMessage" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 5.0f, 2 * self.view.frame.size.width / 3, cell.frame.size.height - 10.0f)];
    
    [textView setTextAlignment:NSTextAlignmentCenter];
    
    [textView setFont:[UIFont fontWithName:textView.font.fontName size:15.0]];
    
    [textView setTextColor:[UIColor blackColor]];
    
    [textView setEditable:NO];
    
    Message *message = self.messageArray[indexPath.row];
    
    [textView setValue:message.message forKey:@"contentToHTMLString"];
    
    if (message.author_id == self.ticketSelected.createur.user_id)
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_AUTEUR_TICKET", @"ICON_NAME_AUTEUR_TICKET")]];
    }
    else
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_AIR_MEMBER", @"ICON_NAME_AIR_MEMBER")]];
    }
    
    [cell addSubview:textView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.activityIndicatorView isAnimating] || indexPath.section != 2)
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    if ([self.administrationArray[indexPath.row] isEqualToString:@"Changer le status"])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choisissez un status" delegate:self cancelButtonTitle:@"annuler" destructiveButtonTitle:nil otherButtonTitles:@"ouvert", @"affecté", @"commentaire", @"fermé", nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [actionSheet showFromToolbar:self.navigationController.toolbar];
        }
        else
        {
            [actionSheet showInView:self.view];
        }
    }
    else if ([self.administrationArray[indexPath.row] isEqualToString:@"S'affecter le ticket"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Êtes-vous sûr de vouloir vous affecter ce ticket ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
        
        self.affectation = YES;
        
        [alertView show];
    }
    else if ([self.administrationArray[indexPath.row] isEqualToString:@"Se désaffecter le ticket"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Êtes-vous sûr de vouloir vous affecter ce ticket ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
        
        self.desaffectation = YES;
        
        [alertView show];
    }
    
    [self.activityIndicatorView stopAnimating];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Annuler"])
    {
        [self.activityIndicatorView startAnimating];
        
        self.ticketSelected.status = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        self.changementStatus = YES;
        
        [self._ticketModel changerStatusTicket:self.ticketSelected.ticket_id status:[actionSheet buttonTitleAtIndex:buttonIndex]];
    }
}

@end
