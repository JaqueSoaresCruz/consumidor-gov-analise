# 📊 Análise de Reclamações — Consumidor.gov

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-336791?style=for-the-badge&logo=database&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

Análise exploratória de reclamações registradas no **Consumidor.gov.br**, com o objetivo de identificar padrões de volume, resposta, resolução e percepção dos consumidores entre diferentes segmentos de empresas.

O projeto utiliza **Python (Pandas)** para preparação dos dados e **PostgreSQL + SQL** para armazenamento e análise.

> **Status:** análise em SQL concluída | Dashboard em Power BI concluído

---

## 📊 Dashboard

![Dashboard Power BI](images/dashboard_consumidor_gov.png)

O dashboard interativo foi construído no Power BI, permitindo comparar o segmento financeiro com demais segmentos em volume, tempo de resposta, taxa de resolução e categoria de problema.

---

## 🎯 Objetivo

Transformar os dados de reclamações em indicadores que permitam comparar o desempenho do segmento financeiro com os demais, respondendo perguntas como:

1. Quais segmentos possuem maior participação no volume total de reclamações?
2. O segmento com maior volume também apresenta um bom índice de resolução?
3. Existe diferença entre taxa/tempo de resposta e efetividade da resolução?
4. Quais segmentos apresentam maior tempo médio de resposta?
5. Como a percepção dos consumidores varia entre os segmentos?

Essas perguntas orientaram as consultas SQL, evitando uma análise baseada apenas em estatísticas descritivas.

---

## 📅 Dados analisados

