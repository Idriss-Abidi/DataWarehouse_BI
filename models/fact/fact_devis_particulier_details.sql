WITH devis_data AS (
              SELECT DISTINCT
                  d."idDevis",
                  d."numeroDevis", 
                  d."dateCreation",
                  d."active", 
                  d."montantInitial",
                  d."consomme",

                  d."idParticulier",
                  me.Particulier,
                  me."cin", 
                  me."email",
                  concat ( me.adresse, ' ', me.ville, ', ', me.pays) as adresse                 
              FROM 
                  {{ ref('dim_devis') }} d
              INNER JOIN 
                  {{ ref('dim_particulier') }} me ON d."idParticulier" = me."idMembreExterne"
              order by  d."dateCreation"
          )
          SELECT * FROM devis_data