WITH bonanalyse_data AS (
              SELECT DISTINCT
                  b."idBonAnalyse", 
                  b."numeroBA",
                  b."dateCreation", 
                  b."isActuel", 
                  b.active,
                  b."montantInitial",
                  b."idProfesseur",
                  b.professeur,
                  me.email,
                  me.cin,
                  me.pays,
                  me.faculte_ecole,
                  me.EtablissementUniversitaire,
                  b.statut ,
                  b.statut_confirmation
              FROM 
                  {{ ref('dim_bonanalyse') }} b
              INNER JOIN 
                  {{ ref('dim_professeur') }} me ON b."idProfesseur" = me."id"
                order by  b."dateCreation" 
          )
          SELECT * FROM bonanalyse_data