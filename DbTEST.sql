CREATE TABLE Project (
    id serial NOT NULL PRIMARY KEY,
    title TEXT,
    contact JSON
);

INSERT INTO p2 VALUES
    (1, 
        '[{
        "type":"Person",
        "lastName":"Suard",
        "firstName":"Erwann",
        "mail":"erwann@gmail.com",
        "affiliation":"IRD",
        "identifier":"0000-0003-0634-3277"
        },{
        "type":"Person",
        "lastName":"Girard",
        "firstName" : "Sami",
        "mail":"sami@sami.fr",
        "affiliation":"FAIR-EASE",
        "identifier":"4321-4578-7894-3277"
        }]'
        ,'{"grant":"10M", "contact":["type":"Organization",
        "lastName":"CNRS",
        "mail":"cnrs@cnrs.fr",
        "affiliation":"CNRS",
        "identifier":"1234-0003-7894-3277"]}'
    );
    
INSERT INTO Project (id, title, contact) VALUES
    (2, 'Projet_2' , '
        {"type":"Person",
        "lastName":"Girard",
        "firstName":"Sami",
        "mail":"sgirard34@gmail.com",
        "affiliation":"CNRS",
        "identifier":"0000-0003-0634-3277"}');