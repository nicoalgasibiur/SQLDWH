USE USE [Database]
GO

SET ANSI_NULL ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dwo].[DW_Lotes](

	[Lote_Key] [integer] NOT NULL,
	[Lote] [varchar](50) NULL
  CONSTRAINT [PK_DW_Lotes] PRIMARY KEY CLUSTERED
  (
	[Lote_Key] ASC
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZA_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

-- Insert values for table

INSERT INTO [dwo].[DW_Lote](
							 [Lote_Key], 
							 [Lote]
						    )
VALUES  (1, 'PROYECTO Libreria'),
	    (2, 'PROYECTO B'),
		(3, 'PROYECTO C'),
		(4,'AREA A'),
		(5, 'AREA B')
		
							