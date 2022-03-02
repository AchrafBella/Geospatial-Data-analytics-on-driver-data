# Geospatial-Data-analytics-on-driver-data


# Objectif
------------
* Produire une analyse à partir de données individuelles de type “trace numérique”
* Connaître les fondamentaux de l’analyse de données spatiales
* Réfléchir concrètement sur les possibilités techniques et les enjeux sociaux liés à de telles analyses

# Données
---------
Vous pouvez télécharger les données à partir du lien suivant : https://acloud.zaclys.com/index.php/s/sgfzDeKQw5zeZGj

# Description
Heetch est une start-up française qui organise des services de VTC dans plusieurs villes du monde dont Casablanca. Les données sont fournies pour Casablanca pour le mois de mars 2019 avec un point GPS par minute et par véhicule. Ces données comportent un identifiant chauffeur (driver_id), une variable temporelle (location_at_local_time) et des coordonnées géographiques (longitude et latitude).

Des données supplémentaires sont ajoutées pour l’analyse : extraction de données OpenStreetMap directement depuis R et découpage administratif du Maroc téléchargé sur le site GADM.


* Fonction pour detecter si le deriver travaille la nuit ou le soir. 

![image](https://user-images.githubusercontent.com/52492864/150120334-976c4577-3d3b-48a3-8556-02902067f793.png)


* Fonction pour afficher les facilities de la ville de Casablanca.   

![image](https://user-images.githubusercontent.com/52492864/150120868-dbaa7fb0-96cc-4449-8dfc-85b3632bc025.png)

* Fonction pour detecter si le driver a visité un endroit précis.

![image](https://user-images.githubusercontent.com/52492864/150124209-4c7ecbaf-08ca-46fc-9362-28c789a7eea8.png)

* Fonction pour visuliser le temps de travail du driver.

![image](https://user-images.githubusercontent.com/52492864/150337681-0826f2c5-90f0-4807-ae23-a0c7748e3962.png)


* Fonction pour visuliser la vitesse du driver.

![image](https://user-images.githubusercontent.com/52492864/150343123-feeaabfa-0b6e-4e65-aa35-e89607fbdfaa.png)
 
* Fonction pour detecter la zone où le cheffeur habite

 
![image](https://user-images.githubusercontent.com/52492864/152639123-b7b74c6b-789d-486e-b01b-c0ff114860f7.png)

 
Exemple pour lancer l'application :
-----------
```R
run data_acquisition.R et analysis.R 
run data_visualization.R pour Rstudio
run shiny_application.R pour lancer l application
 
```
