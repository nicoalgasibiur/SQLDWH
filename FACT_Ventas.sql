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

CREATE TABLE [DWO].[INT_DIM_Ventas](

	
	[FechaVenta][integer] NULL,
	[CodLibro][varchar](10) NULL,
	[Cantidad][smallint] NULL,
	[MontoVenta][decimal](21,2) NULL
	

)

GO


-- CARGAR TABLA STAGING

USE [DWHInt]

-- Vaciado
TRUNCATE TABLE [DWO].[INT_DIM_Ventas]

-- INSERCION

INSERT INTO [DWO].[INT_DIM_Libro] (   
									  [FechaVenta],
									  [CodLibro],
									  [Cantidad],
									  [MontoVenta]
								)
SELECT [FechaVenta],
	   [CodLibro],
	   [Cantidad],
	   [MontoVenta]
FROM [Source].[dbo].[Ventas]
WHERE FechaVenta >= ?

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

ALTER TABLE [dwo].[FACT_Ventas] WITH CHECK 
ADD CONSTRAINT [FK_DWVentas_FechaVenta_Key] FOREIGN KEY([Fecha_Key])
REFERENCES [dwo].[DW_Time](Fecha_Key)
GO

ALTER TABLE [dwo].[FACT_Ventas] WITH CHECK CONSTRAINT [FK_DWVentas_FechaVenta_Key]
GO

ALTER TABLE [dwo].[FACT_Ventas] WITH CHECK
ADD CONSTRAINT [FK_DWVentas_Libro_Key] FOREIGN KEY([Libro_Key])
REFERENCES [dwo].[DIM_Libro](Libro_Key)
GO

ALTER TABLE [dwo].[FACT_Ventas] CHECK CONSTRAINT [FK_DWVentas_Libro_Key]
GO

	




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
AND MODULO = 'OPE_DIM_Libros'

-- OPE: [EI, EP]
-- EI: Extraccion inicial: Extraccion previa a la capa STAGING o INTERFACE.
-- EP: Extraccion primaria: PROCESO ETL desde STAGING a DWH.


-- SQL TASK NAME: SELECCIONA PROCESO:
-- RESULSET: SINGLEROW. User::PROCESO.
-- PARAMETERS MAPPING: NO.
SELECT TOP 1 PROCESO_KEY AS PROCESO
FROM [DWO].[DW_PROCESO]
WHERE MODULO = 'OPEN_DIM_Libros'
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
 