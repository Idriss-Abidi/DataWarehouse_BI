WITH fact_DA AS (
    SELECT DISTINCT
        df."idDossierAnalyse", 
        df."numeroDossierAnalyse", 
        -- df.abreviation as "Statut", 
        df."dateCreation", 
        -- df."dateDerniereModification", 
        -- df."idBonAnalyse",
        ba."numeroBA" ,
        ba.active as "BA_active",
        -- df."idDevis", 
        dv."numeroDevis",
        dv.active as "Devis_active",
        -- df."idEtudiant", 
        -- df."numeroDemandeFicheAnalyse", 
        df."idLaboratoire", 
        la."abreviation",
        df."idFacturation", 
        df."DTYPE", 
        -- df."dateCreation" as "dateDerniereModification_facture",
        df.numero, 
        df."numeroQuittance",
        us."userName" as suiviePar
    FROM 
        {{ ref('dim_dossieranalyse') }} df
    left join {{ref('dim_laboratoire')}} la on df."idLaboratoire"=la."idLaboratoire" 
    left join {{ref('src_users')}} us on us."idUser"=df."suivieParUser"
    left join {{ref('dim_bonanalyse')}} ba on ba."idBonAnalyse" =df."idBonAnalyse"
    left join {{ref('dim_devis')}} dv on dv."idDevis" =df."idDevis"
    
)
SELECT * FROM fact_DA
