USE [Database]
GO

SET ANSI_NULL ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dwo].[DW_Procesos](

	[Proceso_Key] [integer] IDENTITY(1,1) NOT NULL,
	[Estado_Key] [integer] NOT NULL,
	[Lote_Key] [integer] NOT NULL,
	[Modulo] [varchar](50) NULL,
	[Fecha_Desde] [datetime] NULL,
	[Fecha_Hasta] [datetime] NULL,
	[Fecha_Inicio] [datetime] NULL,
	[Fecha_Fin] [datetime] NULL,
  CONSTRAINT [PK_DW_Procesos] PRIMARY KEY CLUSTERED
  (
	[Proceso_Key] ASC
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZA_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMRARY]

GO

ALTER TABLE [dwo].[DW_PROCESOS] WITH CHECK ADD CONSTRAINT [FK_DWProcesos_Estados] FOREIGN KEY([Estado_Key])
REFERENCES [dwo].[DW_Estados](Estado_Key)
GO

ALTER TABLE [dwo].[DW_PROCESOS] CHECK CONSTRAINT [FK_DWProcesos_Estados]
GO

ALTER TABLE [dwo].[DW_PROCESOS] WITH CHECK ADD CONSTRAINT [FK_DWProcesos_Lotes] FOREIGN KEY([Lote_Key])
REFERENCES [dwo].[DW_Lote](Lote_Key)
GO

ALTER TABLE [dwo].[DW_PROCESOS] CHECK CONSTRAINT [FK_DWProcesos_Lotes]
GO

	