CREATE TABLE IF NOT EXISTS Medicament (
    nom TEXT PRIMARY KEY NOT NULL,
    descriptionMed JSON,
    conditionnement int,
    contre_indication JSON,
    composant JSON
);

INSERT INTO Medicament (nom,descriptionMed,conditionnement,contre_indication,composant)
VALUES (
    'Le Chourix',
    '{
        "courte_fr": "Médicament contre la chute des choux",
        "longue_latin": "latin de fdp"
    }',
    13,
    '[
        {"text":"Le Chourix ne doit jamais être pris après minuit."},
        {"text":"Le Chourix ne doit jamais être mis au contact avec de l eau."}
    ]',
    '[
        {"code":"HG79", "intitule":"Vif-argent allégé"},
        {"code":"SN50", "intitule":"Pur étain"}
    ]'  
);

INSERT INTO Medicament (nom,descriptionMed,conditionnement,contre_indication,composant)
VALUES (
    'Le Tropas',
    '{
        "courte_fr": "Médicament contre les dysfonctionnements intellectuels",
        "longue_latin": "latin de ses morts"
    }',
    42,
    '[
        {"text":"Le Tropas doit être gardé à l abri de la lumière du soleil"}
    ]',
    '[
        {"code":"HG79", "intitule":"Vif-argent allégé"}
    ]'  
);