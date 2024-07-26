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
                  me."email"

                  -- d.laboratoire,
                --   dlu."idUniteMesure",
                  -- d.unitemesure,
                --   dtu."idTypeAnalyse",
                  -- d.typeAnalyse,
                --   dtu."idUniteMesure",
                  -- d.typeAnalyse_unitemesure
                --   dtu."valeur"             
              FROM 
                  {{ ref('dim_devis') }} d
              INNER JOIN 
                  {{ ref('dim_particulier') }} me ON d."idParticulier" = me."idMembreExterne"
              
            -- where active=TRUE 
            order by  d."dateCreation"

          )
          SELECT * FROM devis_data