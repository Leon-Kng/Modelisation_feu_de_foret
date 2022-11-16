![image](https://user-images.githubusercontent.com/92827382/199605937-7257bc75-9346-4843-9913-4ddb1235babe.png)


Concept de base: une proba de combustion pour chaque type de parcelle qui va être impactée par le vent, l'altitude, l'humidité et l'intensité des cases voisines

- Ajouter un système qui calcule la vitesse du feu (compter le nb de pixel qui a brûlé au total ou en plus chaque génération, stocker la valeur dans un vecteur et utiliser cela pour avoir une surface / temps) 
- Formuler la formule qui permet de donner la proba qu'une case prenne feu
- Faire changer de direction le vent au cours de la modélisation
- Faire des scénario où toute la zone est humide ou toute la zone est très sèche et les comparer

Rapport : 
- On a préféré avoir une modélisation qui donne un résultat "réaliste" que d'ajouter des pompiers qui auraient potentiellement été non réalistes 
- Faire une formulation du modèle
- Faire une analyse de sensibilité du modèle (voir CM4 Girondot)

Pas trouvé de coeff sur internet alors à cause de ce manque de donner pour paramétrer notre modèle, on a établi arbitrairement nos probas et facteurs de multiplication
