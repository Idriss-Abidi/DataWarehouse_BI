WITH dim_professeur AS (
    SELECT  
        me."idMembreExterne" AS id,
        cv.abreviation as civilite,
        concat(me.nom, ' ', me.prenom) AS nom_complet,
        me.cin,
        me.email, 
        me.telephone, 
        me.fax, 
        me.orcid,
        me.ville, 
        p.abreviation AS pays,
        eu."idEtablissementUniversitaire",
        eu.nom AS EtablissementUniversitaire,
        fac."idFaculteEcole", 
        concat(fac.nom, ' - ', eu.nom) AS faculte_ecole
    FROM 
        {{ source('SC_App1', 'membreexterne') }} me
    LEFT JOIN 
        {{ source('SC_App1', 'pays') }} p ON p."idPays" = me."idPays"
     LEFT JOIN 
        {{ source('SC_App1', 'civilite') }}cv ON cv."idCivilite" = me."idCivilite"
    INNER JOIN 
        {{ source('SC_App1', 'detailfaculteecoleprofesseur') }} dfacprof ON dfacprof."idProfesseur" = me."idMembreExterne"
    LEFT JOIN 
        {{ source('SC_App1', 'faculteecole') }} fac ON fac."idFaculteEcole" = dfacprof."idFaculteEcole"
    INNER JOIN 
        {{ source('SC_App1', 'etablissementuniversitaire') }} eu ON eu."idEtablissementUniversitaire" = fac."idEtablissementUniversitaire"
    WHERE 
        "DTYPE" like 'professeur'
)
SELECT * FROM dim_professeur
