<h3>Zone étudiée :</h3>

![image](https://user-images.githubusercontent.com/92827382/202258412-4162d9cf-3c47-4ca9-9695-1b0af9f15dae.png)

<h3> Carte avec les différents couverts végétaux :</h3>

![image](https://user-images.githubusercontent.com/92827382/202259317-9d922d98-4919-4bdc-b853-e56450142215.png)


<h3> Carte de l'altitude :</h3>

![image](https://user-images.githubusercontent.com/92827382/199605937-7257bc75-9346-4843-9913-4ddb1235babe.png)

![image](https://user-images.githubusercontent.com/92827382/202864202-db2d7b44-7fa1-4399-9d72-9e94a946f4d9.png)


Concept de base: une proba de combustion pour chaque type de parcelle qui va être impactée par le vent, l'altitude, l'humidité et l'intensité des cases voisines
Formule : proba que la case prenne feu (en %) = facteur de combustion X facteur d'humidité X facteur vent X facteur intensité de combustion X facteur altitude

<h3> A faire : </h3>

- Trouver comment stocker les matrices pour ensuite toutes les afficher à la suite sans délai de calcul
- Faire varier les valeurs de chaque facteur pour calculer la sensibilité et voir si cohérent et noter les calculs
- Trouver la valeur du temps d'une génération qui permet d'avoir une vitesse de déplacement du feu réaliste (30cm/sec)


<h3> Ce qu'on aurait pu faire : </h3>

- Faire changer de direction le vent au cours de la modélisation
- Faire des scénario où toute la zone est humide ou toute la zone est très sèche et les comparer

<h3>Rapport : </h3> 

- On a préféré avoir une modélisation qui donne un résultat "réaliste" que d'ajouter des pompiers qui auraient potentiellement été non réalistes 
- Faire une formulation du modèle
- Faire une analyse de sensibilité du modèle (voir CM4 Girondot)

Pas trouvé de coeff sur internet alors à cause de ce manque de donner pour paramétrer notre modèle, on a établi arbitrairement nos probas et facteurs de multiplication
