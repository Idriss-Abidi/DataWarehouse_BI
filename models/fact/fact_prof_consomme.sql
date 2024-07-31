WITH consumption_counts AS (
    SELECT
        ba."idProfesseur",
        fa."idBonAnalyse",
        COUNT(fa."idBonAnalyse") AS total_FA,
        SUM(CASE WHEN "isConsommee" = TRUE THEN 1 ELSE 0 END) AS consomme,
        SUM(CASE WHEN "isConsommee" = FALSE THEN 1 ELSE 0 END) AS nonconsomme,
        (SUM(CASE WHEN "isConsommee" = TRUE THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) AS pourcentage
    FROM 
        {{ ref('src_detailsficheanalyse') }} fa
    INNER JOIN 
        {{ ref('src_bonanalyse') }} ba ON ba."idBonAnalyse" = fa."idBonAnalyse"
    WHERE 
        fa."idBonAnalyse" IS NOT NULL
    GROUP BY 
        ba."idProfesseur",
        fa."idBonAnalyse"
)
SELECT 
    "idProfesseur",
    "idBonAnalyse",
    total_FA,
    consomme,
    nonconsomme,
    pourcentage
FROM 
    consumption_counts
