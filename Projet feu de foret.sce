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
        grille(i,j)=0
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
mprintf("Le feu a commencé à la ligne %d, colonne %d", ligne_random, colonne_random)

// Affichage de la grille terminée
Matplot(grille_feu)
