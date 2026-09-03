-- ==========================================================
-- CASE: Por que instituições financeiras concentram 41,44% das reclamações?
-- ==========================================================
 
-- 1. VOLUME: Como as reclamações se distribuem entre os segmentos?
select  
    segmento_mercado,
    round(count(*) * 100.0 / (select count(*) from public.consumidor), 2) as volume_reclamacao
from public.consumidor
group by segmento_mercado
order by volume_reclamacao desc;
-- Achado: Instituições financeiras concentram 41,44% de todas as reclamações da base.


-- 2. TEMPO DE RESPOSTA: financeiro vs geral
select 
    segmento_mercado,
    avg(tempo_resposta) as media_tempo_resposta
from public.consumidor
group by segmento_mercado
order by media_tempo_resposta desc;
-- Achado: Média geral = 6,52 dias. Financeiro = 6,27 dias (financeiro responde um pouco mais rápido).
-- Piores segmentos demoram 8-9 dias. Bares/Restaurantes ficam nulos (sem reclamação).
 
 
-- 3. TAXA DE RESPOSTA: financeiro vs geral
select
    count(*) as total_reclamacao,
    count(case when respondida = 'S' then 1 end) as total_respondida,
    count(case when respondida = 'S' then 1 end) * 100.0 / count(*) as taxa
from public.consumidor
where segmento_mercado = 'Bancos, Financeiras e Administradoras de Cartão';
-- Achado: Financeiro = 94,6% | Geral = 94,5% (praticamente idêntico).
 
select
    count(*) as total_reclamacao,
    count(case when respondida = 'S' then 1 end) as total_respondida,
    count(case when respondida = 'S' then 1 end) * 100.0 / count(*) as taxa
from public.consumidor;
 
 
-- 4. NOTA MÉDIA DO CONSUMIDOR: financeiro vs geral
select
    count(*) as total_reclamacao,
    count(nota_consumidor) as qtd_avaliado, 
    avg(nota_consumidor) as media_avaliacao
from public.consumidor
where segmento_mercado = 'Bancos, Financeiras e Administradoras de Cartão';
-- Achado: Financeiro = 2,04 | Geral = 2,36 (financeiro pior).
 
select
    count(*) as total_reclamacao,
    count(nota_consumidor) as qtd_avaliado, 
    avg(nota_consumidor) as media_avaliacao
from public.consumidor;
 
 
-- 5. ÍNDICE DE RESOLUÇÃO: geral
select
    avaliacao_reclamacao,
    count(*) as total,
    count(*) * 100.0 / sum(count(*)) over () as percentual
from public.consumidor
group by avaliacao_reclamacao
order by total desc;
-- Achado geral: Não Avaliada = 68,63% (1.382.231) | Não Resolvida = 19,83% (399.416) | Resolvida = 11,54% (232.502).
-- Entre as avaliadas (Resolvida + Não Resolvida): 36,79% resolvida.
  
-- ÍNDICE DE RESOLUÇÃO: financeiro
select
    avaliacao_reclamacao,
    count(*) as total,
    count(*) * 100.0 / sum(count(*)) over () as percentual
from public.consumidor
where segmento_mercado = 'Bancos, Financeiras e Administradoras de Cartão'
group by avaliacao_reclamacao
order by total desc;
-- Achado financeiro: Não Avaliada = 74,18% (619.064) | Não Resolvida = 19,26% (160.703) | Resolvida = 5,57% (54.825).
-- Entre as avaliadas (Resolvida + Não Resolvida): 25,44% resolvida (vs. 36,79% geral — financeiro resolve significativamente menos).


-- 6. CAUSA RAIZ: motivo das reclamações no financeiro
select 
    grupo_problema,
    count(*) as total
from public.consumidor
where segmento_mercado = 'Bancos, Financeiras e Administradoras de Cartão'
group by grupo_problema
order by total desc;
-- Achado: "Cobrança / Contestação" domina com 603.333 (~72% do segmento).
