WITH consumption_counts AS (
    SELECT
        ba."idParticulier",
        fa."idDevis",
        COUNT(fa."idDevis") AS total_FA,
        SUM(CASE WHEN "isConsommee" = TRUE THEN 1 ELSE 0 END) AS consomme,
        SUM(CASE WHEN "isConsommee" = FALSE THEN 1 ELSE 0 END) AS nonconsomme,
        (SUM(CASE WHEN "isConsommee" = TRUE THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) AS pourcentage
    FROM 
        {{ ref('src_detailsficheanalyse') }} fa
    INNER JOIN 
        {{ ref('src_devis') }} ba ON ba."idDevis" = fa."idDevis"
    WHERE 
        fa."idDevis" IS NOT NULL
    GROUP BY 
        ba."idParticulier",
        fa."idDevis"
)
SELECT 
    "idParticulier",
    "idDevis",
    total_FA,
    consomme,
    nonconsomme,
    pourcentage
FROM 
    consumption_counts
