clc
clear

// Corse du sud - région porto Vecchio

// Lire occupation du sol  : source http://osr-cesbio.ups-tlse.fr/~oso/posts/2018-06-06-carte-s2-2017-vecteur/

// Lire un fichier scilab 


occupsol=read("occup_asc.txt",286,508)
figure(1)
Matplot(occupsol)


// Lire altitude Source IGN BD ALTI 75 m



// Lire un fichier scilab 

alt=read('alt_asc.txt',286,508)
figure(2)
Matplot(alt./10)
// J'ai divié par 10 juste pour bien afficher les données sous Scilab

// Altitude à 20 m le pixel 
// Occupation du sol 20 m le pixel: la nomenclature est la suivante : 

//foret feuillus:31 ok
//foret coniferes:32 ok
//pelouse:34 ok
//landes ligneuses:36 ok
//urbain dense:41 ok
//urbain diffus:42 ok
//zones ind et com:43 ok
//surfaces minerales:45 ok
//plages et dunes:46 ok
//eau:51 ok
//prairies:211 ok
//vignes:222
