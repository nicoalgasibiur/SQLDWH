USE USE [Database]
GO

SET ANSI_NULL ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dwo].[sp_DW_Carga_Inconsistencia](  @proceso_Key bigint,
													  @step varchar(50),
													  @inconsistencia varchar(150)
													) AS 
	-- The event handler take the process ID , the step and update the process ID in 6 (Error).
	UPDATE [dwo].[DW_Procesos]
	SET ESTADO_KEY = 6 
	WHERE PROCESO_KEY = @proceso_Key
	
	INSERT INTO [dwo].[DW_Inconsistencias] (
											proceso_Key, 
											fecha,
											paso,
											inconsistencia
											)
	VALUES(
		   @proceso_Key,
		   GETDATE(),
		   @step,
		   @inconsistencia
		   )

GO



-- SSIS - EVENT HANDLER - On Error

-- SQL Task:
-- Task Name: Registra Error.

-- Asignacion de parametros o parameter mapping: 
	-- User: PROCESO.
	-- System: SourceName.
	-- System: PackageName.
	-- System: ErrorDescription

DECLARE @nProcesoKey BIGINT 
SET @nProcesoKey = ?

DECLARE @taskName varchar(100) = ?
DECLARE @packageName varchar(100) = ?  -- Not use for the moment.
DECLARE @Error varchar(max) = ?

-- if task name not in this specific names even @TaskName execute SP.
IF @TaskName NOT IN ('CUENTA_PROCESOS','SELECCIONA PROCESO','ACTUALIZA DW_PROCESO','FIN DW_PROCESO', @TaskName)
EXEC [dwo].[sp_DW_Carga_Inconsistencia]@nProcesoKey, @taskName, @Error