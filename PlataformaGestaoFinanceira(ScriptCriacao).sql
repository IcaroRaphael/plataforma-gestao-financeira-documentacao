USE master;
GO

DROP DATABASE PlataformaGestaoFinanceira;
GO

CREATE DATABASE PlataformaGestaoFinanceira;
GO

USE PlataformaGestaoFinanceira;
GO

-- Usuarios e Controle de Acesso
CREATE TABLE TipoConta(
	Id TINYINT IDENTITY NOT NULL,
	Nome VARCHAR(20) NOT NULL,

	CONSTRAINT PK_TipoConta PRIMARY KEY (Id)
);

CREATE TABLE Conta(
	Id INTEGER IDENTITY NOT NULL,
	Email VARCHAR(150) NOT NULL,
	Senha VARCHAR(150) NOT NULL,
	DataRegistro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DataUltimaAlteracao DATETIME NOT NULL,

	CONSTRAINT PK_Conta PRIMARY KEY (Id),
	CONSTRAINT UQ_Conta_Email UNIQUE (Email)
);
GO

CREATE TABLE PermissaoAcesso(
	Id TINYINT IDENTITY NOT NULL,
	Nome VARCHAR(20) NOT NULL,
	Descricao VARCHAR(500) NOT NULL,

	CONSTRAINT PK_PermissaoAcesso PRIMARY KEY (Id)
);
GO

CREATE TABLE Usuario(
	Id INTEGER IDENTITY NOT NULL,
	NomeCompleto VARCHAR(100) NOT NULL,
	DataRegistro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DataUltimaAlteracao DATETIME NOT NULL,
	IdConta INTEGER NOT NULL,
	IdPermissaoAcesso TINYINT NOT NULL,

	CONSTRAINT PK_Usuario PRIMARY KEY (Id),
	CONSTRAINT FK_Usuario_Conta FOREIGN KEY (IdConta) REFERENCES Conta (Id),
	CONSTRAINT FK_Usuario_PermissaoAcesso FOREIGN KEY (IdPermissaoAcesso) REFERENCES PermissaoAcesso (Id)
);
GO

-- Investimentos
CREATE TABLE StatusInvestimento(
	Id TINYINT IDENTITY NOT NULL,
	Nome VARCHAR(50) NOT NULL,

	CONSTRAINT PK_StatusInvestimento PRIMARY KEY (Id)
);
GO

CREATE TABLE TipoInvestimento(
	Id TINYINT IDENTITY NOT NULL,
	Nome VARCHAR(50),

	CONSTRAINT PK_TipoInvestimento PRIMARY KEY (Id)
);
GO

CREATE TABLE Investimento(
	Id INTEGER IDENTITY NOT NULL,
	Nome VARCHAR(100) NOT NULL,
	Descricao VARCHAR(500) NULL,
	ValorAtual DECIMAL(15,2) NOT NULL,
	DataInvestimento DATE NOT NULL,
	IdTipoInvestimento TINYINT NOT NULL,
	IdStatusInvestimento TINYINT NOT NULL,
	IdUsuario INTEGER NOT NULL,

	CONSTRAINT PK_Investimento PRIMARY KEY (Id),
	CONSTRAINT FK_Investimento_TipoInvestimento FOREIGN KEY (IdTipoInvestimento) REFERENCES TipoInvestimento (Id),
	CONSTRAINT FK_Investimento_StatusInvestimento FOREIGN KEY (IdStatusInvestimento) REFERENCES StatusInvestimento (Id),
	CONSTRAINT FK_Investimento_Usuario FOREIGN KEY (IdUsuario) REFERENCES Usuario (Id)
);
GO

CREATE TABLE HistoricoInvestimento(
	Id INTEGER IDENTITY NOT NULL,
	Valor DECIMAL(15,2) NOT NULL,
	DataAtualizacao DATE NOT NULL,
	IdInvestimento INTEGER NOT NULL,

	CONSTRAINT PK_HistoricoInvestimento PRIMARY KEY (Id),
	CONSTRAINT FK_HistoricoInvestimento_Investimento FOREIGN KEY (IdInvestimento) REFERENCES Investimento (Id)
);
GO

