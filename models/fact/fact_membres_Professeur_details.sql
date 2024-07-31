WITH fact_membres_Particulier_details AS (
              SELECT DISTINCT
                  pe."id", 
                  pe."Professeur",
                  pe."email",
                  'Professeur' AS DTYPE,
                  pe.faculte_ecole,
                  pe.EtablissementUniversitaire
              FROM 
                  {{ ref('dim_professeur') }} pe
              
          )
          SELECT * FROM fact_membres_Particulier_details