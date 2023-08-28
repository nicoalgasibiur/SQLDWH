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

CREATE TABLE [DWO].[INT_DIM_Libro](

	[CodLibro][varchar](10) NULL
	[DescripcionLibro][varchar](150) NULL,
	[FechaAltaLibro] NULL,
	[FechaBajaLibro] NULL	

)

GO


-- CARGAR TABLA STAGING

USE [DWHInt]

-- Vaciado
TRUNCATE TABLE [DWO].[INT_DIM_Libro]

-- INSERCION

INSERT INTO [DWO].[INT_DIM_Libro] (   
									  [CodLibro],
									  [DescripcionLibro],
									  [FechaAltaLibro],
							          [FechaBajaLibro]
												)
SELECT [CodLibro],
	   [DescripcionLibro],
	   [FechaAltaLibro],
	   [FechaBajaLibro]
FROM [Source].[dbo].[Libros]


--========================================
-- DATA WAREHOUSE



USE [DWH]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DWO].[DIM_Libro](

	[Libro_Key][integer] IDENTITY(1,1) NOT NULL,
	[CodLibro][varchar](10) NULL
	[DescripcionLibro][varchar](150) NULL,
	[FechaAltaLibro] NULL,
	[FechaBajaLibro] NULL	
	CONSTRAINT [PK_DIM_Libro] PRIMARY KEY CLUSTERED
(
	[Libro_Key] ASC
)
)

GO



--========================================
-- DUMMY VALUE (VALOR POR DEFECTO)

DECLARE @vDefault_DIM_Libro INT,
	    @Cantidad INT
-- obtengo valor por defecto por medio de la funcion fn_dw_valores_default
-- Si no existe, tomo el valor por defecto -999.
SET @vDefault_DIM_Libro = (SELECT ISNULL(dwo.fn_dw_valores_default('DIM_Libro'),-999))

SET @Cantidad = (SELECT COUNT(*)
				 FROM [DWO].[DIM_Libros]
				 WHERE Libro_Key = @vDefault_DIM_Libro
					)

IF @Cantidad = 0
BEGIN

SET IDENTITY_INSERT [DWO].[DIM_Libros] ON

INSERT INTO [DWO].[DIM_Libros] (
								[Libro_Key],
								[CodLibro],
								[DescripcionLibro],
								[FechaAltaLibro],
								[FechaBajaLibro]
								)
VALUES( 
	@vDefault_DIM_Libro,
	'N/A',
	'No Aplica',
	NULL,
	NULL
	)


SET IDENTITY_INSERT [DWO].[DIM_Libros] OFF
END

END



--========================================
-- ACTUALIZACION.


UPDATE [dwo].[DIM_Libros]
SET [DescripcionLibro] = L.[DescripcionLibro]
	[FechaAltaLibro] = L.[FechaAltaLibro]
	[FechaBajaLibro] = L.[FechaBajaLibro]
FROM [DWHInt].[dwo].[INT_DIM_Libros] L
WHERE [DWO].[DIM_Libros].[CodLibro] = L.[CodLibro]


--========================================
-- INSERCION.

INSERT INTO [DWO].[DIM_Libro] (   
									  [CodLibro],
									  [DescripcionLibro],
									  [FechaAltaLibro],
							          [FechaBajaLibro]
												)
SELECT L.[CodLibro],
	   L.[DescripcionLibro],
	   L.[FechaAltaLibro],
	   L.[FechaBajaLibro]
FROM [DWHInt].[dwo].[INT_DIM_Libros] L
LEFT JOIN [dwo].[DIM_Libros] LIB
	ON L.CodLibro = LIB.CodLibro
WHERE L.CodLibro IS NULL




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
AND MODULO = 'EP_DIM_Libros'

-- OPE: [EI, EP]
-- EI: Extraccion inicial: Extraccion previa a la capa STAGING o INTERFACE.
-- EP: Extraccion primaria: PROCESO ETL desde STAGING a DWH.


-- SQL TASK NAME: SELECCIONA PROCESO:
-- RESULSET: SINGLEROW. User::PROCESO.
-- PARAMETERS MAPPING: NO.
SELECT TOP 1 PROCESO_KEY AS PROCESO
FROM [DWO].[DW_PROCESO]
WHERE MODULO = 'EP_DIM_Libros'
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
 