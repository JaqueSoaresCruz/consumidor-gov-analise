-- ==========================================================
-- Views com as métricas por segmento e por grupo.
-- Consolidam as consultas de analise_consumidor_gov.sql: cada métrica é calculada uma vez, em vez de uma query para cada comparação.
-- Estrutura: a CTE "base" traz só as colunas usadas (e cria o rótulo GERAL X grupo); o select de baixo calcula as métricas e faz 
-- comparação principal: Financeiro vs. Demais segmentos.
-- ==========================================================

-- 1. KPIs por segmento (uma linha por segmento + GERAL)
-- Observação: cada reclamação aparece duas vezes (no segmento e no GERAL).
-- Não somar o GERAL com os segmentos.
create or replace view public.vw_kpi_segmento as
with base as (
    select segmento_mercado, tempo_resposta, respondida,
           nota_consumidor, avaliacao_reclamacao
    from public.consumidor
    union all
    select 'GERAL', tempo_resposta, respondida,
           nota_consumidor, avaliacao_reclamacao
    from public.consumidor
)
select
    segmento_mercado,
    count(*) as total_reclamacao,
    round(count(*) * 100.0 / (select count(*) from public.consumidor), 2) as pct_volume,
    round(avg(tempo_resposta), 2) as media_tempo_resposta,
    round(count(*) filter (where respondida = 'S') * 100.0 / count(*), 2) as taxa_resposta,
    count(nota_consumidor) as qtd_avaliado,
    round(avg(nota_consumidor), 2) as media_nota,
    round(count(*) filter (where avaliacao_reclamacao = 'Resolvida') * 100.0
        / nullif(count(*) filter (where avaliacao_reclamacao in ('Resolvida', 'Não Resolvida')), 0)
    , 2) as taxa_resolucao_avaliadas
from base
group by segmento_mercado;

-- Exemplo de uso:
select * from public.vw_kpi_segmento
where segmento_mercado in ('GERAL', 'Bancos, Financeiras e Administradoras de Cartão');


-- 2. KPIs por grupo: Financeiro vs. Demais segmentos
-- Aqui cada reclamação aparece uma única vez (ou é financeiro, ou é demais),
-- então os dois grupos somam a base inteira.
create or replace view public.vw_kpi_grupo as
with base as (
    select
        case when segmento_mercado = 'Bancos, Financeiras e Administradoras de Cartão'
             then 'Financeiro'
             else 'Demais segmentos'
        end as grupo,
        tempo_resposta, respondida, nota_consumidor, avaliacao_reclamacao
    from public.consumidor
)
select
    grupo,
    count(*) as total_reclamacao,
    round(count(*) * 100.0 / sum(count(*)) over (), 2) as pct_volume,
    round(avg(tempo_resposta), 2) as media_tempo_resposta,
    round(count(*) filter (where respondida = 'S') * 100.0 / count(*), 2) as taxa_resposta,
    count(nota_consumidor) as qtd_avaliado,
    round(avg(nota_consumidor), 2) as media_nota,
    round(count(*) filter (where avaliacao_reclamacao = 'Não Avaliada')  * 100.0 / count(*), 2) as pct_nao_avaliada,
    round(count(*) filter (where avaliacao_reclamacao = 'Não Resolvida') * 100.0 / count(*), 2) as pct_nao_resolvida,
    round(count(*) filter (where avaliacao_reclamacao = 'Resolvida')     * 100.0 / count(*), 2) as pct_resolvida,
    round(count(*) filter (where avaliacao_reclamacao = 'Resolvida') * 100.0
        / nullif(count(*) filter (where avaliacao_reclamacao in ('Resolvida', 'Não Resolvida')), 0)
    , 2) as taxa_resolucao_avaliadas
from base
group by grupo;

-- Exemplo de uso:
select * from public.vw_kpi_grupo;


-- 3. Causa raiz (grupo de problema) por grupo
create or replace view public.vw_causa_raiz_grupo as
with base as (
    select
        case when segmento_mercado = 'Bancos, Financeiras e Administradoras de Cartão'
             then 'Financeiro'
             else 'Demais segmentos'
        end as grupo,
        grupo_problema
    from public.consumidor
)
select
    grupo,
    grupo_problema,
    count(*) as total,
    round(count(*) * 100.0 / sum(count(*)) over (partition by grupo), 2) as percentual
from base
group by grupo, grupo_problema;

-- Exemplo de uso:
select * from public.vw_causa_raiz_grupo order by grupo, total desc;
