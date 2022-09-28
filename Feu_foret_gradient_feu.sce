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

prop_foret=0.5
prop_eau=0.25
prop_terre=0.25

// Association couleur aux entités
foret=color(36,214,0)
eau=color(0,33,241)
terre=color(187,105,0)
feu_1=color(255,195,0)
disp(feu_1)
feu_2=color(255,87,51)
disp(feu_2)
feu_3=color(199,0,57)
disp(feu_3)
feu_4=color(144,12,63)
disp(feu_4)
feu_5=color(88,24,69)
disp(feu_5)

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
grille_feu(ligne_random,colonne_random)=feu_1

// Création de la grille d'age du feu 
for i=1:nL
    for j=i:nC
        grille_age(i,j)=0
    end
end

// On détermine un nombre de temps pour la modélisation
temps=100
viellissement=0.05

for t=1:temps
    grille_temp=grille_feu
    for i=2:(nL-1)    // On commence à la ligne 2 et on arrête à l'avant dernière
        for j=2:(nC-1)    // On commence à la colonne 2 et on arrête à l'avant dernière 
            // Règles : 
            if grille_feu(i,j)==feu_1   // Si feu alors on regarde toutes les cases autour
                grille_age(i,j)=(grille_age(i,j)+viellissement)   // le feu prend de l'age
                for y=(i-1):(i+1)
                    for x=(j-1):(j+1)
                        if grille_feu(y,x)==foret // si forêt
                                grille_temp(y,x)=feu_1 // couleur feu_1
                        end                                
                    end
                end
            end
            if grille_age(i,j)>1 & grille_age(i,j)<2
              grille_temp(i,j)=feu_2
              grille_age(i,j)=grille_age(i,j)+viellissement
            end
            if grille_age(i,j)>2 & grille_age(i,j)<3
              grille_temp(i,j)=feu_3
              grille_age(i,j)=grille_age(i,j)+viellissement
            end
            if grille_age(i,j)>3 & grille_age(i,j)<4
              grille_temp(i,j)=feu_4
              grille_age(i,j)=grille_age(i,j)+viellissement
            end
            if grille_age(i,j)>4
              grille_temp(i,j)=feu_5
              grille_age(i,j)=grille_age(i,j)+viellissement
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

// Envoyer coordonnées GPS du coin en haut à gauche et en bas à droite à Kamel e il va noius donner un txt avec un code qui permet de le lire dans scilab 
