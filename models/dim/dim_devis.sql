WITH dim_devis AS (
    SELECT DISTINCT
        d."idDevis",
        d."dateCreation", 
        d."montantInitial", 
        d."numeroDevis", 
        d."consomme",
        d."active",
        d."idDemandeurEtablissementCaractereAdministratif", d."idDemandeurEtablissementCaractereCommercial",

        d."idParticulier",
        concat(me.nom, ' ', me.prenom) as nom_complet, 
        me.cin, 
        me.email,
        
        dd."idDetailsDevis",
        dd."idDetailLaboratoireUniteMesure",
        dd."idDetailTypeAnalyseUniteMesure",
        dd.valeur
    FROM 
        {{ source('SC_App1', 'devis') }} d
    left JOIN 
        {{ source('SC_App1', 'membreexterne') }} me ON d."idParticulier" = me."idMembreExterne"
    LEFT JOIN 
        {{ source('SC_App1', 'detailsdevis') }} dd ON dd."idDevis" = d."idDevis"
    -- WHERE 
    --     d."idParticulier" IS NOT NULL
)
SELECT * FROM dim_devis
