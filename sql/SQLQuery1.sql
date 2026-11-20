use ContosoRetailDW

-- ============================================
-- PERGUNTA 1: Por qual canal vendemos mais?
-- ============================================

--Exploração das tabelas

SELECT TOP 10 * FROM FactSales
--channelKey
--SalesAmount

SELECT TOP 10 * FROM DimChannel
--ChannelKey
--ChannelName

--início da montagem da query com a resposta

SELECT TOP 10 *
FROM FactSales S
INNER JOIN DimChannel C ON S.channelKey = C.ChannelKey

SELECT
	S.ChannelKey,
	SUM(S.SalesAmount)
FROM FactSales S
INNER JOIN DimChannel C ON S.channelKey = C.ChannelKey
GROUP BY S.channelKey

SELECT
	S.ChannelKey AS 'CANAL DE VENDAS',
	ROUND(SUM(S.SalesAmount),2) AS 'VENDAS POR CANAL'
FROM FactSales S
INNER JOIN DimChannel C ON S.channelKey = C.ChannelKey
GROUP BY S.channelKey

SELECT
	C.ChannelName AS 'CANAL DE VENDAS',
	ROUND(SUM(S.SalesAmount),2) AS 'VENDAS POR CANAL'
FROM FactSales S
INNER JOIN DimChannel C ON S.channelKey = C.ChannelKey
GROUP BY C.ChannelName
ORDER BY [VENDAS POR CANAL] DESC

--validação

SELECT
	sum(SalesAmount)
FROM FactSales
--12413657608,8876

SELECT
	ISNULL(C.ChannelName, 'TOTAL') AS 'CANAL DE VENDAS', --Renomear o NULL da soma do canal de vendas
	SUM(S.SalesAmount) AS 'VENDAS POR CANAL'
FROM FactSales S
INNER JOIN DimChannel C ON S.channelKey = C.ChannelKey
GROUP BY ROLLUP (C.ChannelName) --ROLLUP cria uma linha extra com o total geral (NULL no nome do canal)
ORDER BY [VENDAS POR CANAL] ASC
--12413657608,8876


-- ============================================
-- PERGUNTA 2: Onde estamos perdendo com devoluções?
-- ============================================

--Exploração das tabelas

SELECT TOP 10 * FROM FactSales
--channelKey
--ReturnAmount

SELECT TOP 10 * FROM DimChannel
--ChannelKey
--ChannelName

SELECT
	C.ChannelName AS 'CANAL DE VENDAS',
	SUM(S.ReturnAmount) AS 'DEVOLUÇÕES'
FROM FactSales S
INNER JOIN DimChannel C ON S.channelKey = C.ChannelKey
GROUP BY C.ChannelName
ORDER BY DEVOLUÇÕES DESC

--Validação:

SELECT
	sum(ReturnAmount)
FROM FactSales
--156839375,868

SELECT
	ISNULL(C.ChannelName, 'TOTAL') AS 'CANAL DE VENDAS', --Renomear o NULL da soma do canal de vendas
	SUM(S.ReturnAmount) AS 'Devoluções'
FROM FactSales S
INNER JOIN DimChannel C ON S.channelKey = C.ChannelKey
GROUP BY ROLLUP (C.ChannelName) --ROLLUP cria uma linha extra com o total geral (NULL no nome do canal)
ORDER BY Devoluções ASC
--156839375,868

-- ============================================
-- PERGUNTA 3: Taxas de Devoluções
-- ============================================

--Exploração das tabelas

SELECT TOP 10 * FROM FactSales
--channelKey
--ReturnAmount

SELECT TOP 10 * FROM DimChannel
--ChannelKey
--ChannelName

SELECT 
	C.ChannelName AS 'NOME DO CANAL',
	SUM(S.ReturnAmount) / NULLIF(SUM(S.SalesAmount), 0) * 100 AS '% DE DEVOLUÇÕES'
FROM FactSales S
INNER JOIN DimChannel C ON S.channelKey = C.ChannelKey
GROUP BY C.ChannelName
ORDER BY [% DE DEVOLUÇÕES] DESC

--Resposta para o chefe:

/*
Chefe, o canal de vendas que mais vende e mais devolve é o Store. Em vendas ele é líder absoluto, consequentemente, líder de devoluções.
Porém se verificarmos os valores em percentuais, a diferença entre os quatro canais não é grande. 

Seguem abaixo as vendas divididas por canal:

Store		6.942.853.195,14
Online		2.677.599.035,07
Reseller	1.715.197.831,44
Catalog		1.078.007.547,23

Já para as devoluções, o ranking continua o mesmo, sendo o Store o mais alto.

Store		90.642.941,90
Online		32.983.261,28
Reseller	21.306.891,59
Catalog		11.906.281,08

Em porcentagem de devoluções, não encontrei valores muito diferentes:

Store		1,30%
Reseller	1,24%
Online		1,23%
Catalog		1,10%

Até sexta-feira eu te entrego um dashboard completo com esses valores para a sua apresentação.

*/

