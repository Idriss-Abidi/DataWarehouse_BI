WITH dim_bonanalyse AS (
    SELECT DISTINCT
        b."idBonAnalyse", 
        b."dateCreation", 
        b."dateStatut", 
        b."isActuel", 
        b."montantInitial", 
        b."numeroBA", 
        b."idProfesseur",
        concat(me."prenom", ' ', me."nom") AS professeur,
        me."cin",
        eu."idEtablissementUniversitaire",
        eu."nom" AS etablissement_universitaire,
        dfac."idFaculteEcole",
        concat(fac."nom", ' - ', eu."nom") AS faculteecole_nom,
        sba."abreviation" as statut,
        scdba."abreviation" as statut_confirmation, 
        us."userName" as suiviePar,
        dba."idDetailsBonAnalyse",
        dba."idDetailLaboratoireUniteMesure",
        dba."idDetailTypeAnalyseUniteMesure",
        dba."valeur"
    FROM 
        {{ source('SC_App1', 'bonanalyse') }} b
    INNER JOIN 
        {{ source('SC_App1', 'membreexterne') }} me ON b."idProfesseur" = me."idMembreExterne"
    INNER JOIN 
        {{ source('SC_App1', 'detailfaculteecoleprofesseur') }} dfac ON me."idMembreExterne" = dfac."idProfesseur"
    INNER JOIN 
        {{ source('SC_App1', 'faculteecole') }} fac ON dfac."idFaculteEcole" = fac."idFaculteEcole"
    INNER JOIN 
        {{ source('SC_App1', 'etablissementuniversitaire') }} eu ON fac."idEtablissementUniversitaire" = eu."idEtablissementUniversitaire"
    INNER JOIN 
        {{ source('SC_App1', 'statutconfirmationdemandebonanalyse') }} scdba ON scdba."idStatutConfirmationDemandeBonAnalyse" = b."idStatutConfirmationDemandeBonAnalyse"
    INNER JOIN 
        {{ source('SC_App1', 'statutbonanalyse') }} sba ON sba."idStatutBonAnalyse" = b."idStatutBonAnalyse"
    LEFT JOIN 
        {{ source('SC_App1', 'users') }} us ON us."idUser" = b."suivieParUser"
    LEFT JOIN 
        {{ source('SC_App1', 'detailsbonanalyse') }} dba ON dba."idBonAnalyse" = b."idBonAnalyse"
    WHERE 
        b."idProfesseur" IS NOT NULL 
        AND dfac."idFaculteEcole" IS NOT NULL
)
SELECT * FROM dim_bonanalyse
