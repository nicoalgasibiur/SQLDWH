--=================================================
-- DIMENSION LIBRO
--=================================================


--========================================
-- INTERFACE

USE [DWHInt]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DWO].[INT_FACTLESS_LibroAutor](

	[CodLibro][varchar](10) NULL,
	[CodAutor][varchar](10)NULL,
	[FechaAltaLibroAutor] [DATETIME] NULL,
	[FechaBajaLibroAutor] [DATETIME] NULL		

)

GO


-- CARGAR TABLA STAGING

USE [DWHInt]

-- Vaciado
TRUNCATE TABLE [DWO].[INT_FACTLESS_LibroAutor]

-- INSERCION

INSERT INTO [DWO].[INT_FACTLESS_LibroAutor] (   
											[CodLibro],
											[CodAutor],
											[FechaAltaLibroAutor],
											[FechaBajaLibroAutor]
											)
SELECT [libro],
	   ISNULL([Autor],'N/A')
	   [FechaAlta],
	   [FechaBaja]
-- Option 1.	   
FROM [Source].[dbo].[LibrosAutor] -- Contain the relation between an author and a book. 



-- Option 2. -- If the book don't have a author, we need to use this query, because we want all the records, 
-- even if the book don't have an author.

FROM [Source].[dbo].[Libros] L
LEFT JOIN [source].[dbo].[LibrosAutor] LA 
	ON L.CodLibro = LA.CodLibro



--========================================
-- DATA WAREHOUSE



USE [DWH]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DWO].[FACTLESS_LibroAutor](

	[Libro_Key][integer] NULL,
	[CodLibro][varchar](10) NULL
	[Autor_Key][integer] NULL,
	[CodAutor][varchar](10) NULL,
	[FechaAltaLibroAutor][datetime] NULL,
	[FechaBajaLibroAutor][]datetime] NULL
	

)

GO




--========================================
-- ACTUALIZACION.
--Update all no key fields 


UPDATE [dwo].[FACTLESS_LibroAutor]
SET [FechaAltaLibroAutor] = ILA.[FechaAltaLibroAutor]
	[FechaBajaLibroAutor] = ILA.[FechaBajaLibroAutor]
	[FechaBajaLibro] = L.[FechaBajaLibro]
FROM [DWHInt].[dwo].[INT_FACTLESS_LibroAutor] ILA
WHERE [DWO].[FACTLESS_LibroAutor].[CodLibro] = ILA.[CodLibro] 
AND   [DWO].[FACTLESS_LibroAutor].[CodAutor] = ILA.[CodAutor] 


--========================================
-- INSERCION.

INSERT INTO [DWO].[FACTLESS_LibroAutor] (   
									    [Libro_Key],
										[CodLibro],
										[Autor_Key],
										[CodAutor],
										[FechaAltaLibroAutor],
										[FechaBajaLibroAutor]
										)
SELECT L.[Libro_Key],
	   L.[CodLibro],
	   A.[Autor_Key],
	   A.[CodAutor],
	   ILA.[FechaAltaLibroAutor],
	   ILA.[FechaBajaLibroAutor]
	   
FROM [DWHInt].[dwo].[INT_FACTLESS_LibroAutor] ILA -- INTERFACE

LEFT JOIN [DWH].[dwo].[FACTLESS_LibroAutor] LA -- FACTLESS DWH
	ON LA.CodLibro = ILA.CodLibro
	AND LA.CodAutor = ILA.CodAutor
	 
LEFT JOIN [dwo].[DIM_Libro] L -- BOOK
	ON L.CodLibro = ILA.CodLibro
	
LEFT JOIN [dwo].[DIM_Autor] A -- AUTHOR
	ON A.CodAutor = ILA.CodAutor

WHERE LA.CodAutor IS NULL
	  LA.CodLibro IS NULL




--=================================================
-- ESQUEMA DE PROCESAMIENTO: DIMENSION LIBRO
--=================================================


-- VARIABLES SSIS:
-- CANT_PROCESOS. INTEGER
-- PROCESO. INTEGER


-- SQL TASK NAME: CUENTA PROCESOS 
-- RESULTSET: SINGLE ROW. User::CANT_PROCESOS
-- PARAMETERS MAPPING: NO.
SELECT COUNT(*) AS CANT_PROCESOS
FROM [DWO].[DW_PROCESOS]
WHERE ESTADO_KEY = 0 
AND MODULO = 'EP_FACTLESS_LibroAutor'

-- OPE: [EI, EP]
-- EI: Extraccion inicial: Extraccion previa a la capa STAGING o INTERFACE.
-- EP: Extraccion primaria: PROCESO ETL desde STAGING a DWH.


-- SQL TASK NAME: SELECCIONA PROCESO:
-- RESULSET: SINGLEROW. User::PROCESO.
-- PARAMETERS MAPPING: NO.
SELECT TOP 1 PROCESO_KEY AS PROCESO
FROM [DWO].[DW_PROCESO]
WHERE MODULO = 'EP_FACTLESS_LibroAutor'
AND ESTADO_KEY = 0

-- SQL TASK NAME: ACTUALIZA DW_PROCESO.
-- RESULSET: NO.
-- PARAMETERS MAPPING: User::PROCESO.
UPDATE [DWO].[DW_PROCESO]
SET ESTADO_KEY = 1
	FECHA_INICIO = GETDATE()
WHERE PROCESO_KEY = ?

-- SQL TASK NAME: FIN DW_PROCESO.
-- RESULSET: NO. 
-- PARAMETERS MAPPING: User::PROCESO.
UPDATE [DWO].[DW_PROCESO]
SET ESTADO_KEY = 2
	FECHA_FIN = GETDATE()
WHERE PROCESO_KEY = ?
 