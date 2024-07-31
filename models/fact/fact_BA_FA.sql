WITH fact_BA_FA AS (
    SELECT DISTINCT
        fa."idDetailsFicheAnalyse", 
        fa."idBonAnalyse", 
        ba."dateCreation",
        ba."numeroBA",
        ba.active,
        ba.professeur,
        fa.valeur, 
        fa."idDemandeFicheAnalyse", 
        fa."isConsommee",
        fa."idSousChampFicheAnalyse",
        fa.sous_champ_FA_Abreviation, 
        fa.sous_champ_FA_Valeur_Proposee,
        fa."idChampFicheAnalyse",
        fa.champ_fiche_analyse,
        fa.champ_FA_Valeur_Proposee
        -- fa."idFicheAnalyse"
    FROM 
        {{ ref('dim_fiche_analyse') }} fa
    left join {{ref('dim_bonanalyse')}} ba on fa."idBonAnalyse"=ba."idBonAnalyse" 
    WHERE fa."idBonAnalyse" is not null
)
SELECT * FROM fact_BA_FA
