clc // permet de rafraichir l'écran
clear // permet d'effacer les anciennes variables

// Association couleurs aux entités
eau=color(0,128,255), feu=color(250,0,0), urbain_dense=color(160,160,160), urbain_diffu=color(192,192,192), pelouse=color(178,255,102), foret_feuillus=color(128,255,0), foret_coniferes=color(76,153,0), landes_ligneuses=color(102,204,0), zone_indus_commer=color(96,96,96), surf_minerale=color(166,105,0), plages_dunes=color(255,255,51), prairie=color(204,255,153), vignes=color(153,0,153),vieux_feu=color(190,0,0)

// Création de la grille et modification des couleurs
occupsol=read("occup_asc.txt",286,508)

for i=1:286     // nb de lignes
    for j=1:508     // nb de colonnes
        grille_time(i,j)=0      // on crée aussi une grille pour le temps
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

// Définition des probabilités de combustion de chaque type de case, en %
combu_pelouse=65, combu_foret_feuillus=47,5, combu_foret_coniferes=55, combu_landes_ligneuses=85, combu_prairie=75, combu_vignes=15

// Début d'incencdie aléatoire 
grille_feu=grille
ligne_random=sample(1,20:280)
colonne_random=sample(1,20:500)
grille_feu(ligne_random,colonne_random)=feu
mprintf("Le feu a commencé à la ligne %d, colonne %d", ligne_random, colonne_random)


// Paramètres de la modélisation 
temps=250   // On détermine un nombre de temps pour la modélisation
dir_vent="Sud" // Peut prendre les valeurs "Sud", "Nord", "Est", "Ouest"
humidite=70 // en %
facthumid=1-(humidite/100)  // facteur d'humidité

// Début de la modélisation
for t=1:temps
    tic()
    grille_temp=grille_feu
    for i=3:(286-2)    // On commence à la ligne 2 et on arrête à l'avant dernière
        for j=3:(508-2)    // On commence à la colonne 2 et on arrête à l'avant dernière 
            // Règles : 
            if grille_feu(i,j)==feu   // Si feu sur la case alors
                grille_time(i,j)=grille_time(i,j)+1
                if grille_time(i,j)==25     // large pour être sûr qu'il a eu le temps de tout bruler autour
                    grille_temp(i,j)=vieux_feu
                else
                if dir_vent=="Sud"
                    for y=(i-2):(i)
                        for x=(j-1):(j+1)
                            if grille_feu(y,x)==pelouse // si case = pelouse
                                if sample(1,0:100)<(combu_pelouse*facthumid)
                                    grille_temp(y,x)=feu
                                else
                                end
                            end
                            if grille_feu(y,x)==foret_feuillus
                                if sample(1,0:100)<(combu_foret_feuillus*facthumid)
                                    grille_temp(y,x)=feu
                                else
                                end
                            end
                            if grille_feu(y,x)==foret_coniferes
                                if sample(1,0:100)<(combu_foret_coniferes*facthumid)
                                    grille_temp(y,x)=feu
                                else
                                end
                            end
                            if grille_feu(y,x)==landes_ligneuses
                                if sample(1,0:100)<(combu_landes_ligneuses*facthumid)
                                    grille_temp(y,x)=feu
                                else
                                end
                            end
                            if grille_feu(y,x)==prairie
                                if sample(1,0:100)<(combu_prairie*facthumid)
                                    grille_temp(y,x)=feu
                                else
                                end
                            end
                            if grille_feu(y,x)==vignes
                                if sample(1,0:100)<(combu_vignes*facthumid)
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
    end
    Matplot(grille_temp)    // Affichage de la grille
    grille_feu=grille_temp
    disp(t)
    temps=toc()
    disp(temps)
end
