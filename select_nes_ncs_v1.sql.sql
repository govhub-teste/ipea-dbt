with
empenhos_orgaos_1 as (
  select
      *,
      -- Uma série de extrações que servirão de identificadores 
      right(ne_ccor, 12) as ne,
      replace(
          (
              regexp_match(
                  ne_ccor_descricao,
                  '(FERENCIA|NUMERO|Nº|TED|CRICAO|TRANSF.|CAO|TRANSFERENCIA )(\s|^|-|)([0-9]{6}|1\w{5}|[0-9]{3}\.[0-9]{3})(\s|$|\.|,|-|\/)'
              )
          )[3],
          '.',
          ''
      ) as num_transf,
      regexp_substr(ne_ccor_descricao, '([0-9]{4}NC[0-9]+)') as nc
  from siafi.empenhos_tesouro
  where left(ne_ccor,6)= '113601'
),

empenhos_restantes as(
select * from empenhos_orgaos_1 where num_transf is null AND nc is null
),

empenhos_orgaos_2 as (
  select
    -- seleciona todas as colunas do órgãos 1, exceto nc e num_transf
      emissao_mes,emissao_dia,ne_ccor,ne_num_processo,ne_info_complementar,ne_ccor_descricao,doc_observacao,natureza_despesa,natureza_despesa_descricao,ne_ccor_favorecido,ne_ccor_favorecido_descricao,ne_ccor_ano_emissao,ptres,fonte_recursos_detalhada,fonte_recursos_detalhada_descricao,despesas_empenhadas,despesas_liquidadas,despesas_pagas,restos_a_pagar_inscritos,restos_a_pagar_pagos,dt_ingest,ne,
      replace(
          (regexp_match(
            ne_ccor_descricao,
            '.*(?:' ||
              -- TED e variações
              '(?:TED|TED[[:space:].-]*)' ||
              '|' ||
              -- SIAFI N∫
              '(?:SIAFI[[:space:]]+N∫)' ||
              '|' ||
              -- N∞
              '(?:N∞)' ||
            ')[[:space:].-]*' ||   -- possíveis espaços, pontos ou hífens entre prefixo e número
            '([A-Za-z0-9/]+)',     -- captura o código (alfanumérico e /)
            'i'
          ))[1],
          '.',
          ''
      ) as num_transf,
      regexp_substr(ne_ccor_descricao, '([0-9]{4}NC[0-9]+)') as nc
  from empenhos_restantes p
),

empenhos_teds as (
  select * from empenhos_orgaos_1 where num_transf is not null OR nc is not null
  UNION ALL
  select * from empenhos_orgaos_2 where num_transf is not null OR nc is not null
)

-- contagem de empenhos relacionados a teds após primeira regex
-- select count(*) from empenhos_orgaos_1 where num_transf is not null OR nc is not null

-- contagem de empenhos restantes após primeira regex
-- select count(*) from empenhos_restantes

-- contagem de empenhos relacionados a teds após as 2 regex
select * from empenhos_teds

-- contagem de empenhos restantes após as 2 regex
-- select count(*) from empenhos_orgaos_2 where num_transf is null AND nc is null

-- empenhos restantes do 364102
-- select * from empenhos_orgaos_2 where num_transf is null AND nc is null --AND ne_ccor_descricao not LIKE '% SEM VINCULO COM TED%'
-- 7327



-- 153065
-- 364102
-- 154421
-- 158143
-- 344041
-- 150002
-- 114702
-- 153114
-- 153045
-- 158092
-- 154503
-- 153164
-- 113601
-- 254420
-- 153056
-- 153115
-- 154041
-- 158128
-- 114601



