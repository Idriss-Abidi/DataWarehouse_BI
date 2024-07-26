WITH dim_membreexterne AS (
    SELECT 
        me."DTYPE" AS ME_DType, 
        me."idMembreExterne", 
        me.email, 
        me.cin, 
        CONCAT(me.prenom, ' ', me.nom) AS nom_complet, 
        me."idUser",
        me."idEtablissementNonUniversitaire", 
        enu."DTYPE" AS enu_DType, 
        enu.nom AS EtablissementNonUniversitaire, 
        senu.abreviation AS secteur_1,
        me."idEtablissementCaractereAdministratif", 
        eca.intitule AS EtablissementCaractereAdministratif, 
        te.abreviation AS TypeEtablissement, 
        me."idEtablissementCaractereCommercial", 
        ec.abreviation AS EtablissementCaractereCommercial, 
        sec.abreviation AS secteur_2
    FROM 
        {{ ref('src_membreexterne') }} me
    LEFT JOIN 
        {{ ref('src_etablissementnonuniversitaire') }} enu ON me."idEtablissementNonUniversitaire" = enu."idEtablissementNonUniversitaire"
    LEFT JOIN 
        {{ ref('src_etablissementcaracterecommercial') }} ec ON me."idEtablissementCaractereCommercial" = ec."idEtablissementCaractereCommercial"
    LEFT JOIN 
        {{ ref('src_etablissementcaractereadministratif') }} eca ON me."idEtablissementCaractereAdministratif" = eca."idEtablissementcaractereadministratif"
    LEFT JOIN 
        {{ ref('src_typeetablissement') }} te ON te."idTypeEtablissement" = eca."idTypeEtablissement"
    LEFT JOIN 
        {{ ref('src_secteur') }} senu ON senu."idSecteur" = enu."idSecteur"
    LEFT JOIN 
        {{ ref('src_secteur') }} sec ON ec."idSecteur" = sec."idSecteur"
    WHERE 
        me."DTYPE" LIKE 'particulier'
)
SELECT * FROM dim_membreexterne
