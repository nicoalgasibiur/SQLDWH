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

CREATE TABLE [DWO].[INT_FACT_Ventas](

	
	[FechaVenta][integer] NULL,
	[CodLibro][varchar](10) NULL,
	[Cantidad][smallint] NULL,
	[MontoVenta][decimal](21,2) NULL
	

)

GO


-- CARGAR TABLA STAGING

USE [DWHInt]

-- Vaciado
TRUNCATE TABLE [DWO].[INT_FACT_Ventas]

-- INSERCION
-- SQL TASK NAME: CARGA INT_FACT_Ventas 
-- RESULTSET: NO.
-- PARAMETERS MAPPING: User:: Fecha_Desde 
INSERT INTO [DWO].[INT_FACT_Ventas] (   
									  [FechaVenta],
									  [CodLibro],
									  [Cantidad],
									  [MontoVenta]
								)
SELECT [FechaVenta],
	   ISNULL([CodLibro],-999),
	   [Cantidad],
	   [MontoVenta]
FROM [Source].[dbo].[Ventas]
WHERE CAST(CONVERT(VARCHAR,FechaVenta,112) AS INTEGER) >= ?



--========================================
-- DATA WAREHOUSE


USE [DWH]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DWO].[FACT_Ventas](

	[FechaVenta_Key][INTEGER] NOT NULL,
	[Libro_Key][INTEGER] NOT NULL,
	[Cantidad] [INTEGER] NOT NULL,	
	[MontoVenta] [DECIMAL](21,2) NOT NULL	

)

GO


-- DEFAULT VALUES
ALTER TABLE [dwo].[FACT_Ventas] 
ADD DEFAULT ((19000101)) FOR [FechaVenta_Key]

ALTER TABLE [dwo].[FACT_Ventas] 
ADD DEFAULT ((-999)) FOR [Libro_Key]


-- FOREING KEYS
-- LIBROS AND TIME.

ALTER TABLE [dwo].[FACT_Ventas] WITH CHECK 
ADD CONSTRAINT [FK_DWVentas_FechaVenta_Key] FOREIGN KEY([Fecha_Key])
REFERENCES [dwo].[DIM_Time](Fecha_Key)
GO

ALTER TABLE [dwo].[FACT_Ventas] WITH CHECK CONSTRAINT [FK_DWVentas_FechaVenta_Key]
GO

ALTER TABLE [dwo].[FACT_Ventas] WITH CHECK
ADD CONSTRAINT [FK_DWVentas_Libro_Key] FOREIGN KEY([Libro_Key])
REFERENCES [dwo].[DIM_Libro](Libro_Key)
GO

ALTER TABLE [dwo].[FACT_Ventas] CHECK CONSTRAINT [FK_DWVentas_Libro_Key]
GO

	



-- BORRADO TABLA DWH

DELETE FROM [DWO].[FACT_Ventas] WHERE FechaVenta_Key >= ?

-- CARGA TABLA DWH

INSERT INTO [DWO].[FACT_Ventas] (   
									  [FechaVenta_Key],
									  [Libro_Key],
									  [Cantidad],
									  [MontoVenta]
								)
SELECT FV.[FechaVenta],
	   ISNULL(L.[Libro_Key],-999),
	   FV.[Cantidad],
	   FV.[MontoVenta]
FROM [dwo].[INT_FACT_Ventas] FV -- INTERFACE 
LEFT JOIN [DWO].[DIM_Libros] L -- DIMENSION
	ON FV.CodLibro = L.CodLibro 


--=================================================
-- ESQUEMA DE PROCESAMIENTO: FACT VENTAS
--=================================================

-- OPE: [EI, EP]
-- EI: Extraccion inicial: Extraccion previa a la capa STAGING o INTERFACE.
-- EP: Extraccion primaria: PROCESO ETL desde STAGING a DWH.


-- VARIABLES SSIS:
-- CANT_PROCESOS. INTEGER
-- PROCESO. INTEGER
-- FECHA_DESDE. STRING
-- FECHA_HASTA. STRING


-- SQL TASK NAME: CUENTA PROCESOS 
-- RESULTSET: SINGLE ROW. User::CANT_PROCESOS
-- PARAMETERS MAPPING: NO.
SELECT COUNT(*) AS CANT_PROCESOS
FROM [DWO].[DW_PROCESOS]
WHERE ESTADO_KEY = 0 
AND MODULO = 'EP_Fact_Ventas' -- The name of the package.



-- SQL TASK NAME: SELECCIONA PROCESO:
-- RESULSET: SINGLEROW. User::PROCESO. User:: Fecha_Desde. User:: Fecha_Hasta
-- PARAMETERS MAPPING: NO.

-- Look in the DW_PROCESO Table. If the field is null, use GETDATE with DATEADD.

SELECT TOP 1 PROCESO_KEY AS PROCESO,
			 ISNULL( CAST(CONVERT(VARCHAR,Fecha_Desde,112) AS INTEGER),CAST(CONVERT(VARCHAR,DATEADD(MONTH,-3,GETDATE()),112) AS INTEGER) Fecha_Desde,
			 NULL as Fecha_Hasta
FROM [DWO].[DW_PROCESO]
WHERE MODULO = 'EP_Fact_Ventas'
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
 