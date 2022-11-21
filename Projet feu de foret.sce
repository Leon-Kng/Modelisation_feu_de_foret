////Projet de modélisation d'un feu de Forêt - Chloé CHAUFOURIER et Léon KOENIG - Université PARIS-SACLAY////

clc // on rafraichit l'écran
clear //efface les anciennes variables

//Définition de couleurs pour chaque entité
eau=color(0,128,255), feu=color(250,0,0), urbain_dense=color(160,160,160), urbain_diffu=color(192,192,192), pelouse=color(178,255,102), foret_feuillus=color(128,255,0), foret_coniferes=color(76,153,0), landes_ligneuses=color(102,204,0), zone_indus_commer=color(96,96,96), surf_minerale=color(166,105,0), plages_dunes=color(255,255,51), prairie=color(204,255,153), vignes=color(153,0,153),vieux_feu=color(190,0,0), brique=color(100,100,100)

//Définition des probabilités de combustion de chaque type de case (en %)
combu_pelouse=50, combu_foret_feuillus=50, combu_foret_coniferes=60, combu_landes_ligneuses=75, combu_prairie=65, combu_vignes=10

//Définition des intensités de combustion pour chaque type de case (en %)
int_pelouse=20, int_foret_feuillus=75, int_foret_coniferes=90, int_landes_ligneuses=60, int_prairie=35, int_vignes=5

//Ouverture des matrices de la zone étudiée
occupsol=read("occup_asc.txt",286,508)  //matrice d'occupation du sol
grille_alt=read('alt_asc.txt',286,508)  //matrice des altitudes

//Création de la grille/matrice des facteurs du vent
for i=1:3
    for j=1:3
        grille_fact_vent=0
    end
end

//Création de matrices et association des couleurs aux types de cases
for i=1:286     //i=nb de lignes
    for j=1:508     //j=nb de colonnes
        grille_time(i,j)=0  //création grille pour le temps qui permettra de suivre l'"âge" d'une case en feu
        if occupsol(i,j)==31
            grille(i,j)=foret_feuillus  //association aux couleurs souhaitées
            grille_intensite(i,j)=int_foret_feuillus    //création d'une matrice avec les intensités de combustion en fonction du type de case
        end
        if occupsol(i,j)==32
            grille(i,j)=foret_coniferes
            grille_intensite(i,j)=int_foret_coniferes
        end
        if occupsol(i,j)==34
            grille(i,j)=pelouse
            grille_intensite(i,j)=int_pelouse
        end
        if occupsol(i,j)==36
            grille(i,j)=landes_ligneuses
            grille_intensite(i,j)=int_landes_ligneuses
        end
        if occupsol(i,j)==41
            grille(i,j)=urbain_dense    //pas d'intensité car ne brûle pas
        end
        if occupsol(i,j)==42
            grille(i,j)=urbain_diffu
        end
        if occupsol(i,j)==43
            grille(i,j)=zone_indus_commer
        end
        if occupsol(i,j)==45
            grille(i,j)=surf_minerale
        end
        if occupsol(i,j)==46
            grille(i,j)=plages_dunes
        end
        if occupsol(i,j)==51
            grille(i,j)=eau
        end
        if occupsol(i,j)==211
            grille(i,j)=prairie
            grille_intensite(i,j)=int_prairie
        end
        if occupsol(i,j)==222
            grille(i,j)=vignes
            grille_intensite(i,j)=int_vignes
        end
    end
end

//DEFINITION ORIGINE INCENDIE
grille_feu=grille   //grille sur laquelle on va travailler
ligne_feu=143   //si on veut une ligne aléatoire alors: sample(1,20:280)
colonne_feu=254 //si on veut une colonne aléatoire alors: sample(1,20:500)
grille_feu(ligne_feu,colonne_feu)=feu
mprintf("Le feu a commencé à la ligne %d, colonne %d \n", ligne_feu, colonne_feu)


