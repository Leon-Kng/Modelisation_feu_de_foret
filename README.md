<h1>Projet modelisation d'un feu de foret </h1>
<h3> Dans le cadre de l'UE de modélisation du master Biodiversité, Ecologie et Evolution à l'université de Paris-Saclay </h3>

Nous avons choisi le sujet visant à simuler la propagation d’un feu de forêt dans une région contenant différentes configurations paysagères en prenant en compte la direction et la vitesse du vent. 

Pour cela, nous utiliserons des automates cellulaires avec une matrice qui représentera la région soumise au feu. Les valeurs qui constitueront la matrice correspondront chacune à un type d’environnement (forêt, eau, feu) et sera associé à une couleur pour avoir un rendu graphique clair et explicite.

Par la suite, nous chercherons à tester en direct les techniques à mettre en place pour diminuer cette propagation sur notre modélisation (travaux de pare-feu préventifs ou bien pompiers curatifs). 

On pourrait peut-être envisager, en fonction du niveau de maîtrise nécessaire, la création d’une interface graphique qui permettrait de modifier en direct des variables comme la vitesse du vent ou sa direction à l’aide de sliders.

Nous aurons besoin des données suivantes pour établir un modèle réaliste :
Une région contenant plusieurs configurations paysagères 
La vitesse et la direction moyenne du vent dans cette région 
La propagation du feu selon le paysage

Nous devrons transformer la zone étudiée sous la forme d’une matrice afin de pouvoir l’exploiter dans le programme. Pour cela nous avons besoin de trouver une méthode permettant de faire cette conversion.

Nous avons décidé d’utiliser la forêt de Barbeau comme référence, en effet son monitoring en direct et l’historique de nombreuses données nous permettra de réaliser un projet le plus fidèle possible à la réalité en utilisant les données nécessaires comme par exemple l’orientation et la vitesse du vent dans la zone en moyenne. 

D’autre part, la littérature nous permettra de déterminer des données nécessaires comme la combustion des espèces d’arbres présents dans l’échantillon considéré.

http://www.barbeau.universite-paris-saclay.fr/index-fr.html
