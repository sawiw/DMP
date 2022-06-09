DROP TABLE IF EXISTS ROMP;
DROP TABLE IF EXISTS Contact_Project;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Funding;
DROP TABLE IF EXISTS Contact;

CREATE TABLE IF NOT EXISTS Contact (
    id_contact serial NOT NULL PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT,
    mail TEXT NOT NULL,
    affiliation TEXT NOT NULL,
    laboratory_or_department TEXT,
    identifier TEXT
);

CREATE TABLE IF NOT EXISTS Funding (
    id_funding serial NOT NULL PRIMARY KEY,
    grant_funding INT NOT NULL,
    id_contact INT NOT NULL,
    CONSTRAINT fk_funding__contact
    FOREIGN KEY (id_contact)
    REFERENCES Contact(id_contact)
);

CREATE TABLE IF NOT EXISTS Project (
    id_project serial NOT NULL PRIMARY KEY,
    title TEXT NOT NULL,
    abstract TEXT NOT NULL,
    acronym TEXT,
    start_date DATE NOT NULL,
    duration INT,
    id_funding INT,
    website TEXT,
    objectives TEXT,
    id_project_parent INT,
    CONSTRAINT fk_project__funding
    FOREIGN KEY (id_funding)
    REFERENCES Funding (id_funding),
    CONSTRAINT fk_project__wp
    FOREIGN KEY (id_project_parent)
    REFERENCES Project (id_project)
);

CREATE TABLE IF NOT EXISTS Contact_Project (
    id_contact INT NOT NULL,
    id_project INT NOT NULL,
    role_contact TEXT NOT NULL,
    CHECK ( role_contact IN(
    'Coordinator',
    'DMP_Leader',
    'WP_Participant'
    )),
    PRIMARY KEY (id_contact, id_project),
    CONSTRAINT fk_c_p__contact
    FOREIGN KEY (id_contact)
    REFERENCES Contact (id_contact)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT fk_c_p__project
    FOREIGN KEY (id_project)
    REFERENCES Project (id_project)
);

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
        REFERENCES Project (id_project),
    CONSTRAINT fk_romp__contact
        FOREIGN KEY (id_contact)
        REFERENCES Contact (id_contact)
);