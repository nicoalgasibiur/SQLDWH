USE USE [Database]
GO

SET ANSI_NULL ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dwo].[DW_Controles](

	[Proceso_Key] [integer] NOT NULL,
	[Fecha] [datetime] NULL,
	[Control] [varchar](100) NULL,
	[Descripcion_Control] [varchar](150) NULL
	
) ON [PRIMARY]
GO


ALTER TABLE [dwo].[DW_Controles] WITH CHECK ADD CONSTRAINT [FK_DWProcesos_Controles] FOREIGN KEY([Proceso_Key])
REFERENCES [dwo].[DW_Procesos](Proceso_Key)
GO



							