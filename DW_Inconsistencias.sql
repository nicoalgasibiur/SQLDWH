USE USE [Database]
GO

SET ANSI_NULL ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dwo].[DW_Inconsistencias](

	[Proceso_Key] [integer] NOT NULL,
	[Fecha] [datetime] NULL,
	[Paso] [varchar](50) NULL,
	[Inconsistencia] [varchar](MAX) NULL
  CONSTRAINT [PK_DW_Lotes] PRIMARY KEY CLUSTERED
  (
	[Proceso_Key] ASC,
	[Fecha] ASC
	
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZA_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO


ALTER TABLE [dwo].[DW_Inconsistencias] WITH CHECK ADD CONSTRAINT [FK_DWProcesos_Inconsistencias] FOREIGN KEY([Proceso_Key])
REFERENCES [dwo].[DW_Procesos](Proceso_Key)
GO

ALTER TABLE [dwo].[DW_Inconsistencias] CHECK CONSTRAINT [FK_DWProcesos_Inconsistencias]
GO


							