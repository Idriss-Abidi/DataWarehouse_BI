WITH fact_membres_details AS (
    SELECT DISTINCT
        pe."idMembreExterne" AS id, 
        pe."nom_complet",
        pe."email",
        CASE
            WHEN pe."idEtablissementNonUniversitaire" IS NOT NULL THEN 'NonUniversitaire'
            WHEN pe."idEtablissementCaractereAdministratif" IS NOT NULL THEN 'CaractereAdministratif'
            ELSE 'Particulier'
        END AS DTYPE,
        pe.EtablissementNonUniversitaire, 
        pe.EtablissementCaractereAdministratif,
        NULL AS faculte_ecole,  -- Placeholder for columns that don't exist in this table
        NULL AS EtablissementUniversitaire  -- Placeholder for columns that don't exist in this table
    FROM 
        {{ ref('dim_particulier_etab') }} pe

    UNION ALL

    SELECT DISTINCT
        pe."id", 
        pe."Professeur" AS nom_complet,
        pe."email",
        'Professeur' AS DTYPE,
        NULL AS EtablissementNonUniversitaire,  -- Placeholder for columns that don't exist in this table
        NULL AS EtablissementCaractereAdministratif,  -- Placeholder for columns that don't exist in this table
        pe.faculte_ecole,
        pe.EtablissementUniversitaire
    FROM 
        {{ ref('dim_professeur') }} pe
)
SELECT * 
FROM fact_membres_details
