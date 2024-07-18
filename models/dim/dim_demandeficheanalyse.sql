WITH dim_demandeficheanalyse AS (
    SELECT DISTINCT
        dfa."idDemandeFicheAnalyse",
        dfa."idBonAnalyse",
        dfa."idDevis",
        dfa.commentaire,
        sp.abreviation AS Specialite,
        dip.abreviation AS Diplome,
        sdfa.abreviation AS StatutDemandeFicheAnalyse,
        mp.abreviation AS MoyenPaiement,
        dfa."idLaboratoire"
    FROM 
        {{ source('SC_App1', 'demandeficheanalyse') }} dfa
    LEFT JOIN 
        {{ source('SC_App1', 'specialite') }} sp ON sp."idSpecialite" = dfa."idSpecialite"
    -- INNER JOIN 
    --    {{ source('SC_App1', 'laboratoire') }} lab ON lab."idLaboratoire" = dfa."idLaboratoire"
    LEFT JOIN 
        {{ source('SC_App1', 'statutdemandeficheanalyse') }} sdfa ON sdfa."idStatutDemandeFicheAnalyse" = dfa."idStatutDemandeFicheAnalyse"
    LEFT JOIN 
        {{ source('SC_App1', 'moyenpaiement') }} mp ON mp."idMoyenPaiement" = dfa."idMoyenPaiement"
    LEFT JOIN 
        {{ source('SC_App1', 'diplome') }} dip ON dip."idDiplome" = dfa."idDiplome"
)
SELECT * FROM dim_demandeficheanalyse
