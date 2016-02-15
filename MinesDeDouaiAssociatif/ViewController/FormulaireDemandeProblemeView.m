//
//  FormulaireDemandeProblemeView.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 01/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "FormulaireDemandeProblemeView.h"

#import "SpecificTableViewCell.h"

@interface FormulaireDemandeProblemeView () <UIAlertViewDelegate, UIActionSheetDelegate>

@property(nonatomic, strong) TicketModel *_ticketModel;

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSMutableDictionary *ticketDictionary;

@property(nonatomic, strong) NSMutableArray *elementsArray;

@property(nonatomic) BOOL keyboardHidden;

@property(nonatomic, strong) NSString *referenceActionSheet;

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UILabel *typeLabel;

@property(nonatomic, strong) UILabel *objetLabel;

@property(nonatomic, strong) UILabel *typeHebergementLabel;

@property(nonatomic, strong) UILabel *nomProjetLabel;

@property(nonatomic, strong) UILabel *typeDepotLabel;

@property(nonatomic, strong) UILabel *creerBDDLabel;

@property(nonatomic, strong) UILabel *emailLabel;

@property(nonatomic, strong) UILabel *typeConnexionLabel;

@property(nonatomic, strong) UILabel *dateInterruptionConnexionLabel;

@property(nonatomic, strong) UILabel *typeMaterielLabel;

@property(nonatomic, strong) UILabel *logicielsInstalledLabel;

@property(nonatomic, strong) UILabel *tutoSuiviLabel;

@property(nonatomic, strong) UILabel *detecteReseauLabel;

@property(nonatomic, strong) UILabel *detecteReseauVoisinLabel;

@property(nonatomic, strong) UILabel *nouveauNomAssociationLabel;

@property(nonatomic, strong) UILabel *presidentLabel;

@property(nonatomic, strong) UILabel *adresseLabel;

@property(nonatomic, strong) UILabel *resetLabel;

@property(nonatomic, strong) UILabel *autreChambreLabel;

@property(nonatomic, strong) UITextView *removeAdressesTextView;

@property(nonatomic, strong) UITextView *addAdressesTextView;

@property(nonatomic, strong) UITextView *listeChambreTextView;

@property(nonatomic, strong) UITextView *descriptionTextView;

@property(nonatomic, strong) NSString *reference;

@end

@implementation FormulaireDemandeProblemeView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:@"Demande et problème"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Demande et problème" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) creerTicket:(NSDictionary*)dictionnary
{
    if (!self._ticketModel)
    {
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        self._ticketModel = [[TicketModel alloc] init];
        
        self._ticketModel.API_url = self.API_url;
        
        self._ticketModel.delegate = self;
    }
    [self._ticketModel createTicket:dictionnary];
}

