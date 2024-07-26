WITH dim_typeanalyse AS (
    SELECT
        ta."idTypeAnalyse",
        ta."prestation",
        ta."tarifOrganismeAdministratif",
        ta."tarifOrganismeCommercial",
        ta."intitule",
        ta."desactivation",
        ta."disponibilite",
        ta."idLaboratoire",
        lab."abreviation" AS laboratoire
    FROM 
        {{ ref('src_typeanalyse') }} ta
    LEFT JOIN 
        {{ ref('src_laboratoire') }} lab ON lab."idLaboratoire" = ta."idLaboratoire"
)
SELECT * FROM dim_typeanalyse
