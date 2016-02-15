//
//  ModificationDonneesPersonnellesView.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 26/06/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

// Cette view permet d'accéder à ses données personnelles présentes sur le serveur et à les modifier

#import "ModificationDonneesPersonnellesView.h"

#import "SpecificTableViewCell.h"

#import "SpecificTableViewCellWithWebView.h"

@interface ModificationDonneesPersonnellesView () <UIActionSheetDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) UserModel *_userModel;

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSArray *arrayTitre;

@property(nonatomic, strong) NSArray *arrayData;

@property(nonatomic, strong) NSString *elementSelected;

@property(nonatomic, strong) NSString *residence;

@property(nonatomic, strong) NSString *numeroTelephone;

@property(nonatomic, strong) NSString *numeroChambre;

@property(nonatomic, strong) UILabel *residenceLabel;

@property(nonatomic, strong) UILabel *numeroChambreLabel;

@property(nonatomic, strong) UILabel *numeroTelephoneLabel;

@end

@implementation ModificationDonneesPersonnellesView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:@"Données personnelles"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    [self.navigationController.navigationBar.backItem.backBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Données personnelles" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) setCellImage:(UITableViewCell *)cell i:(int)indice
{
    NSString *imageName;
    if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"User"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_USER", @"ICON_NAME_USER");
    }
    else if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"Résidence"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_HOME", @"ICON_NAME_HOME");
    }
    else if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"Chambre"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_ROOM", @"ICON_NAME_ROOM");
    }
    else if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"Téléphone"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_PHONE", @"ICON_NAME_PHONE");
    }
    
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void) buttonValiderActionListener
{
    [self updateUser:self.numeroChambre residence:self.residence telephone:self.numeroTelephone];
}

- (void) updateUser:(NSString *)chambre residence:(NSString *)residence telephone:(NSString *)telephone
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._userModel)
    {
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        self._userModel = [[UserModel alloc] init];
        
        self._userModel.delegate = self;
        
        self._userModel.API_url = self.API_url;
    }
    
    self.user.residence = residence;
    
    self.user.chambre = chambre;
    
    self.user.telephone = telephone;
    
    [self._userModel updateUser:chambre residence:residence telephone:telephone];
}

