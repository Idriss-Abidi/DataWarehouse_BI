WITH dim_laboratoire AS (
    SELECT
        lab."idLaboratoire",
        lab."abreviation",
        lab."ordre",
        lab."tarifOrganismeAdministratif",
        lab."tarifOrganismeCommercial",
        lab."desactivation",
        lab."disponibilite",
        lab."idService",
        s."abreviation" AS service,
        s."ordre" AS service_ordre,
        s."consommationPartielleBA" AS consommationPartielleBA
    FROM 
        {{ ref('src_laboratoire') }} lab
    LEFT JOIN 
        {{ ref('src_service') }} s ON s."idService" = lab."idService"
)
SELECT * FROM dim_laboratoire