* **Fonte:** [Consumidor.gov.br — Dados Abertos](https://www.consumidor.gov.br)
* **Período:** janeiro a junho de 2026
* **Volume:** 2,01 milhões de reclamações (2.014.153 registros tratados)

---

## 🛠️ Tecnologias utilizadas

| Tecnologia          | Utilização                                                    |
| ------------------- | ------------------------------------------------------------- |
| **Python (Pandas)** | Tratamento e preparação dos dados                             |
| **PostgreSQL**      | Armazenamento dos dados                                       |
| **SQL**             | Exploração, agregação e análise dos dados                     |
| **Power BI**        | Visualização e dashboard                                      |

---

## 🔄 Metodologia

1. **Coleta:** dados obtidos da base pública do Consumidor.gov.br.
2. **Preparação:** tratamento com Pandas — leitura, checagem de tipos, tratamento de nulos e padronização das colunas ([`notebooks/preparacao_dados.ipynb`](notebooks/preparacao_dados.ipynb)).
3. **Armazenamento:** carga no PostgreSQL via `\copy` 
([`sql/criacao_tabela.sql`](sql/criacao_tabela.sql)).
4. **Conexão:** validação da carga e consulta via VS Code, usando SQLAlchemy e psycopg2 (ver seção 6 no notebook).
5. **Análise exploratória:** consultas SQL para investigar volume, participação por segmento, taxa de resposta, índice de resolução, tempo médio de resposta e avaliação dos consumidores ([`sql/analise_consumidor_gov.sql`](sql/analise_consumidor_gov.sql)).
6. **Views:** as consultas foram consolidadas em views no PostgreSQL, calculando cada métrica por segmento e por grupo (Financeiro e demais segmentos), o que reduz repetição e facilita a manutenção ([`sql/views_consumidor_gov.sql`](sql/views_consumidor_gov.sql)).

---

## ▶️ Como reproduzir

```bash

# 1. Clone o repositório
git clone https://github.com/JaqueSoaresCruz/consumidor-gov-analise.git
cd consumidor-gov-analise

# 2. Crie um ambiente virtual e instale as dependências
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt

# 3. Crie um banco PostgreSQL e configure a conexão
# (edite as credenciais no notebook ou em um arquivo .env)

# 4. Rode o notebook de preparação dos dados
jupyter notebook notebooks/preparacao_dados.ipynb

# 5. Crie a tabela e importe os dados (o \copy exige o cliente psql)
psql -U seu_usuario -d seu_banco -f sql/criacao_tabela.sql

# 6. Rode as análises
psql -U seu_usuario -d seu_banco -f sql/analise_consumidor_gov.sql

# 7. Crie as views
psql -U seu_usuario -d seu_banco -f sql/views_consumidor_gov.sql

```

> O arquivo `data/dados_consumidor.gov.csv` não está incluso no repositório por tamanho. Baixe a base diretamente em [dados.gov.br](https://dados.gov.br) e coloque na pasta `data/`.

---

## 🔎 Principais resultados

> **Como a comparação foi feita:** o segmento financeiro (Bancos, Financeiras e Administradoras de Cartão) é comparado com os **demais segmentos**, isto é, com a base sem o financeiro. Como ele representa 41,44% de todas as reclamações, compará-lo com a base inteira faria o grupo de comparação incluir o próprio segmento e esconderia parte da diferença.


## 1. Volume de reclamações

| Grupo                | Reclamações | % do total |
| -------------------- | ----------: | ---------: |
| **Financeiro**       |     834.592 |     41,44% |
| **Demais segmentos** |   1.179.561 |     58,56% |

## 2. Tempo médio de resposta

| Grupo                     |  Tempo médio de resposta |
| ------------------------- | -----------------------: |
| **Financeiro**            |                6,27 dias |
| **Demais segmentos**      |                6,70 dias |

> Tempo médio de resposta = média dos valores da coluna `Tempo Resposta`, disponibilizada na base original do Consumidor.gov.br, considerando apenas reclamações respondidas (a base não traz uma data de abertura para cálculo manual do intervalo).

O financeiro responde, em média, 0,43 dia mais rápido que os demais segmentos, uma diferença pequena. Alguns segmentos chegam a 8–9 dias de tempo médio.

## 3. Taxa de resposta

| Grupo                     | Taxa de resposta   |
| ------------------------- | -----------------: |
| **Financeiro**            |              94,5% |
| **Demais segmentos**      |              94,7% |

> Taxa de resposta = percentual de reclamações que receberam resposta da empresa (campo `Respondida = S`) sobre o total de reclamações do grupo.

As taxas são praticamente equivalentes, a diferença de 0,2 ponto percentual não é relevante na prática.

## 4. Índice de resolução

| Avaliação                           | Financeiro | Demais segmentos |
| ----------------------------------- | ---------: | ---------------: |
| Não avaliada                        |     74,18% |           64,70% |
| Não resolvida                       |     19,26% |           20,24% |
| Resolvida                           |      6,57% |           15,06% |
| **% resolvida entre as avaliadas**  | **25,44%** |       **42,67%** |

> Índice de resolução = percentual de reclamações marcadas como "Resolvida" (campo `Avaliação Reclamação`), calculado sobre o total de reclamações e, na última linha, apenas sobre as que foram efetivamente avaliadas pelo consumidor (excluindo "Não avaliada").

O financeiro tem menos reclamações avaliadas e, entre as avaliadas, resolve proporcionalmente menos — uma diferença de 17 pontos percentuais.

## 5. Avaliação dos consumidores

| Grupo               | Nota média |
| --------------      | ---------: |
| **Financeiro**      |       2,04 |
| **Demais segmentos**|       2,52 |   

> Nota média = média das notas atribuídas pelo consumidor (campo `Nota do Consumidor`), considerando apenas reclamações avaliadas.

## 6. Principais categorias de problema

| Grupo de problema            | Financeiro | Demais segmentos |
| ---------------------------- | ---------: | ---------------: |
| **Cobrança / Contestação**   | **72,29%** |       **41,68%** |
| Atendimento / SAC            |     10,13% |           11,11% |
| Contrato / Oferta            |      7,73% |           12,17% |
| Dados Pessoais e Privacidade |      5,37% |           10,71% |
| Vício de Qualidade           |      3,63% |           14,80% |
| Informação                   |      0,67% |            2,51% |
| Entrega do Produto           |      0,12% |            6,13% |
| Saúde e Segurança            |      0,05% |            0,88% |

**"Cobrança / Contestação"** é o principal grupo de problema nos dois lados, mas concentra 72% das reclamações do financeiro (603.333) contra 42% nos demais segmentos.

---

## 🧠 Interpretação

O segmento financeiro concentra **41,44% do volume total**, mas seu **tempo e taxa de resposta são semelhantes aos dos demais segmentos** (o tempo é até um pouco menor). A diferença aparece depois da resposta: menor efetividade na resolução (25,44% vs. 42,67%) e pior percepção do consumidor (nota 2,04 vs. 2,52).

> **Principal insight:** o segmento financeiro responde em ritmo e proporção semelhantes aos demais segmentos (e até um pouco mais rápido), mas apresenta menor efetividade na resolução e pior percepção dos consumidores. O problema não está na velocidade de resposta, mas na qualidade da solução oferecida.

> **Limitação:** a nota e a resolução consideram apenas as reclamações avaliadas pelo consumidor (cerca de 31% da base: 25,8% no financeiro e 35,3% nos demais segmentos). Os resultados refletem a percepção de quem avaliou. Além disso, os "demais segmentos" reúnem 44 segmentos distintos, ponderados pelo volume de cada um, então a comparação é com a média deles e não com cada um individualmente.

A concentração de 72% das reclamações do segmento em "Cobrança / Contestação" é bem superior à dos demais segmentos (42%), mas não é possível aprofundar as causas com base apenas nos dados públicos disponíveis.

---

## 📂 Estrutura do projeto

```text
consumidor-gov-analise/  
├── data/
│   └── dados_consumidor.gov.csv
│
├── images/
│   └── dashboard_consumidor_gov.png
│
├── notebooks/
│   └── preparacao_dados.ipynb
│
├── sql/
│   ├── criacao_tabela.sql
│   ├── analise_consumidor_gov.sql
│   └── views_consumidor_gov.sql
│
├── README.md
└── requirements.txt
```

---

## 🚀 Etapas realizadas

* [x] Conectar VS Code ao PostgreSQL
* [x] Criar views no PostgreSQL
* [x] Conectar Power BI ao PostgreSQL


---

## 📌 Conclusão

O projeto percorre um fluxo completo de análise de dados — preparação, armazenamento em PostgreSQL e exploração via SQL — sobre uma base pública de grande volume. Mais do que estatísticas descritivas, buscou responder perguntas de negócio e identificar diferenças reais de desempenho entre o segmento financeiro e os demais.

O principal achado foi o contraste entre volume, resposta e efetividade da resolução no segmento financeiro. O projeto conta com dashboard interativo em Power BI, disponível na seção acima.

---

## 📚 Fonte dos dados

[Consumidor.gov.br — Dados Abertos](https://www.consumidor.gov.br)

## 👤 Autor

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/jaqueline-soares-da-cruz) · [![Gmail](https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:jaqueline.dacruz6789@gmail.com)