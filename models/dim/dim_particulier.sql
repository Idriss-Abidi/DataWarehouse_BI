WITH dim_particulier AS (
    SELECT DISTINCT
        me."idMembreExterne",
        cv.abreviation AS civilite,
        concat(me.nom, ' ', me.prenom) AS Particulier,
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
        me."idEtablissementNonUniversitaire"
    FROM 
        {{ ref('src_membreexterne') }} me
    LEFT JOIN 
        {{ ref('src_pays') }} p ON p."idPays" = me."idPays"
    LEFT JOIN 
        {{ ref('src_civilite') }} cv ON cv."idCivilite" = me."idCivilite"
    LEFT JOIN 
        {{ ref('src_specialite') }} sp ON sp."idSpecialite" = me."idSpecialite"
    WHERE 
         "DTYPE" like 'particulier'
)
SELECT * FROM dim_particulier
