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
        {{ source('SC_App1', 'detailsficheanalyse') }} dfa
    LEFT JOIN 
        {{ source('SC_App1', 'detailsouschampficheanalysevaleurproposeeficheanalyse') }} dscfavpfa ON dscfavpfa."idDetailSousChampFicheAnalyseValeurProposeeFicheAnalyse" = dfa."idDetailSousChampFicheAnalyseValeurProposeeFicheAnalyse"
    LEFT JOIN 
        {{ source('SC_App1', 'souschampficheanalyse') }} scfa ON scfa."idSousChampFicheAnalyse" = dscfavpfa."idSousChampFicheAnalyse"
    LEFT JOIN 
        {{ source('SC_App1', 'valeurproposeeficheanalyse') }} vpfa_s ON vpfa_s."idValeurProposeeFicheAnalyse" = dscfavpfa."idValeurProposeeFicheAnalyse"
    LEFT JOIN 
        {{ source('SC_App1', 'typechamp') }} tc ON tc."idTypeChamp" = dscfavpfa."idTypeChamp"
    LEFT JOIN 
        {{ source('SC_App1', 'detailchampficheanalysesouschampficheanalyse') }} dcfascfa ON dcfascfa."idSousChampFicheAnalyse" = scfa."idSousChampFicheAnalyse"
    INNER JOIN 
        {{ source('SC_App1', 'champficheanalyse') }} cfa ON cfa."idChampFicheAnalyse" = dcfascfa."idChampFicheAnalyse"
    INNER JOIN 
        {{ source('SC_App1', 'detailchampficheanalysevaleurproposeeficheanalyse') }} dcfavpfa ON dcfavpfa."idDetailChampFicheAnalyseValeurProposeeFicheAnalyse" = cfa."idChampFicheAnalyse"
    LEFT JOIN 
        {{ source('SC_App1', 'valeurproposeeficheanalyse') }} vpfa_c ON vpfa_c."idValeurProposeeFicheAnalyse" = dcfavpfa."idValeurProposeeFicheAnalyse"
    LEFT JOIN 
        {{ source('SC_App1', 'ficheanalyse') }} fa ON fa."idFicheAnalyse" = dcfavpfa."idFicheAnalyse"
)
SELECT * FROM dim_detailsficheanalyse
