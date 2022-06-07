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
    id_contact INT NOT NULL,
    CONSTRAINT fk_funding__contact
        FOREIGN KEY (id_contact)
        REFERENCES Contact(id_contact) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Project CASCADE;
CREATE TABLE IF NOT EXISTS Project (
    id_project serial NOT NULL PRIMARY KEY,
    title TEXT NOT NULL,
    abstract TEXT NOT NULL,
    acronym TEXT NOT NULL,
    start_date DATE NOT NULL,
    duration INT,
    id_funding INT NOT NULL,
    type TEXT NOT NULL,
    website TEXT,
    objectives TEXT NOT NULL,
    id_wp INT NOT NULL,
    CONSTRAINT fk_project__funding
        FOREIGN KEY (id_funding)
        REFERENCES Funding (id_funding) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_project__wp
        FOREIGN KEY (id_wp)
        REFERENCES Project (id_project) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Contact_Project CASCADE;
CREATE TABLE IF NOT EXISTS Contact_Project (
    id_contact INT NOT NULL,
    id_project INT NOT NULL,
    PRIMARY KEY (id_contact, id_project),
    CONSTRAINT fk_c_p__contact
        FOREIGN KEY (id_contact) 
        REFERENCES Contact (id_contact) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_c_p__project
        FOREIGN KEY (id_project) 
        REFERENCES Project (id_project) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS ROMP CASCADE;
CREATE TABLE ROMP(
    id_romp SERIAL NOT NULL PRIMARY KEY,
    id_project INT NOT NULL,
    id_contact INT NOT NULL,
    identifier TEXT,
    submission_date DATE NOT NULL,
    version_romp TEXT NOT NULL,
    deliverable TEXT NOT NULL,
    licence_romp TEXT DEFAULT 'CC-BY-4.0',
        CHECK ( licence_romp IN (
                'CC-BY-4.0',
                'CC-BY-NC-4.0',
                'CC-BY--ND-4.0',
                'CC-BY--SA-4.0',
                'CC0-1.0'
    )),
    ethical_issues TEXT,
    CONSTRAINT fk_romp__project
        FOREIGN KEY (id_project)
        REFERENCES Project (id_project) 
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_romp__contact
        FOREIGN KEY (id_contact)
        REFERENCES Contact (id_contact) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Research_Output CASCADE;
CREATE TABLE IF NOT EXISTS Research_Output (
    id_ro SERIAL NOT NULL PRIMARY KEY,
    title TEXT NOT NULL,
    ro_type TEXT NOT NULL,
        CHECK ( ro_type IN (
            'Data Set',
            'Service',
            'Data Paper',
            'Publication',
            'Software',
            'Model'
    )),
    identifier TEXT,
    ro_description TEXT,
    standard_used TEXT,
    keyword JSON, -- keyword de l' API
    reused BOOLEAN NOT NULL,
    lineage TEXT,
    utility TEXT,
    issued DATE,
    ro_language TEXT NOT NULL,
    ro_cost JSON,
    id_romp INT NOT NULL,
    CONSTRAINT fk_ro__romp
        FOREIGN KEY (id_romp)
        REFERENCES ROMP (id_romp)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

COMMENT ON COLUMN Research_Output.ro_cost IS 
'ro_cost {"type": "", "value": "", "unit": ""}
 avec type = ENUM : {Storage, Archiving, Re-Use, Other}';

DROP TABLE IF EXISTS Contact_RO CASCADE;
CREATE TABLE IF NOT EXISTS Contact_RO (
    id_contact INT NOT NULL,
    id_ro INT NOT NULL,
    PRIMARY KEY (id_contact, id_ro),
    CONSTRAINT fk_contact_ro__contact
        FOREIGN KEY (id_contact)
        REFERENCES Contact (id_contact) 
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_contact_ro__ro
        FOREIGN KEY (id_ro)
        REFERENCES Research_Output (id_ro) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS RO_Data CASCADE;
CREATE TABLE IF NOT EXISTS RO_Data (
    id_ro INT PRIMARY KEY NOT NULL,
    sensitive_data BOOLEAN NOT NULL,
    personal_data BOOLEAN NOT NULL,
    data_security TEXT,
    CONSTRAINT fk_ro_data__ro
        FOREIGN KEY (id_ro)
        REFERENCES Research_Output (id_ro)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS RO_service CASCADE;
CREATE TABLE IF NOT EXISTS RO_Service (
    id_ro INT PRIMARY KEY NOT NULL,
    type_of_service TEXT NOT NULL,
    end_project_TRL INT NOT NULL,
    CONSTRAINT fk_ro_service__ro
        FOREIGN KEY (id_ro)
        REFERENCES Research_Output (id_ro)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Metadata_Info;
CREATE TABLE IF NOT EXISTS Metadata_Info (
    id_md_info serial NOT NULL PRIMARY KEY,
    description_md TEXT NOT NULL,
    standard_name TEXT,
    api TEXT NOT NULL, -- url api accès MD
    id_ro INT NOT NULL,
    CONSTRAINT fk_md_info__ro
        FOREIGN KEY (id_ro)
        REFERENCES Research_Output (id_ro)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS RO_Can_Reference CASCADE;
CREATE TABLE IF NOT EXISTS RO_Can_Reference (
    id_ro_init INT NOT NULL,
    id_ro_ref INT NOT NULL CHECK (id_ro_init != id_ro_ref),
    PRIMARY KEY (id_ro_init, id_ro_ref),
    CONSTRAINT fk_ro_init_can_ref__ro
        FOREIGN KEY (id_ro_init)
        REFERENCES Research_Output (id_ro)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_ro_ref__ro
      FOREIGN KEY (id_ro_ref)
      REFERENCES Research_Output (id_ro)
      ON DELETE NO ACTION
      ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Embargo CASCADE;
CREATE TABLE IF NOT EXISTS Embargo (
    id_embargo serial NOT NULL PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    legal_and_contractual_reasons TEXT,
    intentional_restrictions TEXT
);

DROP TABLE IF EXISTS Licence_Distribution CASCADE;
CREATE TABLE IF NOT EXISTS Licence_Distribution (
    id_licence serial NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    url TEXT
);

DROP TABLE IF EXISTS Host CASCADE;
CREATE TABLE IF NOT EXISTS Host (
    id_host serial NOT NULL PRIMARY KEY,
    host_name TEXT NOT NULL,
    host_description TEXT NOT NULL,
    host_url TEXT NOT NULL, -- de type url
    certified_with TEXT,
    pid_system TEXT,
    support_versioning BOOLEAN
);

DROP TABLE IF EXISTS Distribution CASCADE;
CREATE TABLE IF NOT EXISTS Distribution (
    id_distribution serial NOT NULL PRIMARY KEY,
    access TEXT,
        CHECK ( access IN (
            'Open',
            'On Demand',
            'Embargo'
        )),
    access_url TEXT NOT NULL,
    access_protocol TEXT NOT NULL,
    size_value INT,
    size_unit TEXT,
        CHECK ( size_unit IN (
                'Ko',
                'Mo',
                'Go',
                'To',
                'Po'
        )),
    format TEXT,
    download_url TEXT,
    id_ro INT NOT NULL,
        CONSTRAINT fk_distribution__ro
            FOREIGN KEY (id_ro)
            REFERENCES Research_Output (id_ro)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    id_licence INT NOT NULL,
        CONSTRAINT fk_distribution__licence_distribution
            FOREIGN KEY (id_licence)
            REFERENCES Licence_Distribution  (id_licence)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    id_host INT NOT NULL,
        CONSTRAINT fk_distribution__host
            FOREIGN KEY (id_host)
            REFERENCES Host (id_host)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    id_embargo INT NOT NULL,
    CONSTRAINT fk_distribution__embargo
            FOREIGN KEY (id_embargo)
            REFERENCES Embargo (id_embargo)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);