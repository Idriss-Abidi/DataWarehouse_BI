WITH dim_professeur AS (
    SELECT  
        me."idMembreExterne" AS id,
        cv.abreviation as civilite,
        concat(me.nom, ' ', me.prenom) AS "Professeur",
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
        {{ ref('src_membreexterne') }} me
    LEFT JOIN 
        {{ ref('src_pays') }} p ON p."idPays" = me."idPays"
     LEFT JOIN 
        {{ ref('src_civilite') }}cv ON cv."idCivilite" = me."idCivilite"
    INNER JOIN 
        {{ ref('src_detailfaculteecoleprofesseur') }} dfacprof ON dfacprof."idProfesseur" = me."idMembreExterne"
    LEFT JOIN 
        {{ ref('src_faculteecole') }} fac ON fac."idFaculteEcole" = dfacprof."idFaculteEcole"
    INNER JOIN 
        {{ ref('src_etablissementuniversitaire') }} eu ON eu."idEtablissementUniversitaire" = fac."idEtablissementUniversitaire"
    WHERE 
        "DTYPE" like 'professeur'
)
SELECT * FROM dim_professeur
