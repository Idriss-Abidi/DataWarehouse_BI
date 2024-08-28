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
        concat(me.prenom, ' ', me.nom) as nom_complet, 
        me.cin, 
        me.email,
        
        dlu."idLaboratoire",
        dlu.laboratoire,
        dlu."idUniteMesure" as idUniteMesure_lab,
        dlu.unitemesure,
        dtu."idTypeAnalyse",
        dtu."prestation" AS typeAnalyse,
        dtu."idUniteMesure" as idUniteMesure_type,
        dtu."abreviation" AS typeAnalyse_unitemesure,
        dd.valeur
    FROM 
        {{ ref('src_devis') }} d
    left JOIN 
        {{ ref('src_membreexterne') }} me ON d."idParticulier" = me."idMembreExterne"
    LEFT JOIN 
        {{ ref('src_detailsdevis') }} dd ON dd."idDevis" = d."idDevis"
    left join 
    {{ref('dim_detail_labo_unitemesure')}} dlu on dlu."idDetailLaboratoireUniteMesure" = dd."idDetailLaboratoireUniteMesure"
    left join 
    {{ref('dim_detail_typeanalyse_unitemesure')}} dtu on dtu."idDetailTypeAnalyseUniteMesure" = dd."idDetailTypeAnalyseUniteMesure"
    
    -- WHERE 
    --     d."idParticulier" IS NOT NULL
)
SELECT * FROM dim_devis