-- Transações e Contas Financeiras
CREATE TABLE InstituicaoFinanceira(
	Id INTEGER IDENTITY NOT NULL,
	Nome VARCHAR(50) NOT NULL,

	CONSTRAINT PK_InstituicaoFinanceira PRIMARY KEY (Id)
);
GO

CREATE TABLE TipoContaFinanceira(
	Id TINYINT IDENTITY NOT NULL,
	Nome VARCHAR(50) NOT NULL,

	CONSTRAINT PK_TipoContaFinanceira PRIMARY KEY (Id)
);
GO

CREATE TABLE StatusContaFinanceira(
	Id TINYINT IDENTITY NOT NULL,
	Nome VARCHAR(50) NOT NULL,

	CONSTRAINT PK_StatusContaFinanceira PRIMARY KEY (Id)
);
GO

CREATE TABLE ContaFinanceira(
	Id INTEGER IDENTITY NOT NULL,
	Nome VARCHAR(100) NOT NULL,
	Descricao VARCHAR(500) NULL,
	SaldoInicial DECIMAL(15,2) NOT NULL,
	SaldoAtual DECIMAL(15,2) NOT NULL,
	LimiteCredito DECIMAL(15,2) NULL,
	DiaFechamentoFatura TINYINT NULL,
	DiaVencimentoFatura TINYINT NULL,
	IdInstituicaoFinanceira INTEGER NOT NULL,
	IdTipoContaFinanceira TINYINT NOT NULL,
	IdStatusContaFinanceira TINYINT NOT NULL,

	CONSTRAINT PK_ContaFinanceira PRIMARY KEY (Id),
	CONSTRAINT FK_ContaFinanceira_InstituicaoFinanceira FOREIGN KEY (IdInstituicaoFinanceira) REFERENCES InstituicaoFinanceira (Id),
	CONSTRAINT FK_ContaFinanceira_TipoContaFinanceira FOREIGN KEY (IdTipoContaFinanceira) REFERENCES TipoContaFinanceira (Id),
	CONSTRAINT FK_ContaFinanceira_StatusContaFinanceira FOREIGN KEY (IdStatusContaFinanceira) REFERENCES StatusContaFinanceira (Id)
);
GO

CREATE TABLE UsuarioContaFinanceira(
	IdUsuario INTEGER NOT NULL,
	IdContaFinanceira INTEGER NOT NULL,

	CONSTRAINT PK_UsuarioContaFinanceiro PRIMARY KEY (IdUsuario, IdContaFinanceira),
	CONSTRAINT FK_UsuarioContaFinanceira_Usuario FOREIGN KEY (IdUsuario) REFERENCES Usuario (Id),
	CONSTRAINT FK_UsuarioContaFinanceira_ContaFinanceira FOREIGN KEY (IdContaFinanceira) REFERENCES ContaFinanceira (Id)
);
GO

CREATE TABLE TipoLancamento(
	Id TINYINT IDENTITY NOT NULL,
	Nome VARCHAR(20) NOT NULL,

	CONSTRAINT PK_TipoLancamento PRIMARY KEY (Id)
);
GO

CREATE TABLE TipoCategoria(
	Id TINYINT IDENTITY NOT NULL,
	Nome VARCHAR(20) NOT NULL

	CONSTRAINT PK_TipoCategoria PRIMARY KEY (Id)
);
GO

CREATE TABLE Categoria(
	Id INTEGER IDENTITY NOT NULL,
	Nome VARCHAR(100) NOT NULL,
	IdUsuario INTEGER NULL,
	IdTipoCategoria TINYINT NOT NULL,

	CONSTRAINT PK_Categoria PRIMARY KEY (Id),
	CONSTRAINT FK_Categoria_Usuario FOREIGN KEY (IdUsuario) REFERENCES Usuario (Id),
	CONSTRAINT FK_Categoria_TipoCategoria FOREIGN KEY (IdTipoCategoria) REFERENCES TipoCategoria (Id)
);
GO

