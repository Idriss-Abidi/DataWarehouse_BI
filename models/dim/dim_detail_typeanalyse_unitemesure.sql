WITH detail_type_analyse_unite_mesure AS (
    SELECT
        dtu."idDetailTypeAnalyseUniteMesure",
        dtu."idTypeAnalyse",
        ta."prestation",
        dtu."idUniteMesure",
        um."abreviation"
    FROM 
        {{ ref('src_detailtypeanalyseunitemesure') }} dtu
    LEFT JOIN 
        {{ ref('src_typeanalyse') }} ta ON ta."idTypeAnalyse" = dtu."idTypeAnalyse"
    LEFT JOIN 
        {{ ref('src_unitemesure') }} um ON um."idUniteMesure" = dtu."idUniteMesure"
)
SELECT * FROM detail_type_analyse_unite_mesure