- (void) getUserDownloaded:(NSArray *)items
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Vos données ont bien été enregistrées" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
    
    [self.activityIndicatorView stopAnimating];
    
    [self.navigationController popToViewController:self.menuView animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[SpecificTableViewCellWithWebView class] forCellReuseIdentifier:@"cellWebView"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self initialisationView];
    
    self.arrayTitre = [[NSArray alloc] initWithObjects:@"User", @"Résidence", @"Chambre", @"Téléphone", nil];
    
    self.arrayData = [[NSArray alloc] initWithObjects:[[self.user.prenom stringByAppendingString:@" "] stringByAppendingString:self.user.nom ], self.user.residence, self.user.chambre, self.user.telephone, nil];
    
    self.residence = self.user.residence;
    
    self.numeroChambre = self.user.chambre;
    
    self.numeroTelephone = self.user.telephone;
    
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
    
    UIBarButtonItem *buttonValider = [[UIBarButtonItem alloc] initWithTitle:@"Valider" style:UIBarButtonItemStyleDone target:self action:@selector(buttonValiderActionListener)];
    
    [buttonValider setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    [self.navigationController.toolbar setItems:@[ flexibleSpace, buttonValider, flexibleSpace ]];
    
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arrayTitre.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.imageAvatarSVG)
    {
        SpecificTableViewCellWithWebView *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellWebView" forIndexPath:indexPath];
        
        [cell addWebViewAndImage:self.imageAvatarSVG];
        
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.textLabel.numberOfLines = 0;
        
        if ([[self.arrayData objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]] || [[self.arrayData objectAtIndex:indexPath.row] isEqualToString:@""])
        {
            [cell.textLabel setText:@"Aucune information enregistrée"];
        }
        else
        {
            [cell.textLabel setText:[self.arrayData objectAtIndex:indexPath.row]];
        }
        
        return cell;
    }
    
    SpecificTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    if (indexPath.row != 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0 && self.imageAvatar)
    {
        [cell.imageView setImage:self.imageAvatar];
    }
    else
    {
        [self setCellImage:cell i:(int)indexPath.row];
    }
    
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.numberOfLines = 0;
    
    if ([[self.arrayData objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]] || [[self.arrayData objectAtIndex:indexPath.row] isEqualToString:@""])
    {
        [cell.textLabel setText:@"Aucune information enregistrée"];
    }
    else
    {
        [cell.textLabel setText:[self.arrayData objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || [self.activityIndicatorView isAnimating])
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    self.elementSelected = [self.arrayTitre objectAtIndex:indexPath.row];
    
    if (indexPath.row == 1)
    {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choix d'une résidence" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:@"Condorcet", @"Descartes", @"Lavoisier", @"Supprimer l'information", nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [actionSheet showFromToolbar:self.navigationController.toolbar];
        }
        else
        {
            [actionSheet showInView:self.view];
        }
    }
    
    else if (indexPath.row == 2)
    {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        [[alertView textFieldAtIndex:0] setPlaceholder:@"Numéro de votre chambre"];
        
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
        
        alertView.delegate = self;
        
        [alertView setTitle:@"Numéro de chambre"];
        
        [alertView setMessage:@"Veuillez saisir votre numéro de chambre (exemple : 1234) ou supprimer votre numéro de chambre actuelle"];
        
        [alertView addButtonWithTitle:@"Annuler"];
        
        [alertView addButtonWithTitle:@"Supprimer"];
        
        [alertView addButtonWithTitle:@"Valider"];
        
        [alertView show];
    }
    
    else if (indexPath.row == 3)
    {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        [[alertView textFieldAtIndex:0] setPlaceholder:@"Numéro de téléphone"];
        
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
        
        alertView.delegate = self;
        
        [alertView setTitle:@"Numéro de téléphone"];
        
        [alertView setMessage:@"Veuillez saisir votre numéro de téléphone (exemple : 0601020304) ou supprimer le numéro rentré"];
        
        [alertView addButtonWithTitle:@"Annuler"];
        
        [alertView addButtonWithTitle:@"Supprimer"];
        
        [alertView addButtonWithTitle:@"Valider"];
        
        [alertView show];
    }
    
    [self.activityIndicatorView stopAnimating];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.activityIndicatorView startAnimating];
    
    [self.residenceLabel setText:[actionSheet buttonTitleAtIndex:buttonIndex]];
    
    self.residence = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Supprimer l'information"])
    {
        self.residence = @"";
        
        [self.residenceLabel setText:@"Aucune information enregistrée"];
    }
    
    [self.activityIndicatorView stopAnimating];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.activityIndicatorView startAnimating];
    
    if ([self.elementSelected isEqualToString:@"Chambre"] && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Valider"])
    {
        NSString *chambreRegEx = @"[0-9]{4}";
        
        NSPredicate *chambreTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chambreRegEx];
        
        if (![chambreTest evaluateWithObject:[[alertView textFieldAtIndex:0] text]])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Champ numéro de chambre incorrect, veuillez respecter le même format que l'exemple suivant : 1234" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        self.numeroChambre = [[alertView textFieldAtIndex:0] text];
        
        [self.numeroChambreLabel setText:self.numeroChambre];
    }
    
    else if ([self.elementSelected isEqualToString:@"Téléphone"] && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Valider"])
    {
        NSString *telephoneRegEx = @"[0-9]{10}";
        
        NSPredicate *telephoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telephoneRegEx];
        
        if (![telephoneTest evaluateWithObject:[[alertView textFieldAtIndex:0] text]])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Champ numéro de téléphone incorrect, veuillez respecter le même format que l'exemple suivant : 0601020304" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            return;
        }
        
        self.numeroTelephone = [[alertView textFieldAtIndex:0] text];
        
        [self.numeroTelephoneLabel setText:self.numeroTelephone];
    }
    
    else if ([self.elementSelected isEqualToString:@"Chambre"] && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Supprimer"])
    {
        self.numeroChambre = @"";
        
        [self.numeroChambreLabel setText:@"Aucune information enregistrée"];
    }
    
    else if ([self.elementSelected isEqualToString:@"Téléphone"] && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Supprimer"])
    {
        self.numeroTelephone = @"";
        
        [self.numeroTelephoneLabel setText:@"Aucune information enregistrée"];
    }
    
    [self.activityIndicatorView stopAnimating];
}

@end
