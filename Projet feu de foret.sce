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
mprintf("Le feu a commencé à la ligne %d, colonne %d", ligne_random, colonne_random)

// On détermine un nombre de temps pour la modélisation
temps=2
for t=1:temps
    for i=2:(nL-1)    // On commence à la ligne 2 et on arrête à l'avant dernière
        for j=2:(nC-1)    // On commence à la colonne 2 et on arrête à l'avant dernière 
//            vecteur=grille_feu(i-1:i+1,j-1:j+1)           
            mprintf("Test de la ligne %d, colonne %d \n", i,j)
            // Règles : 
            if grille_feu(i,j)==5
                for y=(i-1):(i+1)
                    for x=(-1):(j+1)
                        print(grille_feu(y,x))
                        //grille_feu(y,x)=5
                    end
                end

            end
        end
    end   
end

// Affichage de la grille terminée
Matplot(grille_feu)
