USE USE [Database]
GO

SET ANSI_NULL ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dwo].[sp_DW_Carga_Controles](  
												@proceso_Key bigint,
												@Control varchar(50),
												@Descripcion_Control varchar(150)
											   ) AS 
		
	
	INSERT INTO [dwo].[DW_Controles] (
										proceso_Key, 
										fecha,
										control,
										descripcion_control
									  )
	VALUES(
		   @proceso_Key,
		   GETDATE(),
		   @control,
		   @Descripcion_control
		   )

GO



-- SSIS - EVENT HANDLER - OnPreExecute

-- SQL Task:
-- Task Name: Registra Inicio.

-- Asignacion de parametros o parameter mapping: 
	-- User: PROCESO.
	-- System: SourceName.
	-- System: PackageName.

DECLARE @nProcesoKey BIGINT 
SET @nProcesoKey = ?

DECLARE @taskName varchar(100) = ?
DECLARE @packageName varchar(100) = ?  -- Not use for the moment.?

-- if task name not in this specific names even @TaskName execute SP.
IF @TaskName NOT IN ('CUENTA_PROCESOS','SELECCIONA PROCESO','ACTUALIZA DW_PROCESO','FIN DW_PROCESO', @packageName)
EXEC [dwo].[sp_DW_Carga_Controles]@nProcesoKey, @taskName,'Inicio'





-- SSIS - EVENT HANDLER - OnPostExecute

-- SQL Task:
-- Task Name: Registra Fin.

-- Asignacion de parametros o parameter mapping: 
	-- User: PROCESO.
	-- System: SourceName.
	-- System: PackageName.

DECLARE @nProcesoKey BIGINT 
SET @nProcesoKey = ?

DECLARE @taskName varchar(100) = ?
DECLARE @packageName varchar(100) = ?  -- Not use for the moment.

-- if task name not in this specific names even @TaskName execute SP.
IF @TaskName NOT IN ('CUENTA_PROCESOS','SELECCIONA PROCESO','ACTUALIZA DW_PROCESO','FIN DW_PROCESO', @packageName)
EXEC [dwo].[sp_DW_Carga_Controles]@nProcesoKey, @taskName,'Fin'