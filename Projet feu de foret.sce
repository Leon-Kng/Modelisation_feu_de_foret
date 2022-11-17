clc // permet de rafraichir l'écran
clear // permet d'effacer les anciennes variables

// Association couleurs aux entités
eau=color(0,128,255), feu=color(250,0,0), urbain_dense=color(160,160,160), urbain_diffu=color(192,192,192), pelouse=color(178,255,102), foret_feuillus=color(128,255,0), foret_coniferes=color(76,153,0), landes_ligneuses=color(102,204,0), zone_indus_commer=color(96,96,96), surf_minerale=color(166,105,0), plages_dunes=color(255,255,51), prairie=color(204,255,153), vignes=color(153,0,153),vieux_feu=color(190,0,0), brique=color(100,100,100)

// Définition des probabilités de combustion de chaque type de case, en %
combu_pelouse=50, combu_foret_feuillus=50, combu_foret_coniferes=60, combu_landes_ligneuses=75, combu_prairie=65, combu_vignes=10

// Définition des intensités de combustion pour chaque type de case 
int_pelouse=20, int_foret_feuillus=75, int_foret_coniferes=90, int_landes_ligneuses=60, int_prairie=35, int_vignes=5

// Création des grilles et modification des couleurs
occupsol=read("occup_asc.txt",286,508)
grille_alt=read('alt_asc.txt',286,508)

for i=1:3
    for j=1:3
        grille_fact_vent=0
    end
end

for i=1:286     // nb de lignes
    for j=1:508     // nb de colonnes
        grille_time(i,j)=0      // on crée aussi une grille pour le temps
        if occupsol(i,j)==31
            grille(i,j)=foret_feuillus
            grille_intensite(i,j)=int_foret_feuillus
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
            grille(i,j)=urbain_dense
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

// Début d'incencdie aléatoire 
grille_feu=grille
ligne_feu=143//sample(1,20:280)
colonne_feu=254//sample(1,20:500)
grille_feu(ligne_feu,colonne_feu)=feu
mprintf("Le feu a commencé à la ligne %d, colonne %d \n", ligne_feu, colonne_feu)


// Paramètres de la modélisation 
temps=50   // On détermine un nombre de temps pour la modélisation
dir_vent="Est" // Peut prendre les valeurs "Sud", "Nord", "Est", "Ouest"
humidite=70 // en %
fact_humid=1-(humidite/100)  // facteur d'humidité
vitesse_vent=20  // en km/h
fact_vent=1+(vitesse_vent/100)
vent_pos=1.5*fact_vent
vent_neg=0.01*fact_vent
vent_neut=0.8*fact_vent
nb_cases_feu=0

filename = fullfile(pwd(), "test.csv")  // où on stocke les matrices

// Grilles du vent
if dir_vent=="Ouest"
    for a=1:3
        grille_fact_vent(a,1)=vent_neg // colonne 1
    end
    for a=1:3
        grille_fact_vent(a,2)=vent_neut // colonne 2
    end
    for a=1:3
        grille_fact_vent(a,3)=vent_pos // colonne 3
    end
end

if dir_vent=="Est"
    for a=1:3
        grille_fact_vent(a,1)=vent_pos
    end
    for a=1:3
        grille_fact_vent(a,2)=vent_neut
    end
    for a=1:3
        grille_fact_vent(a,3)=vent_neg
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
            grille_fact_vent(a,b)=1
        end
    end
end

//Début de la modélisation
for t=1:temps
    tic()
    grille_temp=grille_feu
    for i=3:(286-2)    // On commence à la ligne 2 et on arrête à l'avant dernière
        for j=3:(508-2)    // On commence à la colonne 2 et on arrête à l'avant dernière 
            // Règles : 
            if grille_feu(i,j)==feu   // Si feu sur la case alors
                grille_time(i,j)=grille_time(i,j)+1
                if grille_time(i,j)==50     // large pour être sûr qu'il a eu le temps de tout bruler autour
                    grille_temp(i,j)=vieux_feu
                else
                    for y=(i-1):(i+1)
                        a=(y-i+2)   // pour explorer la grille du vent
                        for x=(j-1):(j+1)
                            b=(x-j+2)
                            fact_intensite=(1+(sum(grille_intensite(y-1:y+1,x-1:x+1)))/1800)
                            delta_alt=(grille_alt(y,x))-(grille_alt(i,j))
                            if delta_alt<=0
                                fact_alt=1-delta_alt*0.01
                            else
                                fact_alt=delta_alt*0.01
                            end
                            if grille_feu(y,x)==pelouse // si case = pelouse
                                if sample(1,0:100)<(combu_pelouse*fact_humid*grille_fact_vent(a,b)*fact_intensite*fact_alt)
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
    //fprintfMat(filename, grille_temp)
    Matplot(grille_temp)    // Affichage de la grille
    grille_feu=grille_temp
    disp(t)
    temps_calc=toc()
    disp(temps_calc)
end

grille_feu(ligne_feu,colonne_feu)=color(0,0,0)    // origine du feu d'une autre couleur
//Matplot(grille_feu)
mprintf("Le feu a commencé à la ligne %d, colonne %d. \n Origine représentée par une case noire.\n", ligne_feu, colonne_feu)


///////// CALCUL DE LA VITESSE MOYENNE DU FEU DANS 4 DIRECTIONS ////////

// On cherche la bordure du feu pour chaque point cardinal
// Est
i=ligne_feu
j=colonne_feu
j=j+1   // on avance d'une case pour éviter la case noire
while grille_feu(i,j)==vieux_feu
    j=j+1
    while grille_feu(i,j)==feu
        j=j+1
    end
end
distance_est=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*20 // calcul de la norme du vecteur origine-point cardinal pour avoir la distance parcourue par le feu, on multiplie par 20 car c'est la taille d'une case en mètres
vitesse_feu_est=distance_est/temps  // calcul de la vitesse vers cette direction
mat_vitesses(2,3)=vitesse_feu_est

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
vitesse_feu_ouest=distance_ouest/temps
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
vitesse_feu_sud=distance_sud/temps
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
vitesse_feu_nord=distance_nord/temps
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
distance_nord_ouest=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*20
vitesse_feu_nord_ouest=distance_nord_ouest/temps
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
distance_nord_est=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*20
vitesse_feu_nord_est=distance_nord_est/temps
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
distance_sud_est=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*20
vitesse_feu_sud_est=distance_sud_est/temps
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
distance_sud_ouest=(sqrt(((i-ligne_feu)^2)+((j-colonne_feu)^2)))*20
vitesse_feu_sud_ouest=distance_sud_ouest/temps
mat_vitesses(3,1)=vitesse_feu_sud_ouest

mat_vitesses(2,2)=0
mprintf("Matrice des vitesses du feu pour chaque direction (point cardinal) en mètre par génération.")
disp(mat_vitesses)
