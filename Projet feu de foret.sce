clc // permet de rafraichir l'écran
clear // permet d'effacer les anciennes variables

// Association couleurs aux entités
eau=color(0,128,255), feu=color(250,0,0), urbain_dense=color(160,160,160), urbain_diffu=color(192,192,192), pelouse=color(178,255,102), foret_feuillus=color(128,255,0), foret_coniferes=color(76,153,0), landes_ligneuses=color(102,204,0), zone_indus_commer=color(96,96,96), surf_minerale=color(166,105,0), plages_dunes=color(255,255,51), prairie=color(204,255,153), vignes=color(153,0,153)

// Création de la grille et modification des couleurs
occupsol=read("occup_asc.txt",286,508)

for i=1:286     // nb de lignes
    for j=1:508     // nb de colonnes
        grille_time(i,j)=0      // on crée une grille pour le temps par la même occasion
        if occupsol(i,j)==31
            grille(i,j)=foret_feuillus
        end
        if occupsol(i,j)==32
            grille(i,j)=foret_coniferes
        end
        if occupsol(i,j)==34
            grille(i,j)=pelouse
        end
        if occupsol(i,j)==36
            grille(i,j)=landes_ligneuses
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
        end
        if occupsol(i,j)==222
            grille(i,j)=vignes
        end
    end
end


// Proportion des différents types de cases

prop_esp1=0.2, prop_esp2=0.2, prop_esp3=0.2, prop_esp4=0.2, prop_eau=0.1, prop_terre=0.1

// Définition des indices/coeff de combustion de chaque espèce d'arbre
combu_esp1=1,combu_esp2=2, combu_esp3=3, combu_esp4=4

// Début d'incencdie aléatoire 
grille_feu=grille
ligne_random=ceil(100*rand())
colonne_random=ceil(100*rand())
grille_feu(ligne_random,colonne_random)=feu

// On détermine un nombre de temps pour la modélisation
temps=500
vieillissement_feu=0.05  // pas de temps du vieillissement du feu
vitesse_combu=0.5   // pas de temps pour la durée que tiens un arbre à côté du feu avant de brûler

for t=1:temps
    grille_temp=grille_feu
    for i=2:(286-1)    // On commence à la ligne 2 et on arrête à l'avant dernière
        for j=2:(508-1)    // On commence à la colonne 2 et on arrête à l'avant dernière 
            // Règles : 
            if grille_feu(i,j)==feu   // Si feu sur la case alors
                grille_time(i,j)=(grille_time(i,j)+vieillissement_feu)   // le feu prend de l'age
                for y=(i-1):(i+1)   // on regarde toutes les cases autour
                    for x=(j-1):(j+1)
                        if grille_feu(y,x)==esp1 // si arbre espèce 1
                            if grille_time(y,x)<combu_esp1  // en contact du feu depuis moins de temps qu'il lui faut pour bruler
                                grille_time(y,x)=grille_time(y,x)+vitesse_combu
                            else grille_temp(y,x)=feu // alors feu
                            end
                        end
                        if grille_feu(y,x)==esp2
                            if grille_time(y,x)<combu_esp2
                                grille_time(y,x)=grille_time(y,x)+vitesse_combu
                            else grille_temp(y,x)=feu
                            end
                        end
                        if grille_feu(y,x)==esp3
                            if grille_time(y,x)<combu_esp3
                                grille_time(y,x)=grille_time(y,x)+vitesse_combu
                            else grille_temp(y,x)=feu
                            end
                        end
                        if grille_feu(y,x)==esp4
                            if grille_time(y,x)<combu_esp4
                                grille_time(y,x)=grille_time(y,x)+vitesse_combu
                            else grille_temp(y,x)=feu
                            end
                        end
                    end
                end
                if grille_time(i,j)>25    // Si feu atteint un certain "age" alors devient cednre car s'éteint
                    grille_temp(i,j)=cendres
                    grille_time(i,j)=grille_time(i,j)+vieillissement_feu
                end
            end
        end
    end
    Matplot(grille_temp)
    grille_feu=grille_temp
    disp(t)
end

// Affichage de la grille terminée

mprintf("Le feu a commencé à la ligne %d, colonne %d", ligne_random, colonne_random)


// Pour faire qu'un arbre résiste plus qu'un autre au feu ou inversement qu'un arbre brule facilement, on fera bruler l'arbre après plusieurs générations colées à un feu 
