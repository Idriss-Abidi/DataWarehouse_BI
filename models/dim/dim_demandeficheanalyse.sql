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
        {{ ref('src_demandeficheanalyse') }} dfa
    LEFT JOIN 
        {{ ref('src_specialite') }} sp ON sp."idSpecialite" = dfa."idSpecialite"
    -- INNER JOIN 
    --    {{ ref('src_laboratoire') }} lab ON lab."idLaboratoire" = dfa."idLaboratoire"
    LEFT JOIN 
        {{ ref('src_statutdemandeficheanalyse') }} sdfa ON sdfa."idStatutDemandeFicheAnalyse" = dfa."idStatutDemandeFicheAnalyse"
    LEFT JOIN 
        {{ ref('src_moyenpaiement') }} mp ON mp."idMoyenPaiement" = dfa."idMoyenPaiement"
    LEFT JOIN 
        {{ ref('src_diplome') }} dip ON dip."idDiplome" = dfa."idDiplome"
)
SELECT * FROM dim_demandeficheanalyse
