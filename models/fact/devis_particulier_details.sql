WITH devis_data AS (
              SELECT DISTINCT
                  d."idDevis",
                  d."dateCreation", 
                  d."montantInitial", 
                  d."numeroDevis", 
                  d."idParticulier",
                  d."consomme",
                  d."active",
                  me."nom", 
                  me."prenom", 
                  me."cin", 
                  me."email",
                  concat(me.nom, ' ', me.prenom, ' - ', me.cin) as nom_complet
                  
              FROM 
                  {{ source('SC_App1', 'devis') }} d
              INNER JOIN 
                  {{ source('SC_App1', 'membreexterne') }} me ON d."idParticulier" = me."idMembreExterne"
              WHERE 
                  d."idParticulier" IS NOT NULL 
          )
          SELECT * FROM devis_data