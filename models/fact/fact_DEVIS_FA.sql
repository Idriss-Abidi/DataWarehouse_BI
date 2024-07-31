WITH fact_BA_FA AS (
    SELECT DISTINCT
        fa."idDetailsFicheAnalyse", 
        fa."idDevis",
        dv."dateCreation", 
        dv."numeroDevis", 
        dv."active",
        dv.nom_complet,
        fa.valeur, 
        fa."idDemandeFicheAnalyse", 
        fa."isConsommee",
        fa."idSousChampFicheAnalyse",
        fa.sous_champ_FA_Abreviation, 
        fa.sous_champ_FA_Valeur_Proposee,
        fa."idChampFicheAnalyse",
        fa.champ_fiche_analyse,
        fa.champ_FA_Valeur_Proposee,
        fa."idFicheAnalyse"
    FROM 
        {{ ref('dim_fiche_analyse') }} fa
    left join {{ref('dim_devis')}} dv on fa."idDevis"=dv."idDevis" 
    WHERE fa."idDevis" is not null
)
SELECT * FROM fact_BA_FA
