WITH dim_detailsficheanalyse AS (
    SELECT DISTINCT
        dfa."idDetailsFicheAnalyse", 
        dfa."idBonAnalyse", 
        dfa."idDevis", 
        dfa.valeur, 
        dfa."idDemandeFicheAnalyse", 
        dfa."isConsommee",
        scfa."idSousChampFicheAnalyse",
        scfa.abreviation AS sous_champ_FA_Abreviation, 
        vpfa_s.abreviation AS sous_champ_FA_Valeur_Proposee,
        dcfascfa."idChampFicheAnalyse",
        cfa.abreviation AS champ_fiche_analyse,
        vpfa_c.abreviation AS champ_FA_Valeur_Proposee,
        fa."idFicheAnalyse"
    FROM 
        {{ ref('src_detailsficheanalyse') }} dfa
    LEFT JOIN 
        {{ ref('src_detailsouschampficheanalysevaleurproposeeficheanalyse') }} dscfavpfa ON dscfavpfa."idDetailSousChampFicheAnalyseValeurProposeeFicheAnalyse" = dfa."idDetailSousChampFicheAnalyseValeurProposeeFicheAnalyse"
    LEFT JOIN 
        {{ ref('src_souschampficheanalyse') }} scfa ON scfa."idSousChampFicheAnalyse" = dscfavpfa."idSousChampFicheAnalyse"
    LEFT JOIN 
        {{ ref('src_valeurproposeeficheanalyse') }} vpfa_s ON vpfa_s."idValeurProposeeFicheAnalyse" = dscfavpfa."idValeurProposeeFicheAnalyse"
    LEFT JOIN 
        {{ ref('src_typechamp') }} tc ON tc."idTypeChamp" = dscfavpfa."idTypeChamp"
    LEFT JOIN 
        {{ ref('src_detailchampficheanalysesouschampficheanalyse') }} dcfascfa ON dcfascfa."idSousChampFicheAnalyse" = scfa."idSousChampFicheAnalyse"
    INNER JOIN 
        {{ ref('src_champficheanalyse') }} cfa ON cfa."idChampFicheAnalyse" = dcfascfa."idChampFicheAnalyse"
    INNER JOIN 
        {{ ref('src_detailchampficheanalysevaleurproposeeficheanalyse') }} dcfavpfa ON dcfavpfa."idDetailChampFicheAnalyseValeurProposeeFicheAnalyse" = cfa."idChampFicheAnalyse"
    LEFT JOIN 
        {{ ref('src_valeurproposeeficheanalyse') }} vpfa_c ON vpfa_c."idValeurProposeeFicheAnalyse" = dcfavpfa."idValeurProposeeFicheAnalyse"
    LEFT JOIN 
        {{ ref('src_ficheanalyse') }} fa ON fa."idFicheAnalyse" = dcfavpfa."idFicheAnalyse"
)
SELECT * FROM dim_detailsficheanalyse