//DEFINITION PARAMETRES MODELISATION
temps=150   //On détermine un nombre de générations/temps de modélisation
dir_vent="Est" //Peut prendre les valeurs "Sud", "Nord", "Est", "Ouest" et "Pas_de_vent"
humidite=50 //en %
fact_humid=1-(humidite/100)  //facteur de multiplication de l'humidité sur toute la carte
vitesse_vent=15  //en km/h
eff_vit_vent=1+(vitesse_vent/100)  //facteur assoié à la vitesse du vent
vent_pos=1.5*eff_vit_vent  //facteur quand dans le sens du vent
vent_neg=0.01*eff_vit_vent  //facteur contre le vent
vent_neut=0.8*eff_vit_vent  //facteur sur les côtés
temps_calc_tot=0    // pour avoir le temps de calcul total de la modélisation à la fin (en secondes)

//GRILLES DU VENT
//Direction du vent = d'où vient le vent, opposé au sens de déplacement de l'air!
if dir_vent=="Ouest"
    for a=1:3
        grille_fact_vent(a,1)=vent_neg //colonne 1
    end
    for a=1:3
        grille_fact_vent(a,2)=vent_neut //colonne 2
    end
    for a=1:3
        grille_fact_vent(a,3)=vent_pos //colonne 3
    end
end

if dir_vent=="Est"
    for a=1:3
        grille_fact_vent(a,1)=vent_pos  //colonne 1
    end
    for a=1:3
        grille_fact_vent(a,2)=vent_neut //colonne 2
    end
    for a=1:3
        grille_fact_vent(a,3)=vent_neg  //colonne 3
    end
end

if dir_vent=="Sud"
    for a=1:3
        grille_fact_vent(1,a)=vent_pos  // ligne 1
    end
    for a=1:3
        grille_fact_vent(2,a)=vent_neut // ligne 2
    end
    for a=1:3
        grille_fact_vent(3,a)=vent_neg  // ligne3
    end
end

if dir_vent=="Nord"
    for a=1:3
        grille_fact_vent(1,a)=vent_neg  // ligne 1
    end
    for a=1:3
        grille_fact_vent(2,a)=vent_neut // ligne 2
    end
    for a=1:3
        grille_fact_vent(3,a)=vent_pos  // ligne3

    end
end

if dir_vent=="Pas_de_vent"
    for a=1:3
        for b=1:3
            grille_fact_vent(a,b)=1 //facteur de 1 = pas de changement de la proba
        end
    end
end

//Stockage de la première matrice dans une liste
stock_matrices=list(grille_feu)

