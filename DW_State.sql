USE USE [Database]
GO

SET ANSI_NULL ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dwo].[DW_Estados](

	[Estado_Key] [integer] NOT NULL,
	[Estado] [varchar](50) NULL
  CONSTRAINT [PK_DW_Estados] PRIMARY KEY CLUSTERED
  (
	[Estado_Key] ASC
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZA_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

-- Insert values for table

INSERT INTO [dwo].[DW_Estados](
							 [Estado_Key], 
							 [Estado]
						    )
VALUES  (0, 'PENDIENTE'),
	    (1, 'EN EJECUCION'),
		(2, 'FINALIZADO'),
		(6,'ERROR'),
		(7, 'CONTROL NEGATIVO'),
		(8, 'SIN NOVEDADES'),
		(9, 'DATOS NO DISPONIBLES'),
		(10,'SIN DATOS')
		
							