//
//  AssociationView.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 17/06/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

// Détails d'une association (descriptif + membres) ou d'un évènement ou d'un partenaire

#import "AssociationView.h"
#import "ListeParticipantsView.h"

#import "Evenement.h"
#import "Membre.h"

#import "SpecificTableViewCell.h"
#import "SpecificTableViewCellWithWebView.h"

@interface AssociationView () <UIAlertViewDelegate>

@property(nonatomic, strong) NSMutableArray *titleSectionArray;

@property(nonatomic, strong) NSMutableArray *titleElementArray;

@property(nonatomic, strong) NSMutableArray *elementArray;

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) EvenementModel *_evenementModel;

@property(nonatomic, strong) Evenement *evenementSelected;

@end

@implementation AssociationView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious;
    
    if ([self.sousMenuChoisi isEqualToString:@"Partenaires"]) {
        [self.navigationItem setTitle:self.partenaireChoisi.nom];
        buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:self.partenaireChoisi.nom style:UIBarButtonItemStyleDone target:nil action:nil];
        [self initViewPartenaires];
    }
    else if ([self.sousMenuChoisi isEqualToString:@"L'association"]) {
        [self.navigationItem setTitle:self.associationChoisie.nom];
        buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:self.associationChoisie.nom style:UIBarButtonItemStyleDone target:nil action:nil];
        [self initViewAssociation];
    }
    else if ([self.sousMenuChoisi isEqualToString:@"Evènements"]) {
        [self.navigationItem setTitle:@"Evènement"];
        buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Evènement" style:UIBarButtonItemStyleDone target:nil action:nil];
        [self initViewEvenements];
    }
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
    
}

// Initialisation pour afficher les détails d'un évènement
- (void) initViewEvenements
{
    self.titleSectionArray = [[NSMutableArray alloc] init];
    
    self.titleElementArray = [[NSMutableArray alloc] init];
    
    self.elementArray = [[NSMutableArray alloc] init];
    
    for (int i=0;i<self.data.count;i++)
    {
        Evenement *unEvenement = [self.data objectAtIndex:i];
        
        [self.titleSectionArray addObject:@""];
        
        if (unEvenement.dejaInscrit)
        {
            [self.elementArray addObject:[[NSArray alloc] initWithObjects:unEvenement.title, unEvenement.start, unEvenement.end, unEvenement.lieu,unEvenement.descrip, @"Liste des participants", @"Se désinscription à cet évènement", nil]];
            
            [self.titleElementArray addObject:[[NSArray alloc] initWithObjects:@"Titre", @"Début", @"Fin", @"Lieu", @"Description", @"Participants", @"Désinscription", nil]];
        }
        else
        {
            [self.elementArray addObject:[[NSArray alloc] initWithObjects:unEvenement.title, unEvenement.start, unEvenement.end, unEvenement.lieu,unEvenement.descrip, @"Liste des participants", @"S'inscrire à cet évènement", nil]];
            
            [self.titleElementArray addObject:[[NSArray alloc] initWithObjects:@"Titre", @"Début", @"Fin", @"Lieu", @"Description", @"Participants", @"Inscription", nil]];
        }
    }
}

// Initialisation pour afficher les détails d'une association
- (void) initViewAssociation
{
    self.titleSectionArray = [[NSMutableArray alloc] init];
    
    self.titleElementArray = [[NSMutableArray alloc] init];
    
    self.elementArray = [[NSMutableArray alloc] init];
    
    [self.titleSectionArray addObject:self.associationChoisie.nom];
    
    [self.elementArray addObject:[[NSArray alloc] initWithObjects:self.associationChoisie.type, self.associationChoisie.site, self.associationChoisie.alias, self.associationChoisie.descrip, nil]];
    
    [self.titleElementArray addObject:[[NSArray alloc] initWithObjects:@"Type", @"Site web", @"Alias", @"Description", nil]];
    
    for (int i=0;i<self.dataMembres.count;i++)
    {
        Membre *membre = self.dataMembres[i];
        
        [self.titleSectionArray addObject:[[membre.prenom stringByAppendingString:@" "] stringByAppendingString:membre.nom]];
        
        [self.elementArray addObject:[[NSArray alloc] initWithObjects:membre.role, membre.email, membre.residence, membre.chambre, membre.telephone, nil]];
        
        [self.titleElementArray addObject:[[NSArray alloc] initWithObjects:@"Rôle", @"Email", @"Résidence", @"Chambre", @"Téléphone", nil]];
    }
}