//MODELISATION
for t=1:temps
    tic()   //permet d'avoir le temps de calcul de la boucle
    grille_temp=grille_feu  //grille temporaire pour faire les modifications
    for i=3:(286-2)    //début ligne 2 fin à l'avant dernière car au delà on regarderait en dehors de la matrice
        for j=3:(508-2)    //début colonne 2 et fin à l'avant dernière 
            if grille_feu(i,j)==feu
                grille_time(i,j)=grille_time(i,j)+1
                if grille_time(i,j)==50     // large pour être sûr que le feu a eu le temps de tout bruler autour
                    grille_temp(i,j)=vieux_feu  //évitera de faire les calculs sur ces cases (optimisation)
                else
                    for y=(i-1):(i+1)   //regarde chaque case autour de la case en feu (8 cases)
                        a=(y-i+2)   //pour explorer la grille du vent
                        for x=(j-1):(j+1)
                            b=(x-j+2)
                            fact_intensite=(1+(sum(grille_intensite(y-1:y+1,x-1:x+1)))/1800)  //facteur d'intensité en fonction de l'intensité de combustion tout autour de la case, divisé par 1800 pour avoir un facteur cohérent
                            delta_alt=(grille_alt(y,x))-(grille_alt(i,j))  //différence d'altitude entre la case et case en feu
                            if delta_alt<=0 //si case est plus basse que la case en feu
                                fact_alt=1+delta_alt*0.01   //facteur d'altitude <1 donc réduit la proba de feu
                            else    //quand case est plus haute que la case en feu
                                fact_alt=1+delta_alt*0.01 //facteur >1 donc proba de feu augmente
                            end
                            if grille_feu(y,x)==pelouse //si case = pelouse
                                if sample(1,0:100)<(combu_pelouse*fact_humid*grille_fact_vent(a,b)*fact_intensite*fact_alt) //on multiplie la proba de combustion de base par l'ensemble des facteurs
                                    grille_temp(y,x)=feu
                                else
                                end
                            end
                            if grille_feu(y,x)==foret_feuillus
                                if sample(1,0:100)<(combu_foret_feuillus*fact_humid*grille_fact_vent(a,b)*fact_intensite*fact_alt)
                                    grille_temp(y,x)=feu
                                else
                                end
                            end
                            if grille_feu(y,x)==foret_coniferes
                                if sample(1,0:100)<(combu_foret_coniferes*fact_humid*grille_fact_vent(a,b)*fact_intensite*fact_alt)
                                    grille_temp(y,x)=feu
                                else
                                end
                            end
                            if grille_feu(y,x)==landes_ligneuses
                                if sample(1,0:100)<(combu_landes_ligneuses*fact_humid*grille_fact_vent(a,b)*fact_intensite*fact_alt)
                                    grille_temp(y,x)=feu
                                else
                                end
                            end
                            if grille_feu(y,x)==prairie
                                if sample(1,0:100)<(combu_prairie*fact_humid*grille_fact_vent(a,b)*fact_intensite*fact_alt)
                                    grille_temp(y,x)=feu
                                else
                                end
                            end
                            if grille_feu(y,x)==vignes
                                if sample(1,0:100)<(combu_vignes*fact_humid*grille_fact_vent(a,b)*fact_intensite*fact_alt)
                                    grille_temp(y,x)=feu
                                else
                                end
                            end

                        end
                    end
                end
            end
        end
    end
    //Matplot(grille_temp)    //affichage de la grille temporaire
    stock_matrices($+1)=grille_temp
    grille_feu=grille_temp  //matrice temporaire sauvegardée
    disp(t)     //affichage de la génération actuelle
    temps_calc=toc()
    disp(temps_calc)    //affichage du temps de calcul
    temps_calc_tot=temps_calc_tot+temps_calc
end

temps_calc_tot_min=temps_calc_tot/60    //convertion en minutes
temps_IRL_sec=temps*3.6 //durée réelle de la simulation
temps_IRL_min=temps_IRL_sec/60  //convertion en minutes

///////// CALCUL DE LA VITESSE MOYENNE DU FEU DANS TOUTES LES DIRECTIONS ////////

// On cherche la bordure du feu pour chaque point cardinal
// Est
i=ligne_feu
j=colonne_feu
j=j+1   //on avance d'une case pour éviter la case noire à l'origine
while grille_feu(i,j)==vieux_feu
    j=j+1
    while grille_feu(i,j)==feu
        j=j+1
    end
end
distance_est=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*20 //calcul de la norme du vecteur origine-point cardinal pour avoir la distance parcourue par le feu, on multiplie par 20 car c'est la taille d'une case en mètres donc distance en mètres
vitesse_feu_est=distance_est/(temps*3.6)  //calcul de la vitesse vers cette direction (en mètres par secondes), *3.6 car une génération =3.6 secondes
mat_vitesses(2,3)=vitesse_feu_est   //stockage de la vitesse dans une matrice organisée comme une rose des vents

// Ouest
i=ligne_feu
j=colonne_feu
j=j-1
while grille_feu(i,j)==vieux_feu
    j=j-1
    while grille_feu(i,j)==feu
        j=j-1
    end
end
distance_ouest=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*20
vitesse_feu_ouest=distance_ouest/(temps*3.6)
mat_vitesses(2,1)=vitesse_feu_ouest

// Sud
i=ligne_feu
j=colonne_feu
i=i+1
while grille_feu(i,j)==vieux_feu
    i=i+1
    while grille_feu(i,j)==feu
        i=i+1
    end
end
distance_sud=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*20
vitesse_feu_sud=distance_sud/(temps*3.6)
mat_vitesses(3,2)=vitesse_feu_sud

// Nord
i=ligne_feu
j=colonne_feu
i=i-1
while grille_feu(i,j)==vieux_feu
    i=i-1
    while grille_feu(i,j)==feu
        i=i-1
    end
