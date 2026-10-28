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
-- Demais segmentos: 58,56% (1.179.561), distribuídos entre 44 segmentos.


-- 2. TEMPO DE RESPOSTA
select 
    segmento_mercado,
    avg(tempo_resposta) as media_tempo_resposta
from public.consumidor
group by segmento_mercado
order by media_tempo_resposta desc;
-- Achado: Média geral = 6,52 dias. Financeiro = 6,27 dias (financeiro responde um pouco mais rápido).
-- Piores segmentos demoram 8-9 dias. Bares/Restaurantes ficam nulos (sem reclamação).


select
    avg(tempo_resposta) as media_tempo_resposta
from public.consumidor
where segmento_mercado is distinct from 'Bancos, Financeiras e Administradoras de Cartão';
-- Achado: Financeiro = 6,27 dias | Demais segmentos = 6,70 dias
-- (financeiro responde 0,43 dia mais rápido). Referência: base inteira = 6,52.


-- 3. TAXA DE RESPOSTA
select
    count(*) as total_reclamacao,
    count(case when respondida = 'S' then 1 end) as total_respondida,
    count(case when respondida = 'S' then 1 end) * 100.0 / count(*) as taxa
from public.consumidor
where segmento_mercado = 'Bancos, Financeiras e Administradoras de Cartão';
 
select
    count(*) as total_reclamacao,
    count(case when respondida = 'S' then 1 end) as total_respondida,
    count(case when respondida = 'S' then 1 end) * 100.0 / count(*) as taxa
from public.consumidor
where segmento_mercado is distinct from 'Bancos, Financeiras e Administradoras de Cartão';
-- Achado: Financeiro = 94,5% | Demais segmentos = 94,7% (praticamente idêntico).


-- 4. NOTA MÉDIA DO CONSUMIDOR
select
    count(*) as total_reclamacao,
    count(nota_consumidor) as qtd_avaliado, 
    avg(nota_consumidor) as media_avaliacao
from public.consumidor
where segmento_mercado = 'Bancos, Financeiras e Administradoras de Cartão';
 
select
    count(*) as total_reclamacao,
    count(nota_consumidor) as qtd_avaliado, 
    avg(nota_consumidor) as media_avaliacao
from public.consumidor
where segmento_mercado is distinct from 'Bancos, Financeiras e Administradoras de Cartão';
-- Achado: Financeiro = 2,04 | Demais segmentos = 2,52 (financeiro pior).


-- 5. ÍNDICE DE RESOLUÇÃO
select
    avaliacao_reclamacao,
    count(*) as total,
    count(*) * 100.0 / sum(count(*)) over () as percentual
from public.consumidor
where segmento_mercado is distinct from 'Bancos, Financeiras e Administradoras de Cartão'
group by avaliacao_reclamacao
order by total desc;
-- Achado demais segmentos: Não Avaliada = 64,70% (763.167) | Não Resolvida = 20,24% (238.713) | Resolvida = 15,06% (177.677).
-- (4 registros sem avaliação, 0,00%.)
-- Entre as avaliadas (Resolvida + Não Resolvida): 42,67% resolvida (vs. 25,44% no financeiro,
-- 17 pontos percentuais a menos).

select
    avaliacao_reclamacao,
    count(*) as total,
    count(*) * 100.0 / sum(count(*)) over () as percentual
from public.consumidor
where segmento_mercado = 'Bancos, Financeiras e Administradoras de Cartão'
group by avaliacao_reclamacao
order by total desc;
-- Achado financeiro: Não Avaliada = 74,18% (619.064) | Não Resolvida = 19,26% (160.703) | Resolvida = 6,57% (54.825).
-- Entre as avaliadas (Resolvida + Não Resolvida): 25,44% resolvida.


-- 6. CAUSA RAIZ: motivo das reclamações.
select 
    grupo_problema,
    count(*) as total,
	round(count(*) * 100.0 / sum(count(*)) over (), 2) as percentual
from public.consumidor
where segmento_mercado = 'Bancos, Financeiras e Administradoras de Cartão'
group by grupo_problema
order by total desc;
-- Achado: "Cobrança / Contestação" domina com 603.333 (72,29% do segmento).

select
    grupo_problema,
    count(*) as total,
    round(count(*) * 100.0 / sum(count(*)) over (), 2) as percentual
from public.consumidor
where segmento_mercado is distinct from 'Bancos, Financeiras e Administradoras de Cartão'
group by grupo_problema
order by total desc;
-- Achado demais segmentos: "Cobrança / Contestação" também lidera, mas com 491.700 (41,68%).