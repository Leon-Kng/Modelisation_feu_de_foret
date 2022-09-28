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

prop_esp1=0.125
prop_esp2=0.125
prop_esp3=0.125
prop_esp4=0.125
prop_eau=0.25
prop_terre=0.25

// Association couleur aux entités
eau=color(0,33,241)
terre=color(187,105,0)
feu=color(250,0,0)
cendres=color(149,149,149)
esp1=color(27,255,0)
esp2=color(44,236,21)
esp3=color(61,198,45)
esp4=color(44,143,33)

// Définition des indices/coeff de combustion de chaque espèce d'arbre
combu_esp1=1    // indice correspond au nombre de temps avant que l'arbre brule
combu_esp2=2    // plus l'indice est grand, plus l'arbre est résistant
combu_esp3=3
combu_esp4=4

// Génération de la matrice de base
for i=1:nL
    for j=1:nC
        r=rand()
        if(r<prop_eau)
            grille(i,j)=eau
        end
        if(r>(prop_eau))&(r<(prop_eau+prop_terre))
            grille(i,j)=terre
        end
        if(r>(prop_eau+prop_terre))&(r<prop_eau+prop_terre+prop_esp1)
            grille(i,j)=esp1
        end
        if(r>(prop_eau+prop_terre+prop_esp1))&(r<(prop_eau+prop_terre+prop_esp1+prop_esp2))
            grille(i,j)=esp2
        end
        if(r>(prop_eau+prop_terre+prop_esp1+prop_esp2))&(r<(prop_eau+prop_terre+prop_esp1+prop_esp2+prop_esp3))
            grille(i,j)=esp3
        end
        if(r>(1-prop_esp4))
            grille(i,j)=esp4
        end
    end
end

// Début d'incendie aléatoire 
grille_feu=grille
ligne_random=ceil(100*rand())
colonne_random=ceil(100*rand())
grille_feu(ligne_random,colonne_random)=feu

// Création de la grille d'age du feu / grille du temps
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
            if grille_feu(i,j)==feu   // Si feu alors on regarde toutes les cases autour
                grille_age(i,j)=(grille_age(i,j)+viellissement)   // le feu prend de l'age
                for y=(i-1):(i+1)
                    for x=(j-1):(j+1)
                        if grille_feu(y,x)==esp1 // si forêt
                            grille_temp(y,x)=feu // alors feu
                        end
                        if grille_feu(y,x)==esp2
                            grille_temp(y,x)=feu
                        end
                        if grille_feu(y,x)==esp3
                            grille_temp(y,x)=feu
                        end
                        if grille_feu(y,x)==esp4
                            grille_temp(y,x)=feu
                        end
                    end
                end
            end
          if grille_age(i,j)>4
              grille_temp(i,j)=cendres
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