end
distance_nord=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*20
vitesse_feu_nord=distance_nord/(temps*3.6)
mat_vitesses(1,2)=vitesse_feu_nord

// Nord-Ouest
i=ligne_feu
j=colonne_feu
i=i-1
j=j-1
while grille_feu(i,j)==vieux_feu
    i=i-1
    j=j-1
    while grille_feu(i,j)==feu
        i=i-1
        j=j-1
    end
end
distance_nord_ouest=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*sqrt((20^2)+(20^2))   //car diagonale d'une case est différente des côtés
vitesse_feu_nord_ouest=distance_nord_ouest/(temps*3.6)
mat_vitesses(1,1)=vitesse_feu_nord_ouest

// Nord-Est
i=ligne_feu
j=colonne_feu
i=i-1
j=j+1
while grille_feu(i,j)==vieux_feu
    i=i-1
    j=j+1
    while grille_feu(i,j)==feu
        i=i-1
        j=j+1
    end
end
distance_nord_est=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*sqrt((20^2)+(20^2))
vitesse_feu_nord_est=distance_nord_est/(temps*3.6)
mat_vitesses(1,3)=vitesse_feu_nord_est

// Sud-Est
i=ligne_feu
j=colonne_feu
i=i+1
j=j+1
while grille_feu(i,j)==vieux_feu
    i=i+1
    j=j+1
    while grille_feu(i,j)==feu
        i=i+1
        j=j+1
    end
end
distance_sud_est=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*sqrt((20^2)+(20^2))
vitesse_feu_sud_est=distance_sud_est/(temps*3.6)
mat_vitesses(3,3)=vitesse_feu_sud_est

// Sud-Ouest
i=ligne_feu
j=colonne_feu
i=i+1
j=j-1
while grille_feu(i,j)==vieux_feu
    i=i+1
    j=j-1
    while grille_feu(i,j)==feu
        i=i+1
        j=j-1
    end
end
distance_sud_ouest=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*sqrt((20^2)+(20^2))
vitesse_feu_sud_ouest=distance_sud_ouest/(temps*3.6)
mat_vitesses(3,1)=vitesse_feu_sud_ouest

mat_vitesses(2,2)=0 //zéro au centre de la matrice rose des vents
mat_vitesses_kmh=mat_vitesses*3600/1000
vitesse_moy_ms=(sum(mat_vitesses(1:3,1:3))/8)
vitesse_moy_kmh=vitesse_moy_ms*3600/1000 //convertion en km/h

//AFFICHAGE DES CONDITIONS DE LA MODELISATION ET RESULTATS
mprintf("Le feu a commencé à la ligne %d, colonne %d. \nOrigine représentée par une case noire.\n", ligne_feu, colonne_feu)
mprintf("Nombre de générations de la modélisation :  %d\n", temps)
mprintf("Durée réelle de la simulation : %d secondes soit %d minutes.\n",temps_IRL_sec, temps_IRL_min)
mprintf("Direction du vent :%s \n",dir_vent)
mprintf("Humidité : %d pourcents \n",humidite)
mprintf("Vitesse du vent : %d km/h \n",vitesse_vent)
mprintf("Matrice des vitesses du feu pour chaque direction (point cardinal) en mètre par seconde :\n")
disp(mat_vitesses)
mprintf("Matrice des vitesses du feu pour chaque direction (point cardinal) en kilomètres par heure :\n")
disp(mat_vitesses_kmh)
mprintf("Vitesse moyenne de propagation du feu : %f mètres par secondes soit %d kilomètres par heure. \n", vitesse_moy_ms, vitesse_moy_kmh)
mprintf("Temps de calcul total pour la modélisation : %d secondes soit environ %d minutes.\n", temps_calc_tot, temps_calc_tot_min)


//Affichage de toutes les matrices à la suite pour animer la modélisation (copier-coller cette boucle dans la console pour voir à nouveau la propagation du feu)
for i=1:(temps+1)
    x=0
    while x<2
        Matplot(stock_matrices(i))
        x=x+1
    end
end
grille_feu(ligne_feu,colonne_feu)=color(0,0,0)  //origine du feu d'une autre couleur pour bien l'identifier
Matplot(grille_feu)
