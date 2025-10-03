USE [db_chatbot]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[localsys_auth_ctrl](
	[systemid] [char](2) NOT NULL,
	[nik] [varchar](6) NULL,
	[userid] [varchar](25) NOT NULL,
	[password] [varchar](25) NULL,
	[access_ctrl] [char](1) NULL,
	[rights] [nvarchar](50) NULL,
	[status] [bit] NULL,
	[autologin] [bit] NULL,
	[mailsystem] [nvarchar](100) NULL,
	[pcname] [nvarchar](50) NULL,
	[upd_by] [varchar](25) NULL,
	[ent_dt] [datetime] NULL,
	[upd_dt] [datetime] NULL,
	[lastlogin_dt] [datetime] NULL,
	[recid] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_localsys_auth_ctrl] PRIMARY KEY CLUSTERED 
(
	[systemid] ASC,
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA_READ]
) ON [DATA_READ]
GO

ALTER TABLE [dbo].[localsys_auth_ctrl] ADD  CONSTRAINT [DF_localsys_auth_ctrl_rights]  DEFAULT (' ') FOR [rights]
GO

ALTER TABLE [dbo].[localsys_auth_ctrl] ADD  CONSTRAINT [DF_localsys_auth_ctrl_status]  DEFAULT ((0)) FOR [status]
GO

ALTER TABLE [dbo].[localsys_auth_ctrl] ADD  CONSTRAINT [DF_localsys_auth_ctrl_autologin]  DEFAULT ((0)) FOR [autologin]
GO


CREATE TABLE [dbo].[chatbot_user](
	[userid] [varchar](50) NOT NULL,
	[nik] [varchar](6) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[role] [char](1) NOT NULL,
	[is_email_confirmed] [char](1) NULL,
	[ent_by] [varchar](20) NOT NULL,
	[ent_dt] [datetime] NOT NULL,
	[upd_by] [varchar](20) NULL,
	[upd_dt] [datetime] NULL,

PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[meeting_mgnt_user] ADD  DEFAULT (getdate()) FOR [ent_dt]
GO

