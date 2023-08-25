--===================================================================================
-- CONTENEDOR DIMENSIONES
-- PROGRAMA tp_Dim_Libro
--===================================================================================

DECLARE @Lote_Key INT,
	    @Cuenta INT

SELECT @Lote_Key = Lote_Key
FROM [dwo].[DW_Lotes] (NOLOCK)
WHERE Lote = 'PROYECTO Libreria'

SELECT @Cuenta = COUNT(Proceso_Key)
FROM [dwo].[DW_Procesos](NOLOCK)
WHERE Modulo = 'tp_Dim_Libro'
AND Estado_Key = 0

IF @Cuenta = 0

INSERT INTO [dwo].[DW_Procesos]
SELECT TMP.Estado_Key,
	   TMP.Lote_Key,
	   TMP.Modulo,
	   TMP.Fecha_Desde,
	   TMP.Fecha_Hasta,
	   TMP.Fecha_Inicio,
	   TMP.Fecha_Fin

FROM ( 
		SELECT DISTINCT 0 AS Estado_Key,
			   @Lote_Key AS Lote_Key,
			   'tp_Dim_Libro' AS Modulo,
			   NULL AS Fecha_Desde,
			   NULL AS Fecha_Hasta,
			   NULL AS Fecha_Inicio,
			   NULL AS Fecha_Hasta
	) AS TMP
LEFT JOIN [dwo].[DW_Procesos] PRO
	ON TMP.Estado_Key = PRO.Estado_Key 
	AND TMP.Lote_Key = PRO.Lote_Key
	AND TMP.Modulo = PRO.Modulo
WHERE PRO.Proceso_Key IS NULL


-- PROGRAMA tp_Dim_PSAL_Autor
DECLARE @Lote_Key INT,
	    @Cuenta INT

SELECT @Lote_Key = Lote_Key
FROM [dwo].[DW_Lotes] (NOLOCK)
WHERE Lote = 'PROYECTO Libreria'

SELECT @Cuenta = COUNT(Proceso_Key)
FROM [dwo].[DW_Procesos](NOLOCK)
WHERE Modulo = 'tp_Dim_Autor'
AND Estado_Key = 0

IF @Cuenta = 0

INSERT INTO [dwo].[DW_Procesos]
SELECT TMP.Estado_Key,
	   TMP.Lote_Key,
	   TMP.Modulo,
	   TMP.Fecha_Desde,
	   TMP.Fecha_Hasta,
	   TMP.Fecha_Inicio,
	   TMP.Fecha_Fin

FROM ( 
		SELECT DISTINCT 0 AS Estado_Key,
			   @Lote_Key AS Lote_Key,
			   'tp_Dim_Autor' AS Modulo,
			   NULL AS Fecha_Desde,
			   NULL AS Fecha_Hasta,
			   NULL AS Fecha_Inicio,
			   NULL AS Fecha_Hasta
	) AS TMP
LEFT JOIN [dwo].[DW_Procesos] PRO
	ON TMP.Estado_Key = PRO.Estado_Key 
	AND TMP.Lote_Key = PRO.Lote_Key
	AND TMP.Modulo = PRO.Modulo
WHERE PRO.Proceso_Key IS NULL


--===================================================================================
-- PROGRAMA tp_Factless_PSAL_LibroAutor
-- CONTENEDOR FACTLESS
--===================================================================================
-- PROGRAMA tp_Dim_LibroAutor
DECLARE @Lote_Key INT,
	    @Cuenta INT

SELECT @Lote_Key = Lote_Key
FROM [dwo].[DW_Lotes] (NOLOCK)
WHERE Lote = 'PROYECTO Libreria'

SELECT @Cuenta = COUNT(Proceso_Key)
FROM [dwo].[DW_Procesos](NOLOCK)
WHERE Modulo = 'tp_Factless_LibroAutor'
AND Estado_Key = 0

IF @Cuenta = 0

INSERT INTO [dwo].[DW_Procesos]
SELECT TMP.Estado_Key,
	   TMP.Lote_Key,
	   TMP.Modulo,
	   TMP.Fecha_Desde,
	   TMP.Fecha_Hasta,
	   TMP.Fecha_Inicio,
	   TMP.Fecha_Fin

FROM ( 
		SELECT DISTINCT 0 AS Estado_Key,
			   @Lote_Key AS Lote_Key,
			   'tp_Factless_LibroAutor' AS Modulo,
			   NULL AS Fecha_Desde,
			   NULL AS Fecha_Hasta,
			   NULL AS Fecha_Inicio,
			   NULL AS Fecha_Hasta
	) AS TMP
LEFT JOIN [dwo].[DW_Procesos] PRO
	ON TMP.Estado_Key = PRO.Estado_Key 
	AND TMP.Lote_Key = PRO.Lote_Key
	AND TMP.Modulo = PRO.Modulo
WHERE PRO.Proceso_Key IS NULL


-- PROGRAMA tp_Fact_Ventas
-- CONTENEDOR FACT
--===================================================================================
-- The default package runs X months backwards. It's name is tp_Fact_Ventas.
-- If required a special programation, set fecha_Desde and Fecha_Hasta with a value.
--===================================================================================

DECLARE @Lote_Key INT,
	    @Cuenta INT

SELECT @Lote_Key = Lote_Key
FROM [dwo].[DW_Lotes] (NOLOCK)
WHERE Lote = 'PROYECTO Libreria'

SELECT @Cuenta = COUNT(Proceso_Key)
FROM [dwo].[DW_Procesos](NOLOCK)
WHERE Modulo = 'tp_Fact_Ventas'
AND Estado_Key = 0

IF @Cuenta = 0

INSERT INTO [dwo].[DW_Procesos]
SELECT TMP.Estado_Key,
	   TMP.Lote_Key,
	   TMP.Modulo,
	   TMP.Fecha_Desde,
	   TMP.Fecha_Hasta,
	   TMP.Fecha_Inicio,
	   TMP.Fecha_Fin

FROM ( 
		SELECT DISTINCT 0 AS Estado_Key,
			   @Lote_Key AS Lote_Key,
			   'tp_Factless_Ventas' AS Modulo,
			   NULL AS Fecha_Desde,
			   NULL AS Fecha_Hasta,
			   NULL AS Fecha_Inicio,
			   NULL AS Fecha_Hasta
	) AS TMP
LEFT JOIN [dwo].[DW_Procesos] PRO
	ON TMP.Estado_Key = PRO.Estado_Key 
	AND TMP.Lote_Key = PRO.Lote_Key
	AND TMP.Modulo = PRO.Modulo
WHERE PRO.Proceso_Key IS NULL
