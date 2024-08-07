WITH bonanalyse_data AS (
              SELECT DISTINCT
                  b."idBonAnalyse", 
                  b."numeroBA",
                  b."dateCreation",
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
                  b.statut_confirmation,
                  
                  b.laboratoire,
                  b.unitemesure,
                  b.typeAnalyse,
                  b.typeAnalyse_unitemesure
                --   dtu."valeur"
              FROM 
                  {{ ref('dim_bonanalyse') }} b
              INNER JOIN 
                  {{ ref('dim_professeur') }} me ON b."idProfesseur" = me."id"
                order by  b."dateCreation" 
              
          )
          SELECT * FROM bonanalyse_data
          