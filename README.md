# DB - DMP

Version du 7 juin 2022

> / .idea dossier pour l'IDE /

## DB Diagram

### Infos :

Utilisation de **CHECK IN ( '...', '...' )** au lieu des **ENUM** pour :

**Contact** (*type_contact*) = {'Organization', 'Person'}

**Contact** (*role_contact*) = {'Coord', 'DMP_Leader', 'WP_Leader', 'Task_Leader'}

**Research_Output** (*ro_cost*)  =  {'Organization', 'Person'}

**Research_Output** (*ro_type*)  =  {'Data Set', 'Service', 'Data Paper', 'Publication', 'Software', 'Model'}

**ROMP** (*licence_romp*) = (**'CC-BY-4.0'** par défaut) sinon = {'CC-BY-4.0', 'CC-BY-NC-4.0', 'CC-BY--ND-4.0', 'CC-BY--SA-4.0', 'CC0-1.0'}

**Distribution** (*access_distribution*)  = {'Open', 'On Demand', 'Embargo'}

**Distribution** (*size_unit*) = {'Ko', 'Mo', 'Go', 'To', 'Po'}

##### Diagramme de la base de données après le script `DMP_v1.sql`

![alt db_diagram]()

