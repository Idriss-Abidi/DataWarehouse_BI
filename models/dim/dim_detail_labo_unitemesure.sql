WITH detail_laboratoire_unite_mesure AS (
    SELECT
        dlu."idDetailLaboratoireUniteMesure",
        dlu."idLaboratoire",
        lab."abreviation" AS laboratoire,
        dlu."idUniteMesure",
        um."abreviation" AS unitemesure
    FROM 
        {{ ref('src_detaillaboratoireunitemesure') }} dlu
    LEFT JOIN 
        {{ ref('src_laboratoire') }} lab ON lab."idLaboratoire" = dlu."idLaboratoire"
    LEFT JOIN 
        {{ ref('src_unitemesure') }} um ON um."idUniteMesure" = dlu."idUniteMesure"
)
SELECT * FROM detail_laboratoire_unite_mesure
