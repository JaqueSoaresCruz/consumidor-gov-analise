---===================================================================
--- Criando a tabela conforme as colunas do csv e ingestão dos dados:
---=================================================================== 

-- Criação da tabela com base nas colunas do CSV
 CREATE TABLE consumidor(
 id						 SERIAL PRIMARY KEY,	
 Regiao                  VARCHAR,           
 UF                      VARCHAR,           
 Cidade                  VARCHAR,           
 Sexo                    VARCHAR,           
 Faixa_Etaria            VARCHAR,           
 Data_Finalizacao        TIMESTAMP,
 Tempo_Resposta          INTEGER,         
 Nome_Fantasia           VARCHAR,           
 Segmento_Mercado        VARCHAR,           
 Area                    VARCHAR,           
 Assunto                 VARCHAR,           
 Grupo_Problema          VARCHAR,           
 Problema                VARCHAR,           
 Como_Comprou            VARCHAR,           
 Procurou_Empresa        VARCHAR,           
 Respondida              VARCHAR,           
 Situacao                VARCHAR,           
 Avaliacao_Reclamacao    VARCHAR,           
 Nota_Consumidor      	 INTEGER
);

-- Ingestão dos dados no formato CSV
 \copy consumidor (Regiao, UF, Cidade, Sexo, Faixa_Etaria, Data_Finalizacao, Tempo_Resposta, Nome_Fantasia, Segmento_Mercado,
 Area, Assunto, Grupo_Problema, Problema, Como_Comprou, Procurou_Empresa, Respondida, Situacao, Avaliacao_Reclamacao, Nota_Consumidor) 
 FROM 'caminho do arquivo dados_cansumidor_tratado.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', 
 ENCODING 'UTF8');
