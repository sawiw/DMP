DROP TABLE IF EXISTS Contact CASCADE;
CREATE TABLE IF NOT EXISTS Contact (
    id_contact serial NOT NULL PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT,
    mail TEXT NOT NULL,
    affiliation TEXT NOT NULL,
    identifier TEXT
);

DROP TABLE IF EXISTS Funding CASCADE;
CREATE TABLE IF NOT EXISTS Funding (
    id_funding serial NOT NULL PRIMARY KEY,
    grant_funding INT NOT NULL,
    id_contact_funding INT NOT NULL,
    CONSTRAINT fk_funding_contact 
        FOREIGN KEY (id_contact_funding) 
        REFERENCES Contact(id_contact) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Project CASCADE;
CREATE TABLE IF NOT EXISTS Project (
    id_project serial NOT NULL PRIMARY KEY,
    title TEXT NOT NULL,
    abstract TEXT NOT NULL,
    acronyme TEXT NOT NULL,
    start_date DATE NOT NULL,
    duration INT,
    id_funding_project INT NOT NULL,
    type TEXT NOT NULL,
    website TEXT,
    objectives TEXT NOT NULL,
    id_wp_project INT NOT NULL,
    CONSTRAINT fk_project_funding 
        FOREIGN KEY (id_funding_project) 
        REFERENCES Funding (id_funding) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_project_wp 
        FOREIGN KEY (id_wp_project) 
        REFERENCES Project (id_project) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Contact_Project CASCADE;
CREATE TABLE IF NOT EXISTS Contact_Project (
    id_contact INT NOT NULL,
    id_project INT NOT NULL,
    PRIMARY KEY (id_contact, id_project),
    CONSTRAINT fk_cp_contact 
        FOREIGN KEY (id_contact) 
        REFERENCES Contact (id_contact) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_cp_project 
        FOREIGN KEY (id_project) 
        REFERENCES Project (id_project) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

DROP TYPE IF EXISTS licence;
CREATE TYPE licence AS ENUM (
    'CC-BY-4.0',
    'CC-BY-NC-4.0',
    'CC-BY--ND-4.0',
    'CC-BY--SA-4.0',
    'CC0-1.0'
); 

DROP TABLE IF EXISTS ROMP CASCADE;
CREATE TABLE ROMP(
    id_romp SERIAL NOT NULL PRIMARY KEY,
    id_project_romp INT NOT NULL,
    id_contact_romp INT NOT NULL,
    identfier TEXT,
    submission_date DATE NOT NULL,
    version_romp TEXT NOT NULL,
    deliverable TEXT NOT NULL,
    licence licence DEFAULT 'CC-BY-4.0',
    ethical_issues TEXT,
    CONSTRAINT fk_romp_project 
        FOREIGN KEY (id_project_romp) 
        REFERENCES Project (id_project) 
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_romp_contact 
        FOREIGN KEY (id_contact_romp) 
        REFERENCES Contact (id_contact) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

DROP TYPE IF EXISTS cost_type;
CREATE TYPE cost_type AS ENUM (
    'Storage',
    'Archiving',
    'Re-use',
    'Other'
);

DROP TYPE IF EXISTS ro_type;
CREATE TYPE ro_type AS ENUM (
    'Data Set',
    'Service',
    'Data Paper',
    'Publication',
    'Software',
    'Model'
);

DROP TABLE IF EXISTS Research_Output;
CREATE TABLE IF NOT EXISTS Research_Output (
    id_ro SERIAL NOT NULL PRIMARY KEY,
    title TEXT NOT NULL,
    ro_type ro_type NOT NULL,
    identifier TEXT,
    ro_description TEXT,
    standard_used TEXT,
    keyword JSON, -- keyword de l'api
    reused BOOLEAN NOT NULL,
    lineage TEXT,
    utility TEXT,
    issued DATE,
    ro_language TEXT NOT NULL,
    ro_cost JSON
);

COMMENT ON COLUMN Research_Output.ro_cost IS 
'ro_cost {"type": "", "value": "", "unit": ""}
 avec type = ENUM : {Storage, Archiving, Re-Use, Other}';

DROP TABLE IF EXISTS Contact_RO CASCADE;
CREATE TABLE IF NOT EXISTS Contact_RO (
    id_contact INT NOT NULL,
    id_ro INT NOT NULL,
    PRIMARY KEY (id_contact, id_ro),
    CONSTRAINT fk_cro_contact 
        FOREIGN KEY (id_contact) 
        REFERENCES Contact (id_contact) 
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_cro_ro 
        FOREIGN KEY (id_ro) 
        REFERENCES Research_Output (id_ro) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS RO_Data;
---------------------------------------------
-- Methode INHERITS
---------------------------------------------
CREATE TABLE IF NOT EXISTS RO_Data (
    sensitive_data BOOLEAN NOT NULL,
    personal_data BOOLEAN NOT NULL,
    data_security TEXT
) INHERITS (Research_Output);
---------------------------------------------
-- Methode SANS INHERITS
---------------------------------------------
-- CREATE TABLE IF NOT EXISTS RO_Data (
--     id_ro_data INT PRIMARY KEY NOT NULL,
--     sensitive_data BOOLEAN NOT NULL,
--     personal_data BOOLEAN NOT NULL,
--     data_security TEXT,
--     CONSTRAINT fk_ro_data_ro
--         FOREIGN KEY (id_ro_data)
--         REFERENCES Research_Output (id_ro)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );
DROP TABLE IF EXISTS RO_service;
CREATE TABLE IF NOT EXISTS RO_Service (
    type_of_service TEXT NOT NULL,
    end_project_TRL INT NOT NULL
) INHERITS (Research_Output);

CREATE TABLE IF NOT EXISTS Metadata_Info (
    id_md_info serial NOT NULL PRIMARY KEY,
    description_md TEXT NOT NULL,
    standard_name TEXT,
    api TEXT NOT NULL -- url api accès MD
    id_ro_md_info INT NOT NULL,
    CONSTRAINT fk_md_info_ro
        FOREIGN KEY (id_ro_md_info)
        REFERENCES Research_Output (id_ro)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
DROP TABLE IF EXISTS RO_Can_Reference;
CREATE TABLE IF NOT EXISTS RO_Can_Reference (
    id_ro_init INT NOT NULL,
    id_ro_ref INT NOT NULL CHECK (id_ro_init != id_ro_ref),
    PRIMARY KEY (id_ro_init, id_ro_ref),
    CONSTRAINT fk_ro_init_canref_ro
        FOREIGN KEY (id_ro_init)
        REFERENCES Research_Output (id_ro)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_ro_ref_ro
      FOREIGN KEY (id_ro_ref)
      REFERENCES Research_Output (id_ro)
      ON DELETE NO ACTION
      ON UPDATE CASCADE
);

-- -- TODO
-- Embargo (id_embargo, start_date, end_date, legal&contractual_reasons, intentional_restrictions)
-- VOIR SI EMBARGO EN JSON A LA PLACE DE COST PASKE COST A UN ENUM COMME ATTRIBUT

-- Licence (id_licence, name, url)

-- Host (id_host, host_name, host_description, host_URL, certified_with, pid_system, support_versionning)

-- Distribution (id_disribution, acces, acces_URL, acces_protocol, size_value, format, download_url, #id_ro, #id_licence, #id_host, #id_embargo)