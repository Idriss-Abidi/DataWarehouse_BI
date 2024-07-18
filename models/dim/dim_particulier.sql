WITH dim_particulier AS (
    SELECT DISTINCT
        me."idMembreExterne",
        cv.abreviation AS civilite,
        concat(me.nom, ' ', me.prenom) AS nom_complet,
        me.cin,
        me.email,
        me.adresse,
        me.ville,
        p.abreviation AS pays,
        me.telephone, 
        me.fax, 
        me.orcid, 
        me."dateDebutAffectation", 
        me."dateFinAffectation", 
        me."isActive",
        sp.abreviation AS specialite,
        me."idEtablissementCaractereAdministratif", 
        me."idEtablissementCaractereCommercial"
    FROM 
        {{ source('SC_App1', 'membreexterne') }} me
    LEFT JOIN 
        {{ source('SC_App1', 'pays') }} p ON p."idPays" = me."idPays"
    LEFT JOIN 
        {{ source('SC_App1', 'civilite') }} cv ON cv."idCivilite" = me."idCivilite"
    LEFT JOIN 
        {{ source('SC_App1', 'specialite') }} sp ON sp."idSpecialite" = me."idSpecialite"
    WHERE 
         "DTYPE" like 'particulier'
)
SELECT * FROM dim_particulier