- (void) ticketDone:(NSArray *)items
{
    [self.activityIndicatorView stopAnimating];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Votre demande a bien été enregistrée." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
    
    [self.navigationController popToViewController:self.ticketMenuView animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cellTitleAndType"];
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cellTextView"];
    
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self initialisationView];
    
    self.descriptionTextView = [[UITextView alloc] init];
    
    [self.descriptionTextView setText:@"description..."];
    
    self.addAdressesTextView = [[UITextView alloc] init];
    
    [self.addAdressesTextView setText:@"adresses email à ajouter..."];
    
    self.listeChambreTextView = [[UITextView alloc] init];
    
    [self.listeChambreTextView setText:@"liste des chambres..."];
    
    self.removeAdressesTextView = [[UITextView alloc] init];
    
    [self.removeAdressesTextView setText:@"adresses email à supprimer..."];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    self.keyboardHidden = YES;
    
    self.ticketDictionary = [[NSMutableDictionary alloc] init];
    
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
    
    UIBarButtonItem *buttonSend = [[UIBarButtonItem alloc] initWithTitle:@"Envoyer la demande"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(buttonSendActionListener)];
    
    [buttonSend setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    [self.navigationController.toolbar setItems:@[ flexibleSpace, buttonSend, flexibleSpace ]];
    
    [super viewDidAppear:animated];
}

- (void) buttonSendActionListener
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    if (![self.ticketDictionary objectForKey:@"title"])
    {
        [alertView setMessage:@"Champ titre incorrect : Veuillez donner un titre à votre demande"];
        
        [alertView show];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    
    else if (![self.ticketDictionary objectForKey:@"type"])
    {
        [alertView setMessage:@"Champ type incorrect : Veuillez sélectionner un type de demande"];
        
        [alertView show];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    
    else if ([[self.ticketDictionary objectForKey:@"type"] isEqualToString:@"Site des élèves"])
    {
        if (![self.ticketDictionary objectForKey:@"objet"])
        {
            [alertView setMessage:@"Champ objet incorrect : Veuillez sélectionner un objet pour votre demande"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if ([self.descriptionTextView.text isEqualToString:@""] || [self.descriptionTextView.text isEqualToString:@"description..."])
        {
            [alertView setMessage:@"Champ description incorrect : Veuillez rentrer une description pour votre demande"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if ([[self.ticketDictionary objectForKey:@"objet"] isEqualToString:@"createAssociation"])
        {
            if (![self.ticketDictionary objectForKey:@"newNomAssociation"])
            {
                [alertView setMessage:@"champ nom de l'association incorrect : Veuillez rentrer le nom de l'association"];
                
                [alertView show];
                
                [self.activityIndicatorView stopAnimating];
                
                return;
            }
            
            else if (![self.ticketDictionary objectForKey:@"president"])
            {
                [alertView setMessage:@"Champ président incorrect : Veuillez rentrer le prénom et nom du président"];
                
                [alertView show];
                
                [self.activityIndicatorView stopAnimating];
                
                return;
            }
        }
        
        [self.ticketDictionary setObject:self.descriptionTextView.text forKey:@"description"];
    }
    
    else if ([[self.ticketDictionary objectForKey:@"type"] isEqualToString:@"Alias"])
    {
        if (![self.ticketDictionary objectForKey:@"objet"])
        {
            [alertView setMessage:@"Champ objet incorrect : Veuillez sélectionner un objet pour votre demande"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"adresse"])
        {
            [alertView setMessage:@"Champ adresse incorrect : Veuillez rentrer l'adresse email de l'alias"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if ([[self.ticketDictionary objectForKey:@"objet"] isEqualToString:@"create"])
        {
            if ([self.descriptionTextView.text isEqualToString:@""] || [self.descriptionTextView.text isEqualToString:@"description..."])
            {
                [alertView setMessage:@"Champ description incorrect : Veuillez sélectionner un objet pour votre demande"];
                
                [alertView show];
                
                [self.activityIndicatorView stopAnimating];
                
                return;
            }
            
            else if ([self.addAdressesTextView.text isEqualToString:@""] || [self.addAdressesTextView.text isEqualToString:@"adresses email à ajouter..."])
            {
                [alertView setMessage:@"Champ adresse à ajouter incorrect : Veuillez rentrer des adresses email qui seront dans l'alias"];
                
                [alertView show];
                
                [self.activityIndicatorView stopAnimating];
                
                return;
            }
            
            [self.ticketDictionary setObject:self.addAdressesTextView.text forKey:@"addAdresses"];
            
            [self.ticketDictionary setObject:self.descriptionTextView.text forKey:@"description"];
        }
        
        else if ([[self.ticketDictionary objectForKey:@"objet"] isEqualToString:@"update"])
        {
            if ([self.addAdressesTextView.text isEqualToString:@""] || [self.addAdressesTextView.text isEqualToString:@"adresses email à ajouter..."])
            {
                [self.addAdressesTextView setText:@"Aucune adresse à ajouter"];
            }
            
            else if ([self.removeAdressesTextView.text isEqualToString:@""] || [self.removeAdressesTextView.text isEqualToString:@"adresses email à supprimer..."])
            {
                [self.removeAdressesTextView setText:@"Aucune adresse à supprimer"];
            }
            
            if (![self.ticketDictionary objectForKey:@"reset"])
            {
                [self.ticketDictionary setObject:@"Non" forKey:@"reset"];
            }
            
            [self.ticketDictionary setObject:self.addAdressesTextView.text forKey:@"addAdresses"];
            
            [self.ticketDictionary setObject:self.removeAdressesTextView.text forKey:@"removeAdresses"];
        }
    }
    
    else if ([[self.ticketDictionary objectForKey:@"type"] isEqualToString:@"Hébergement"])
    {
        if (![self.ticketDictionary objectForKey:@"typeHebergement"])
        {
            [alertView setMessage:@"Champ type d'hébergement incorrect : Veuillez indiquer le type d'hébergement que vous souhaitez"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"nomProjet"])
        {
            [alertView setMessage:@"Champ nom du projet incorrect : Veuillez rentrer le nom de votre projet"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if ([self.descriptionTextView.text isEqualToString:@""] || [self.descriptionTextView.text isEqualToString:@"description..."])
        {
            [alertView setMessage:@"Champ description incorrect : Veuillez rentrer une description à votre demande"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"typeDepot"])
        {
            [alertView setMessage:@"Champ type de dépôt incorrect : Veuillez indiquer le type de dépôt que vous souhaitez"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"creerBDD"])
        {
            [self.ticketDictionary setObject:@"Non" forKey:@"creerBDD"];
        }
        
        [self.ticketDictionary setObject:self.descriptionTextView.text forKey:@"description"];
    }
    
    else if ([[self.ticketDictionary objectForKey:@"type"] isEqualToString:@"Autre"])
    {
        if ([self.descriptionTextView.text isEqualToString:@""] || [self.descriptionTextView.text isEqualToString:@"description..."])
        {
            [alertView setMessage:@"Champ description incorrect : Veuillez rentrer une description pour votre demande"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        [self.ticketDictionary setObject:self.descriptionTextView.text forKey:@"description"];
    }
    
    else if ([[self.ticketDictionary objectForKey:@"type"] isEqualToString:@"Mot de passe"])
    {
        if ([self.descriptionTextView.text isEqualToString:@""] || [self.descriptionTextView.text isEqualToString:@"description..."])
        {
            [alertView setMessage:@"Champ description incorrect : Veuillez rentrer une description pour votre demande"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"email"])
        {
            [alertView setMessage:@"Champ email incorrect : Veuillez saisir votre adresse email"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        [self.ticketDictionary setObject:self.descriptionTextView.text forKey:@"description"];
    }
    
    else if ([[self.ticketDictionary objectForKey:@"type"] isEqualToString:@"Problème technique"])
    {
        if ([self.descriptionTextView.text isEqualToString:@""] || [self.descriptionTextView.text isEqualToString:@"description..."])
        {
            [alertView setMessage:@"Champ description incorrect : Veuillez rentrer une description pour votre demande"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        [self.ticketDictionary setObject:self.descriptionTextView.text forKey:@"description"];
    }
    
    else if ([[self.ticketDictionary objectForKey:@"type"] isEqualToString:@"Problème réseau"])
    {
        if ([self.descriptionTextView.text isEqualToString:@""] || [self.descriptionTextView.text isEqualToString:@"description..."])
        {
            [alertView setMessage:@"Champ description incorrect : Veuillez rentrer une description pour votre demande"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if ([self.listeChambreTextView.text isEqualToString:@""] || [self.listeChambreTextView.text isEqualToString:@"liste des chambres..."])
        {
            [alertView setMessage:@"Champ liste des chambres incorrect : Veuillez rentrer la ou les chambres souffrant de ce problème de connexion"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"typeConnexion"])
        {
            [alertView setMessage:@"Champ type de connexion incorrect : Veuillez saisir le type de connexion utilisé"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"dateInterruptionConnexion"])
        {
            [alertView setMessage:@"Champ date d'interruption de connexion incorrect : Veuillez saisir la date depuis laquelle vous avez ce problème de connexion"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"typeMateriel"])
        {
            [alertView setMessage:@"Champ type de matériel incorrect : Veuillez saisi le type de matériel utilisé"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"logicielsInstalled"])
        {
            [alertView setMessage:@"Champ logiciel installé incorrect : Veuillez indiquer si vous utilisez le logiciel de connexion"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"tutoSuivi"])
        {
            [alertView setMessage:@"Champ tutoriel suivi incorrect : Veuillez indiquer si vous avez suivi le tutoriel de connexion"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"detecteReseau"])
        {
            [alertView setMessage:@"Champ détection du réseau incorrect : Veuillez indiquer si vous détectez le réseau"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"detecteReseauVoisin"])
        {
            [alertView setMessage:@"Champ détection de réseaux voisins incorrect : Veuillez indiquer si vous détectez des réseaux voisins"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        else if (![self.ticketDictionary objectForKey:@"autreChambre"])
        {
            [alertView setMessage:@"Champ autre chambre incorrect : Veuillez indiquer si d'autres chambres souffrent du même problème"];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        [self.ticketDictionary setObject:self.descriptionTextView.text forKey:@"description"];
        [self.ticketDictionary setObject:self.listeChambreTextView.text forKey:@"listeChambres"];
    }
    
    [self creerTicket:self.ticketDictionary];
}

- (void) keyboardDidShow
{
    self.keyboardHidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2 + self.elementsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2 )
    {
        SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTitleAndType" forIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.textLabel.numberOfLines = 0;
        
        if (indexPath.row == 0)
        {
            [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_TITLE", @"ICON_NAME_TITLE")]];
            
            if (!self.titleLabel)
            {
                [cell.textLabel setText:@"Titre de la demande : Rentrer un titre pour votre demande"];
            }
            else
            {
                [cell.textLabel setText:self.titleLabel.text];
            }
            self.titleLabel = cell.textLabel;
        }
        
        else if (indexPath.row == 1)
        {
            [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_TITLE", @"ICON_NAME_TITLE")]];
            
            if (!self.typeLabel)
            {
                [cell.textLabel setText:@"Type : Sélectionner un type de demande"];
            }
            else
            {
                [cell.textLabel setText:self.typeLabel.text];
            }
            self.typeLabel = cell.textLabel;
        }
        
        return cell;
    }
    
    else if (![[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"description"] && ![[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"listeChambre"] && ![[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"addAdresses"] && ![[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"removeAdresses"])
    {
    
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.numberOfLines = 0;
    
    if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"objet"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_DESCRIPTION", @"ICON_NAME_DESCRIPTION")]];
        
        if (!self.objetLabel)
        {
            [cell.textLabel setText:@"Objet : Sélectionner un objet"];
        }
        else
        {
            [cell.textLabel setText:self.objetLabel.text];
        }
        self.objetLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"typeHebergement"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_WEB", @"ICON_NAME_WEB")]];
        
        if (!self.typeHebergementLabel)
        {
            [cell.textLabel setText:@"Hébergement : Sélectionner un type d'hébergement"];
        }
        else
        {
            [cell.textLabel setText:self.typeHebergementLabel.text];
        }
        self.typeHebergementLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"nomProjet"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ASSOCIATION", @"ICON_NAME_ASSOCIATION")]];
        
        if (!self.nomProjetLabel)
        {
            [cell.textLabel setText:@"Nom du projet : Entrer le nom du projet"];
        }
        else
        {
            [cell.textLabel setText:self.nomProjetLabel.text];
        }
        self.nomProjetLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"typeDepot"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_WEB", @"ICON_NAME_WEB")]];
        
        if (!self.typeDepotLabel)
        {
            [cell.textLabel setText:@"Type de dépôt : Sélectionner un type de dépôt"];
        }
        else
        {
            [cell.textLabel setText:self.typeDepotLabel.text];
        }
        self.typeDepotLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"creerBDD"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_BDD", @"ICON_NAME_BDD")]];
        
        if (!self.creerBDDLabel)
        {
            [cell.textLabel setText:@"Voulez-vous créer une base de données ?"];
        }
        else
        {
            [cell.textLabel setText:self.creerBDDLabel.text];
        }
        self.creerBDDLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"email"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_EMAIL", @"ICON_NAME_EMAIL")]];
        
        if (!self.emailLabel)
        {
            [cell.textLabel setText:@"Email : Rentrer votre email"];
        }
        else
        {
            [cell.textLabel setText:self.emailLabel.text];
        }
        self.emailLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"typeConnexion"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"iconTypeConnexion.png", @"iconTypeConnexion.png")]];
        
        if (!self.typeConnexionLabel)
        {
            [cell.textLabel setText:@"Type de connexion : Indiquer votre moyen de connexion"];
        }
        else
        {
            [cell.textLabel setText:self.typeConnexionLabel.text];
        }
        self.typeConnexionLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"dateInterruptionConnexion"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_CALENDAR", @"ICON_NAME_CALENDAR")]];
        
        if (!self.dateInterruptionConnexionLabel)
        {
            [cell.textLabel setText:@"Date d'interruption de la connexion : Rentrer une date"];
        }
        else
        {
            [cell.textLabel setText:self.dateInterruptionConnexionLabel.text];
        }
        self.dateInterruptionConnexionLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"typeMateriel"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_MATERIEL", @"ICON_NAME_MATERIEL")]];
        
        if (!self.typeMaterielLabel)
        {
            [cell.textLabel setText:@"Matériel utilisé : Indiquer le matériel utilisé"];
        }
        else
        {
            [cell.textLabel setText:self.typeMaterielLabel.text];
        }
        self.typeMaterielLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"logicielsInstalled"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"iconLogiciel.png", @"iconLogiciel.png")]];
        
        if (!self.logicielsInstalledLabel)
        {
            [cell.textLabel setText:@"Avez-vous installé le logiciel de connexion ?"];
        }
        else
        {
            [cell.textLabel setText:self.logicielsInstalledLabel.text];
        }
        self.logicielsInstalledLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"tutoSuivi"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"iconTuto.png", @"iconTuto.png")]];
        
        if (!self.tutoSuiviLabel)
        {
            [cell.textLabel setText:@"Avez-vous suivi le tuto ?"];
        }
        else
        {
            [cell.textLabel setText:self.tutoSuiviLabel.text];
        }
        self.tutoSuiviLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"detecteReseau"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_DETECTION_RESEAU", @"ICON_NAME_DETECTION_RESEAU")]];
        
        if (!self.detecteReseauLabel)
        {
            [cell.textLabel setText:@"Détectez-vous le réseau ?"];
        }
        else
        {
            [cell.textLabel setText:self.detecteReseauLabel.text];
        }
        self.detecteReseauLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"detecteReseauVoisin"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_DETECTION_RESEAU", @"ICON_NAME_DETECTION_RESEAU")]];
        
        if (!self.detecteReseauVoisinLabel)
        {
            [cell.textLabel setText:@"Détectez-vous un réseau voisin ?"];
        }
        else
        {
            [cell.textLabel setText:self.detecteReseauVoisinLabel.text];
        }
        self.detecteReseauVoisinLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"newNomAssociation"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ASSOCIATION", @"ICON_NAME_ASSOCIATION")]];
        
        if (!self.nouveauNomAssociationLabel)
        {
            [cell.textLabel setText:@"Nom de l'association : Entrer le nom de l'association"];
        }
        else
        {
            [cell.textLabel setText:self.nouveauNomAssociationLabel.text];
        }
        self.nouveauNomAssociationLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"president"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ROLE", @"ICON_NAME_ROLE")]];
        
        if (!self.presidentLabel)
        {
            [cell.textLabel setText:@"Président : Entrer le Prénom et le Nom du président"];
        }
        else
        {
            [cell.textLabel setText:self.presidentLabel.text];
        }
        self.presidentLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"adresse"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_EMAIL", @"ICON_NAME_EMAIL")]];
        
        if (!self.adresseLabel)
        {
            [cell.textLabel setText:@"Adresse email : Rentrer l'adresse email"];
        }
        else
        {
            [cell.textLabel setText:self.adresseLabel.text];
        }
        self.adresseLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"reset"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_RESET", @"ICON_NAME_RESET")]];
        
        if (!self.resetLabel)
        {
            [cell.textLabel setText:@"Voulez-vous reset l'alias ?"];
        }
        else
        {
            [cell.textLabel setText:self.resetLabel.text];
        }
        self.resetLabel = cell.textLabel;
    }
    
    else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"autreChambre"])
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ROOM", @"ICON_NAME_ROOM")]];
        
        if (!self.autreChambreLabel)
        {
            [cell.textLabel setText:@"Ce problème de réseau impacte t-il plusieurs chambres ?"];
        }
        else
        {
            [cell.textLabel setText:self.autreChambreLabel.text];
        }
        self.autreChambreLabel = cell.textLabel;
    }
        
    return cell;
    }
    
    else
    {
        SpecificTableViewCell *cellTextView = [tableView dequeueReusableCellWithIdentifier:@"cellTextView" forIndexPath:indexPath];
        
        cellTextView.accessoryType = UITableViewCellAccessoryNone;
        
        cellTextView.selectionStyle = UITableViewCellSelectionStyleNone;
    
        if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"description"])
        {
            [cellTextView.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_TEXT", @"ICON_NAME_TEXT")]];
            
            [self.descriptionTextView setFrame:CGRectMake(2 * cellTextView.frame.size.width / 5, 10.0f, 3 * cellTextView.frame.size.width / 5, cellTextView.frame.size.height - 20.0f)];
            
            [self.descriptionTextView setFont:[UIFont systemFontOfSize:16]];
            
            [cellTextView addSubview:self.descriptionTextView];
        }
        
        else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"listeChambre"])
        {
            [cellTextView.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ROOM", @"ICON_NAME_ROOM")]];
            
            [self.listeChambreTextView setFrame:CGRectMake(2 * cellTextView.frame.size.width / 5, 10.0f, 3 * cellTextView.frame.size.width / 5, cellTextView.frame.size.height - 20.0f)];
            
            [self.listeChambreTextView setFont:[UIFont systemFontOfSize:16]];
            
            [cellTextView addSubview:self.listeChambreTextView];
        }
        
        else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"addAdresses"])
        {
            [cellTextView.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ADD", @"ICON_NAME_ADD")]];
            
            [self.addAdressesTextView setFrame:CGRectMake(2 * cellTextView.frame.size.width / 5, 10.0f, 3 * cellTextView.frame.size.width / 5, cellTextView.frame.size.height - 20.0f)];
            
            [self.addAdressesTextView setFont:[UIFont systemFontOfSize:16]];
            
            [cellTextView addSubview:self.addAdressesTextView];
        }
        
        else if ([[self.elementsArray objectAtIndex:indexPath.row - 2] isEqualToString:@"removeAdresses"])
        {
            [cellTextView.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_DELETE", @"ICON_NAME_DELETE")]];
            
            [self.removeAdressesTextView setFrame:CGRectMake(2 * cellTextView.frame.size.width / 5, 10.0f, 3 * cellTextView.frame.size.width / 5, cellTextView.frame.size.height - 20.0f)];
            
            [self.removeAdressesTextView setFont:[UIFont systemFontOfSize:16]];
            
            [cellTextView addSubview:self.removeAdressesTextView];
        }
        
        return cellTextView;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.activityIndicatorView isAnimating] || !self.keyboardHidden)
    {
        [self.descriptionTextView resignFirstResponder];
        
        [self.addAdressesTextView resignFirstResponder];
        
        [self.listeChambreTextView resignFirstResponder];
        
        [self.removeAdressesTextView resignFirstResponder];
        
        self.keyboardHidden = YES;
        
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    if (indexPath.row == 0)
    {
        self.reference = @"title";
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        alertView.title = @"Saisi du titre";
        
        alertView.message = @"Veuillez saisir un titre pour votre demande.";
        
        [alertView textFieldAtIndex:0].placeholder = @"Titre";
        
        [alertView addButtonWithTitle:@"Valider"];
        
        [alertView setDelegate:self];
        
        [alertView show];
    }
    
    else if (indexPath.row == 1)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        actionSheet.title = @"Sélectionner un type de demande";
        
        [actionSheet addButtonWithTitle:@"Alias"];
        [actionSheet addButtonWithTitle:@"Hébergement"];
        [actionSheet addButtonWithTitle:@"Mot de passe"];
        [actionSheet addButtonWithTitle:@"Problème technique"];
        [actionSheet addButtonWithTitle:@"Problème réseau"];
        [actionSheet addButtonWithTitle:@"Site des élèves"];
        [actionSheet addButtonWithTitle:@"Autre"];
        
        self.referenceActionSheet = @"type";
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [actionSheet showFromToolbar:self.navigationController.toolbar];
        }
        else
        {
            [actionSheet showInView:self.view];
        }
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"typeHebergement"])
    {
        self.reference = @"typeHebergement";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Type d'hébergement" message:@"Quel type d'hébergement souhaitez-vous ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Site web", @"version", nil];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"nomProjet"])
    {
        self.reference = @"nomProjet";
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        alertView.title = @"Nom du projet";
        
        alertView.message = @"Veuillez saisir le nom de votre projet.";
        
        [alertView textFieldAtIndex:0].placeholder = @"Nom du projet";
        
        [alertView addButtonWithTitle:@"Valider"];
        
        [alertView setDelegate:self];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"typeDepot"])
    {
        self.reference = @"typeDepot";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Type de dépôt" message:@"Quel type de dépôt souhaitez-vous ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"git", @"svn", nil];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"creerBDD"])
    {
        self.reference = @"creerBDD";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Base de données" message:@"Souhaitez-vous créer une base de données ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"reset"])
    {
        self.reference = @"reset";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reset" message:@"Souhaitez-vous reset l'alias ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"email"])
    {
        self.reference = @"email";
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        alertView.title = @"Email";
        
        alertView.message = @"Veuillez saisir votre email.";
        
        [alertView textFieldAtIndex:0].placeholder = @"Email";
        
        [alertView addButtonWithTitle:@"Valider"];
        
        [alertView setDelegate:self];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"typeConnexion"])
    {
        self.reference = @"typeConnexion";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Type de connexion" message:@"Quel type de connexion utilisez-vous ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ethernet", @"Wifi", nil];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"dateInterruptionConnexion"])
    {
        self.reference = @"dateInterruptionConnexion";
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        alertView.title = @"Date d'interruption de connexion";
        
        alertView.message = @"Veuillez saisir la date depuis laquelle vous avez une interruption de connexion.";
        
        [alertView textFieldAtIndex:0].placeholder = @"jour/mois/année";
        
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        
        [alertView addButtonWithTitle:@"Valider"];
        
        [alertView setDelegate:self];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"typeMateriel"])
    {
        self.reference = @"typeMateriel";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Type de matériel" message:@"Quel type de matériel utilisez-vous ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ordinateur", @"Smartphone", nil];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"logicielsInstalled"])
    {
        self.reference = @"logicielsInstalled";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Logiciel installé" message:@"Avez-vous installé le logiciel de connexion ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"tutoSuivi"])
    {
        self.reference = @"tutoSuivi";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tutoriel de connexion" message:@"Avez-vous suivi le tutoriel de connexion ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"detecteReseau"])
    {
        self.reference = @"detecteReseau";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Détection du réseau" message:@"Détectez-vous le réseau ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"detecteReseauVoisin"])
    {
        self.reference = @"detecteReseauVoisin";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Détection d'un réseau voisin" message:@"Détectez-vous un réseau voisin ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"autreChambre"])
    {
        self.reference = @"autreChambre";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Chambre" message:@"D'autres chambres ont-elles le même problème ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"newNomAssociaton"])
    {
        self.reference = @"newNomAssociaton";
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        alertView.title = @"Nom de l'association";
        
        alertView.message = @"Veuillez saisir le nom de l'association.";
        
        [alertView textFieldAtIndex:0].placeholder = @"Nom de l'association";
        
        [alertView addButtonWithTitle:@"Valider"];
        
        [alertView setDelegate:self];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"president"])
    {
        self.reference = @"president";
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        alertView.title = @"Identité du président";
        
        alertView.message = @"Veuillez saisir le prénom et le nom du président.";
        
        [alertView textFieldAtIndex:0].placeholder = @"Prénom Nom";
        
        [alertView addButtonWithTitle:@"Valider"];
        
        [alertView setDelegate:self];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"adresse"])
    {
        self.reference = @"adresse";
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        alertView.title = @"Adresse email";
        
        alertView.message = @"Veuillez saisir l'adresse email de l'alias.";
        
        [alertView textFieldAtIndex:0].placeholder = @"Email";
        
        [alertView addButtonWithTitle:@"Valider"];
        
        [alertView setDelegate:self];
        
        [alertView show];
    }
    
    else if ([self.elementsArray[indexPath.row - 2] isEqualToString:@"objet"])
    {
        self.referenceActionSheet = @"objet";
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        actionSheet.title = @"Sélectionner l'objet de votre demande";
        
        if ([self.ticketDictionary[@"type"] isEqualToString:@"Alias"])
        {
            [actionSheet addButtonWithTitle:@"create"];
            [actionSheet addButtonWithTitle:@"update"];
            [actionSheet addButtonWithTitle:@"delete"];
            [actionSheet addButtonWithTitle:@"createCompte"];
        }
        
        else if ([self.ticketDictionary[@"type"] isEqualToString:@"Site des élèves"])
        {
            [actionSheet addButtonWithTitle:@"createAssociation"];
            //[actionSheet addButtonWithTitle:@"droitsAssociation"];
            [actionSheet addButtonWithTitle:@"bug"];
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [actionSheet showFromToolbar:self.navigationController.toolbar];
        }
        else
        {
            [actionSheet showInView:self.view];
        }
    }
    
    [self.activityIndicatorView stopAnimating];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Annuler"])
    {
        return;
    }
    
    else if ([self.referenceActionSheet isEqualToString:@"type"])
    {
        [self.typeLabel setText:[@"Type : " stringByAppendingString:[actionSheet buttonTitleAtIndex:buttonIndex]]];
        
        self.objetLabel = nil;
        
        self.elementsArray = [[NSMutableArray alloc] init];
    }
    
    else if ([self.referenceActionSheet isEqualToString:@"objet"])
    {
        [self.objetLabel setText:[@"Objet : " stringByAppendingString:[actionSheet buttonTitleAtIndex:buttonIndex]]];
        
        self.elementsArray = [[NSMutableArray alloc] init];
        
        [self.elementsArray addObject:@"objet"];
    }
    
    [self.ticketDictionary setObject:[actionSheet buttonTitleAtIndex:buttonIndex] forKey:self.referenceActionSheet];
    
    [self setElementsArrayWithChoice:[actionSheet buttonTitleAtIndex:buttonIndex]];
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

- (void) setElementsArrayWithChoice:(NSString*)choice
{
    [self.activityIndicatorView startAnimating];
    
    if ([choice isEqualToString:@"Alias"])
    {
        [self.elementsArray addObject:@"objet"];
    }
    
    else if ([choice isEqualToString:@"Hébergement"])
    {
        [self.elementsArray addObject:@"typeHebergement"];
        [self.elementsArray addObject:@"nomProjet"];
        [self.elementsArray addObject:@"description"];
        [self.elementsArray addObject:@"typeDepot"];
        [self.elementsArray addObject:@"creerBDD"];
    }
    
    else if ([choice isEqualToString:@"Mot de passe"])
    {
        [self.elementsArray addObject:@"email"];
        [self.elementsArray addObject:@"description"];
    }
    
    else if ([choice isEqualToString:@"Problème technique"])
    {
        [self.elementsArray addObject:@"description"];
    }
    
    else if ([choice isEqualToString:@"Problème réseau"])
    {
        [self.elementsArray addObject:@"description"];
        [self.elementsArray addObject:@"typeConnexion"];
        [self.elementsArray addObject:@"dateInterruptionConnexion"];
        [self.elementsArray addObject:@"typeMateriel"];
        [self.elementsArray addObject:@"logicielsInstalled"];
        [self.elementsArray addObject:@"tutoSuivi"];
        [self.elementsArray addObject:@"detecteReseau"];
        [self.elementsArray addObject:@"detecteReseauVoisin"];
        [self.elementsArray addObject:@"autreChambre"];
        [self.elementsArray addObject:@"listeChambre"];
    }
    
    else if ([choice isEqualToString:@"Site des élèves"])
    {
        [self.elementsArray addObject:@"objet"];
    }
    
    else if ([choice isEqualToString:@"Autre"])
    {
        [self.elementsArray addObject:@"description"];
    }
    
    else if ([choice isEqualToString:@"createAssociation"])
    {
        [self.elementsArray addObject:@"newNomAssociaton"];
        [self.elementsArray addObject:@"president"];
        [self.elementsArray addObject:@"description"];
    }
    
    /*else if ([choice isEqualToString:@"droitsAssociation"])
    {
        [self.elementsArray addObject:@"nomAssociation"];
        [self.elementsArray addObject:@"role"];
        [self.elementsArray addObject:@"id"];
        [self.elementsArray addObject:@"description"];
    }*/
    
    else if ([choice isEqualToString:@"bug"])
    {
        [self.elementsArray addObject:@"description"];
    }
    
    else if ([choice isEqualToString:@"create"])
    {
        [self.elementsArray addObject:@"description"];
        [self.elementsArray addObject:@"adresse"];
        [self.elementsArray addObject:@"addAdresses"];
    }
    
    else if ([choice isEqualToString:@"update"])
    {
        [self.elementsArray addObject:@"adresse"];
        [self.elementsArray addObject:@"addAdresses"];
        [self.elementsArray addObject:@"removeAdresses"];
        [self.elementsArray addObject:@"reset"];
    }
    
    else if ([choice isEqualToString:@"delete"])
    {
        [self.elementsArray addObject:@"adresse"];
    }
    
    else if ([choice isEqualToString:@"createCompte"])
    {
        [self.elementsArray addObject:@"adresse"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Valider"])
    {
        if ([self.reference isEqualToString:@"title"])
        {
            [self.titleLabel setText:[@"Titre de la demande : " stringByAppendingString:[alertView textFieldAtIndex:0].text]];
        }
        
        else if ([self.reference isEqualToString:@"nomProjet"])
        {
            [self.nomProjetLabel setText:[@"Nom du projet : " stringByAppendingString:[alertView textFieldAtIndex:0].text]];
        }
        
        else if ([self.reference isEqualToString:@"newNomAssociaton"])
        {
            [self.nouveauNomAssociationLabel setText:[@"Nom de l'association : " stringByAppendingString:[alertView textFieldAtIndex:0].text]];
        }
        
        else if ([self.reference isEqualToString:@"dateInterruptionConnexion"])
        {
            [self.dateInterruptionConnexionLabel setText:[@"Date d'interruption de la connexion : " stringByAppendingString:[alertView textFieldAtIndex:0].text]];
        }
        
        else if ([self.reference isEqualToString:@"email"])
        {
            [self.emailLabel setText:[@"Email : " stringByAppendingString:[alertView textFieldAtIndex:0].text]];
        }
        
        else if ([self.reference isEqualToString:@"president"])
        {
            [self.presidentLabel setText:[@"Président : " stringByAppendingString:[alertView textFieldAtIndex:0].text]];
        }
        
        else if ([self.reference isEqualToString:@"adresse"])
        {
            [self.adresseLabel setText:[@"Adresse email : " stringByAppendingString:[alertView textFieldAtIndex:0].text]];
        }
        
        [self.ticketDictionary setObject:[alertView textFieldAtIndex:0].text forKey:self.reference];
    }
    
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Oui"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Non"])
    {
        if ([self.reference isEqualToString:@"creerBDD"])
        {
            [self.creerBDDLabel setText:[@"Voulez-vous créer une base de données ? " stringByAppendingString:[alertView buttonTitleAtIndex:buttonIndex]]];
        }
        
        else if ([self.reference isEqualToString:@"logicielsInstalled"])
        {
            [self.logicielsInstalledLabel setText:[@"Avez-vous installé le logiciel de connexion ? " stringByAppendingString:[alertView buttonTitleAtIndex:buttonIndex]]];
        }
        
        else if ([self.reference isEqualToString:@"tutoSuivi"])
        {
            [self.tutoSuiviLabel setText:[@"Avez-vous suivi le tuto ? " stringByAppendingString:[alertView buttonTitleAtIndex:buttonIndex]]];
        }
        
        else if ([self.reference isEqualToString:@"detecteReseau"])
        {
            [self.detecteReseauLabel setText:[@"Détectez-vous le réseau ? " stringByAppendingString:[alertView buttonTitleAtIndex:buttonIndex]]];
        }
        
        else if ([self.reference isEqualToString:@"detecteReseauVoisin"])
        {
            [self.detecteReseauVoisinLabel setText:[@"Détectez-vous un réseau voisin ? " stringByAppendingString:[alertView buttonTitleAtIndex:buttonIndex]]];
        }
        
        else if ([self.reference isEqualToString:@"autreChambre"])
        {
            [self.autreChambreLabel setText:[@"Ce problème de réseau impacte t-il plusieurs chambres ? " stringByAppendingString: [alertView buttonTitleAtIndex:buttonIndex]]];
        }
        
        else if ([self.reference isEqualToString:@"reset"])
        {
            [self.resetLabel setText:[@"Voulez-vous reset l'alias ?" stringByAppendingString:[alertView buttonTitleAtIndex:buttonIndex]]];
        }
        
        [self.ticketDictionary setObject:[alertView buttonTitleAtIndex:buttonIndex] forKey:self.reference];
    }
    
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Site web"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"version"])
    {
        [self.typeHebergementLabel setText:[@"Hébergement : " stringByAppendingString:[alertView buttonTitleAtIndex:buttonIndex]]];
        
        [self.ticketDictionary setObject:[alertView buttonTitleAtIndex:buttonIndex] forKey:self.reference];
    }
    
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"git"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"svn"])
    {
        [self.typeDepotLabel setText:[@"Type de dépôt : " stringByAppendingString:[alertView buttonTitleAtIndex:buttonIndex]]];
        
        [self.ticketDictionary setObject:[alertView buttonTitleAtIndex:buttonIndex] forKey:self.reference];
    }
    
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ethernet"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Wifi"])
    {
        [self.typeConnexionLabel setText:[@"Type de connexion : " stringByAppendingString:[alertView buttonTitleAtIndex:buttonIndex]]];
        
        [self.ticketDictionary setObject:[alertView buttonTitleAtIndex:buttonIndex] forKey:self.reference];
    }
    
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ordinateur"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Smartphone"])
    {
        [self.typeMaterielLabel setText:[@"Matériel utilisé : " stringByAppendingString:[alertView buttonTitleAtIndex:buttonIndex]]];
        
        [self.ticketDictionary setObject:[alertView buttonTitleAtIndex:buttonIndex] forKey:self.reference];
    }
}

@end
