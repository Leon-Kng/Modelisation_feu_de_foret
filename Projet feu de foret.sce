clc // permet de rafraichir l'écran
clear // permet d'effacer les anciennes variables
// Création de la grille 

// Nombre de lignes de la grille
nL=100

// Nombre de colonnes de la grille
nC=100

// Remplissage de la grille de départ avec des zéros

for i=1:nL
    for j=i:nC
        grille(i,j)=0 // i pour ligne et j pour colonne
    end
end

// Proportion des différents types de cases

prop_foret=0.75
prop_eau=0.15
prop_terre=0.10

// Association couleur aux entités
foret=color(36,214,0)
eau=color(0,33,241)
terre=color(243,232,0)
feu=color(255,0,0)

// Coloration des cases de la grille initiale
for i=1:nL
    for j=1:nC
        r=rand()
        if(r<prop_foret)
            grille(i,j)=foret
        end
        if(prop_foret<r)&(r<(prop_foret+prop_eau))
            grille(i,j)=eau
        end
        if(prop_foret+prop_eau<r)&(r<1)
            grille(i,j)=terre
        end
    end
end

// Début d'incendie aléatoire 
grille_feu=grille
ligne_random=ceil(100*rand())
colonne_random=ceil(100*rand())
grille_feu(ligne_random,colonne_random)=feu

// On détermine un nombre de temps pour la modélisation
temps=50

for t=1:temps
    grille_temp=grille_feu
    for i=2:(nL-1)    // On commence à la ligne 2 et on arrête à l'avant dernière
        for j=2:(nC-1)    // On commence à la colonne 2 et on arrête à l'avant dernière 
            // mprintf("Test de la ligne %d, colonne %d \n", i,j)
            // Règles : 
            if grille_feu(i,j)==5   // Si feu alors on regarde toutes les cases autour
                for y=(i-1):(i+1)
                    for x=(j-1):(j+1)
                        if grille_feu(y,x)==33  // si forêt
                            grille_temp(y,x)=5  // alors devient feu
                        end
                    end
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