// Initialisation pour afficher les détails d'un partenaire
- (void) initViewPartenaires
{
    self.titleSectionArray = [[NSMutableArray alloc] init];
    
    self.titleElementArray = [[NSMutableArray alloc] init];
    
    self.elementArray = [[NSMutableArray alloc] init];
    
    [self.titleSectionArray addObject:@""];
    
    [self.titleElementArray addObject:[[NSArray alloc] initWithObjects:@"Nom", @"Adresse", @"Téléphone",@"Site web", @"Offre", nil]];
    
    [self.elementArray addObject:[[NSArray alloc] initWithObjects:self.partenaireChoisi.nom, self.partenaireChoisi.adresse, self.partenaireChoisi.telephone, self.partenaireChoisi.siteweb, self.partenaireChoisi.offre, nil]];
}

- (void) setImageCell:(SpecificTableViewCell *)cell title:(NSString*)title
{
    NSString *imageName = @"";
    
    if ([title isEqualToString:@"Nom"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_USER", @"ICON_NAME_USER");
    }
    else if ([title isEqualToString:@"Adresse"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_ADRESS", @"ICON_NAME_ADRESS");
    }
    else if ([title isEqualToString:@"Téléphone"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_PHONE", @"ICON_NAME_PHONE");
    }
    else if ([title isEqualToString:@"Site web"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_WEB", @"ICON_NAME_WEB");
    }
    else if ([title isEqualToString:@"Offre"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_OFFRE", @"ICON_NAME_OFFRE");
    }
    else if ([title isEqualToString:@"Type"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_TYPE", @"ICON_NAME_TYPE");
    }
    else if ([title isEqualToString:@"Alias"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_ALIAS", @"ICON_NAME_ALIAS");
    }
    else if ([title isEqualToString:@"Description"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_DESCRIPTION", @"ICON_NAME_DESCRIPTION");
    }
    else if ([title isEqualToString:@"Rôle"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_ROLE", @"ICON_NAME_ROLE");
    }
    else if ([title isEqualToString:@"Chambre"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_ROOM", @"ICON_NAME_ROOM");
    }
    else if ([title isEqualToString:@"Début"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_BEGIN", @"ICON_NAME_BEGIN");
    }
    else if ([title isEqualToString:@"Fin"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_END", @"ICON_NAME_END");
    }
    else if ([title isEqualToString:@"Email"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_EMAIL", @"ICON_NAME_EMAIL");
    }
    else if ([title isEqualToString:@"Lieu"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_LIEU", @"ICON_NAME_LIEU");
    }
    else if ([title isEqualToString:@"Résidence"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_RESIDENCE", @"ICON_NAME_RESIDENCE");
    }
    else if ([title isEqualToString:@"Inscription"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_INSCRIPTION", @"ICON_NAME_INSCRIPTION");
    }
    else if ([title isEqualToString:@"Désinscription"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_DESINSCRIPTION", @"ICON_NAME_DESINSCRIPTION");
    }
    else if ([title isEqualToString:@"Participants"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_PROMOTION", @"ICON_NAME_PROMOTION");
    }
    
    if (![imageName isEqualToString:@""])
    {
        [cell.imageView setImage:[UIImage imageNamed:imageName]];
    
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"InscriptionCell"];
    
    [self.tableView registerClass:[SpecificTableViewCellWithWebView class] forCellReuseIdentifier:@"cellWebView"];
    
    [self initialisationView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.titleSectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.elementArray objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.titleSectionArray objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrayTitleElement = [self.titleElementArray objectAtIndex:indexPath.section];
    
    NSArray *arrayElement = [self.elementArray objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0 && [self.imagesArray[indexPath.section] isKindOfClass:[NSString class]])
    {
        SpecificTableViewCellWithWebView *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellWebView" forIndexPath:indexPath];
        
        [cell addWebViewAndImage:self.imagesArray[indexPath.section]];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 5.0f, 2 * self.view.frame.size.width / 3, cell.frame.size.height - 10.0f)];
        
        [textView setTextAlignment:NSTextAlignmentCenter];
        
        [textView setFont:[UIFont fontWithName:textView.font.fontName size:15.0]];
        
        [textView setTextColor:[UIColor blackColor]];
        
        [textView setEditable:NO];
        
        [textView setText:arrayElement[indexPath.row]];
        
        [cell addSubview:textView];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if ([[arrayTitleElement objectAtIndex:indexPath.row] isEqualToString:@"Inscription"] || [[arrayTitleElement objectAtIndex:indexPath.row] isEqualToString:@"Désinscription"] || [[arrayTitleElement objectAtIndex:indexPath.row] isEqualToString:@"Participants"])
    {
        SpecificTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"InscriptionCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.textLabel.numberOfLines = 0;
        
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        
        [cell.textLabel setText:arrayElement[indexPath.row]];
        
        [self setImageCell:cell title:arrayTitleElement[indexPath.row]];
        
        return cell;
    }
    
    SpecificTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 5.0f, 2 * self.view.frame.size.width / 3, cell.frame.size.height - 10.0f)];
    
    if (indexPath.row != 0 || [self.imagesArray[indexPath.section] isEqual:[NSNull null]] || [self.imagesArray[indexPath.section] isKindOfClass:[NSString class]])
    {
        [self setImageCell:cell title:[arrayTitleElement objectAtIndex:indexPath.row]];
    }
    else
    {
        [cell.imageView setImage:self.imagesArray[indexPath.section]];
    }
    
    if ([[arrayElement objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]] || [[arrayElement objectAtIndex:indexPath.row] isEqualToString:@""])
    {
        [textView setText:NSLocalizedString(@"TEXT_NO_DATA", @"TEXT_NO_DATA")];
    }
    else
    {
        if ([[arrayTitleElement objectAtIndex:indexPath.row] isEqualToString:@"Description"] || [[arrayTitleElement objectAtIndex:indexPath.row] isEqualToString:@"Offre"])
        {
            [textView setValue:[arrayElement objectAtIndex:indexPath.row] forKey:@"contentToHTMLString"];
        }
        else if ([[arrayTitleElement objectAtIndex:indexPath.row] isEqualToString:@"Début"] || [[arrayTitleElement objectAtIndex:indexPath.row] isEqualToString:@"Fin"])
        {
            NSString *jour = [[arrayElement objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(8, 2)];
            
            NSString *mois = [[arrayElement objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(5, 2)];
            
            NSString *annee = [[arrayElement objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(0, 4)];
            
            NSString *heure = [[arrayElement objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(11, 2)];
            
            NSString *minute = [[arrayElement objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(14, 2)];
            
            [textView setText:[NSString stringWithFormat:@"Le %@/%@/%@ à %@h%@", jour, mois, annee, heure, minute]];
        }
        else
        {
            [textView setText:[arrayElement objectAtIndex:indexPath.row]];
        }
        
        if ([[arrayTitleElement objectAtIndex:indexPath.row] isEqualToString:@"Adresse"])
        {
            textView.dataDetectorTypes = UIDataDetectorTypeAddress;
        }
        else if ([[arrayTitleElement objectAtIndex:indexPath.row] isEqualToString:@"Téléphone"])
        {
            textView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
        }
        else if ([[arrayTitleElement objectAtIndex:indexPath.row] isEqualToString:@"Site web"])
        {
            textView.dataDetectorTypes = UIDataDetectorTypeLink;
        }
    }
    
    if (![[arrayTitleElement objectAtIndex:indexPath.row] isEqualToString:@"Description"] && ![[arrayTitleElement objectAtIndex:indexPath.row] isEqualToString:@"Offre"])
    {
        [textView setTextAlignment:NSTextAlignmentCenter];
        [textView setFont:[UIFont fontWithName:textView.font.fontName size:15.0]];
    }
    
    [textView setTextColor:[UIColor blackColor]];
    [textView setEditable:NO];
    
    [cell addSubview:textView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrayTitleElement = [self.titleElementArray objectAtIndex:indexPath.section];
    
    if ([self.activityIndicatorView isAnimating] || (![arrayTitleElement[indexPath.row] isEqualToString:@"Inscription"] && ![arrayTitleElement[indexPath.row] isEqualToString:@"Désinscription"] && ![arrayTitleElement[indexPath.row] isEqualToString:@"Participants"]))
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    self.evenementSelected = [self.data objectAtIndex:indexPath.section];
    
    if ([arrayTitleElement[indexPath.row] isEqualToString:@"Participants"])
    {
        ListeParticipantsView *listeParticipantsView = [[ListeParticipantsView alloc] initWithStyle:UITableViewStylePlain];
        
        listeParticipantsView.afficherImage = self.afficherImage;
        
        listeParticipantsView.evenementSelected = self.evenementSelected;
        
        listeParticipantsView.API_url = self.API_url;
        
        [self.navigationController pushViewController:listeParticipantsView animated:YES];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    
    UIAlertView *alertView;
    
    if (!self.evenementSelected.dejaInscrit)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"Inscription" message:[@"Êtes-vous sûr de vouloir vous inscrire à l'évènement : " stringByAppendingString:self.evenementSelected.title] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"Désinscription" message:[@"Êtes-vous sûr de vouloir vous désinscrire à l'évènement : " stringByAppendingString:self.evenementSelected.title] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
    }
    
    [alertView show];
    
    [self.activityIndicatorView stopAnimating];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Oui"] && !self.evenementSelected.dejaInscrit)
    {
        [self inscriptionEvenement];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Oui"] && self.evenementSelected.dejaInscrit)
    {
        [self desinscriptionEvenement];
    }
}

- (void) inscriptionEvenement
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._evenementModel)
    {
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        self._evenementModel = [[EvenementModel alloc] init];
        
        self._evenementModel.API_url = self.API_url;
        
        self._evenementModel.delegate = self;
    }
    [self._evenementModel inscriptionEvenementWithId:self.evenementSelected.evenement_id];
}

- (void) desinscriptionEvenement
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._evenementModel)
    {
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        self._evenementModel = [[EvenementModel alloc] init];
        
        self._evenementModel.API_url = self.API_url;
        
        self._evenementModel.delegate = self;
    }
    [self._evenementModel desinscriptionEvenementWithId:self.evenementSelected.evenement_id];
}

- (void) evenementsDownloaded:(NSArray *)items
{
    UIAlertView *alertView;
    
    if (!self.evenementSelected.dejaInscrit)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"Inscription" message:[@"Vous êtes maintenant inscrit à l'évènement : " stringByAppendingString:self.evenementSelected.title] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        self.evenementSelected.dejaInscrit = YES;
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"Désinscription" message:[@"Vous êtes maintenant désinscrit à l'évènement : " stringByAppendingString:self.evenementSelected.title] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        self.evenementSelected.dejaInscrit = NO;
    }
    
    [alertView show];
    
    [self initViewEvenements];
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

@end