CREATE TABLE Lancamento(
	Id INTEGER IDENTITY NOT NULL,
	Descricao VARCHAR(500) NULL,
	Valor DECIMAL(15,2) NOT NULL,
	DataLancamento DATETIME NOT NULL,
	IdContaFinanceira INTEGER NOT NULL,
	IdUsuario INTEGER NOT NULL,
	IdCategoria INTEGER NOT NULL,
	IdTipoLancamento TINYINT NOT NULL,

	CONSTRAINT PK_Lancamento PRIMARY KEY (Id),
	CONSTRAINT FK_Lancamento_ContaFinanceira FOREIGN KEY (IdContaFinanceira) REFERENCES ContaFinanceira (Id),
	CONSTRAINT FK_Lancamento_Usuario FOREIGN KEY (IdUsuario) REFERENCES Usuario (Id),
	CONSTRAINT FK_Lancamento_Categoria FOREIGN KEY (IdCategoria) REFERENCES Categoria (Id),
	CONSTRAINT FK_Lancamento_TipoLancamento FOREIGN KEY (IdTipoLancamento) REFERENCES TipoLancamento (Id)
);
GO

-- Orçamento e Metas
CREATE TABLE StatusMetaFinanceira(
	Id TINYINT IDENTITY NOT NULL,
	Nome VARCHAR(50) NOT NULL,

	CONSTRAINT PK_StatusMetaFinanceira PRIMARY KEY (Id)
);
GO

CREATE TABLE MetaFinanceira(
	Id INTEGER IDENTITY NOT NULL,
	Nome VARCHAR(100) NOT NULL,
	Descricao VARCHAR(500) NULL,
	ValorAlvo DECIMAL(15,2) NOT NULL,
	ValorAtual DECIMAL(15,2) NOT NULL,
	DataAlvo DATE NULL,
	IdStatusMetaFinanceira TINYINT NOT NULL,

	CONSTRAINT PK_MetaFinanceira PRIMARY KEY (Id),
	CONSTRAINT FK_MetaFinanceira_StatusMetaFinanceira FOREIGN KEY (IdStatusMetaFinanceira) REFERENCES StatusMetaFinanceira (Id)
);
GO

CREATE TABLE UsuarioMetaFinanceira(
	IdUsuario INTEGER NOT NULL,
	IdMetaFinanceira INTEGER NOT NULL,

	CONSTRAINT PK_UsuarioMetaFinanceira PRIMARY KEY (IdUsuario, IdMetaFinanceira),
	CONSTRAINT FK_UsuarioMetaFinanceira_Usuario FOREIGN KEY (IdUsuario) REFERENCES Usuario (Id),
	CONSTRAINT FK_UsuarioMetaFinanceira_MetaFinanceira FOREIGN KEY (IdMetaFinanceira) REFERENCES MetaFinanceira (Id)
);
GO

CREATE TABLE OrcamentoFinanceiro(
	Id INTEGER IDENTITY NOT NULL,
	Nome VARCHAR(100) NOT NULL,
	Descricao VARCHAR(500) NULL,
	ValorEstimado DECIMAL(15,2) NOT NULL,
	ValorGasto DECIMAL(15,2) NULL,
	Mes TINYINT NULL,
	Ano SMALLINT NULL,
	IdCategoria INTEGER NOT NULL,

	CONSTRAINT PK_OrcamentoFinanceiro PRIMARY KEY (Id),
	CONSTRAINT FK_OrcamentoFinanceiro FOREIGN KEY (IdCategoria) REFERENCES Categoria (Id)
);
GO

CREATE TABLE UsuarioOrcamentoFinanceiro(
	IdUsuario INTEGER NOT NULL,
	IdOrcamentoFinanceiro INTEGER NOT NULL,

	CONSTRAINT PK_UsuarioOrcamentoFinanceiro PRIMARY KEY (IdUsuario, IdOrcamentoFinanceiro),
	CONSTRAINT FK_UsuarioOrcamentoFinanceiro_Usuario FOREIGN KEY (IdUsuario) REFERENCES Usuario (Id),
	CONSTRAINT FK_UsuarioOrcamentoFinanceiro_OrcamentoFinanceiro FOREIGN KEY (IdOrcamentoFinanceiro) REFERENCES OrcamentoFinanceiro (Id)
);
GO
