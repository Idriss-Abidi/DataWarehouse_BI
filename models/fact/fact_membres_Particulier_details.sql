WITH fact_membres_Particulier_details AS (
              SELECT DISTINCT
                  pe."idMembreExterne", 
                  pe."nom_complet",
                  pe."email",
                  CASE
                  WHEN pe."idEtablissementNonUniversitaire" IS NOT NULL THEN 'NonUniversitaire'
                  WHEN pe."idEtablissementCaractereAdministratif" IS NOT NULL THEN 'CaractereAdministratif'
                  ELSE 'Particulier'
                  END AS DTYPE,
                  pe."idEtablissementNonUniversitaire",
                  pe.EtablissementNonUniversitaire, 
                  pe."idEtablissementCaractereAdministratif",
                  pe.EtablissementCaractereAdministratif
                --   pe."idEtablissementCaractereCommercial",
                --   pe.EtablissementCaractereCommercial
                 
              FROM 
                  {{ ref('dim_particulier_etab') }} pe
              
          )
          SELECT * FROM fact_membres_Particulier_details