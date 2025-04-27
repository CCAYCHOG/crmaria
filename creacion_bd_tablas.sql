-- 1. Crear la base de datos
CREATE DATABASE crmaria;
GO

USE crmaria;
GO

-------------------------------------------------------------------------------
-- 2. Tabla de Usuarios
-------------------------------------------------------------------------------
CREATE TABLE dbo.Usuarios (
    UsuarioID           INT           IDENTITY(1,1) PRIMARY KEY,
    NombreUsuario       NVARCHAR(50)  NOT NULL UNIQUE,
    ContrasenaHash      NVARCHAR(255) NOT NULL,
    Nombre              NVARCHAR(50),
    Apellido            NVARCHAR(50),
    CorreoElectronico   NVARCHAR(100),
    Activo              BIT           NOT NULL DEFAULT(1),

    -- Campos de auditoría
    CreadoPor           INT           NULL,
    FechaCreacion       DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
    ModificadoPor       INT           NULL,
    FechaModificacion   DATETIME2     NULL,
    EliminadoPor        INT           NULL,
    FechaEliminacion    DATETIME2     NULL,
    Estado              BIT           NOT NULL DEFAULT(0),

    -- Relaciones de auditoría (se permiten NULL para el primer registro)
    CONSTRAINT FK_Usuarios_CreadoPor       FOREIGN KEY (CreadoPor)     REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT FK_Usuarios_ModificadoPor   FOREIGN KEY (ModificadoPor) REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT FK_Usuarios_EliminadoPor    FOREIGN KEY (EliminadoPor)  REFERENCES dbo.Usuarios(UsuarioID)
);
GO

-------------------------------------------------------------------------------
-- 3. Tabla de Cuentas
-------------------------------------------------------------------------------
CREATE TABLE dbo.Cuentas (
    CuentaID            INT           IDENTITY(1,1) PRIMARY KEY,
    NombreCuenta        NVARCHAR(100) NOT NULL,
    Industria           NVARCHAR(50),
    SitioWeb            NVARCHAR(100),
    Telefono            NVARCHAR(20),
    Direccion           NVARCHAR(200),
    CorreoElectronico   NVARCHAR(100),

    -- Campos de auditoría
    CreadoPor           INT           NOT NULL,
    FechaCreacion       DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
    ModificadoPor       INT           NULL,
    FechaModificacion   DATETIME2     NULL,
    EliminadoPor        INT           NULL,
    FechaEliminacion    DATETIME2     NULL,
    Estado              BIT           NOT NULL DEFAULT(0),

    -- Foráneas
    CONSTRAINT FK_Cuentas_CreadoPor       FOREIGN KEY (CreadoPor)     REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT FK_Cuentas_ModificadoPor   FOREIGN KEY (ModificadoPor) REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT FK_Cuentas_EliminadoPor    FOREIGN KEY (EliminadoPor)  REFERENCES dbo.Usuarios(UsuarioID)
);
GO

-------------------------------------------------------------------------------
-- 4. Tabla de Contactos
-------------------------------------------------------------------------------
CREATE TABLE dbo.Contactos (
    ContactoID          INT           IDENTITY(1,1) PRIMARY KEY,
    CuentaID            INT           NULL,
    Nombre              NVARCHAR(50)  NOT NULL,
    Apellido            NVARCHAR(50)  NOT NULL,
    CorreoElectronico   NVARCHAR(100),
    Telefono            NVARCHAR(20),
    Movil               NVARCHAR(20),

    -- Campos de auditoría
    CreadoPor           INT           NOT NULL,
    FechaCreacion       DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
    ModificadoPor       INT           NULL,
    FechaModificacion   DATETIME2     NULL,
    EliminadoPor        INT           NULL,
    FechaEliminacion    DATETIME2     NULL,
    Estado              BIT           NOT NULL DEFAULT(0),

    -- Foráneas
    CONSTRAINT FK_Contactos_Cuenta        FOREIGN KEY (CuentaID)      REFERENCES dbo.Cuentas(CuentaID),
    CONSTRAINT FK_Contactos_CreadoPor     FOREIGN KEY (CreadoPor)     REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT FK_Contactos_ModificadoPor FOREIGN KEY (ModificadoPor) REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT FK_Contactos_EliminadoPor  FOREIGN KEY (EliminadoPor)  REFERENCES dbo.Usuarios(UsuarioID)
);
GO

-------------------------------------------------------------------------------
-- 5. Tabla de Prospectos
-------------------------------------------------------------------------------
CREATE TABLE dbo.Prospectos (
    ProspectoID         INT           IDENTITY(1,1) PRIMARY KEY,
    Origen              NVARCHAR(50),
    Empresa             NVARCHAR(100),
    Nombre              NVARCHAR(50),
    Apellido            NVARCHAR(50),
    CorreoElectronico   NVARCHAR(100),
    Telefono            NVARCHAR(20),
    EstadoProspecto     NVARCHAR(50),

    -- Campos de auditoría
    CreadoPor           INT           NOT NULL,
    FechaCreacion       DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
    ModificadoPor       INT           NULL,
    FechaModificacion   DATETIME2     NULL,
    EliminadoPor        INT           NULL,
    FechaEliminacion    DATETIME2     NULL,
    Estado              BIT           NOT NULL DEFAULT(0),

    -- Foráneas
    CONSTRAINT FK_Prospectos_CreadoPor     FOREIGN KEY (CreadoPor)     REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT FK_Prospectos_ModificadoPor FOREIGN KEY (ModificadoPor) REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT FK_Prospectos_EliminadoPor  FOREIGN KEY (EliminadoPor)  REFERENCES dbo.Usuarios(UsuarioID)
);
GO

-------------------------------------------------------------------------------
-- 6. Tabla de Oportunidades
-------------------------------------------------------------------------------
CREATE TABLE dbo.Oportunidades (
    OportunidadID       INT           IDENTITY(1,1) PRIMARY KEY,
    CuentaID            INT           NOT NULL,
    ContactoID          INT           NULL,
    NombreOportunidad   NVARCHAR(100) NOT NULL,
    Etapa               NVARCHAR(50),
    Monto               DECIMAL(18,2),
    FechaCierre         DATE,

    -- Campos de auditoría
    CreadoPor           INT           NOT NULL,
    FechaCreacion       DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
    ModificadoPor       INT           NULL,
    FechaModificacion   DATETIME2     NULL,
    EliminadoPor        INT           NULL,
    FechaEliminacion    DATETIME2     NULL,
    Estado              BIT           NOT NULL DEFAULT(0),

    -- Foráneas
    CONSTRAINT FK_Oportunidades_Cuenta        FOREIGN KEY (CuentaID)      REFERENCES dbo.Cuentas(CuentaID),
    CONSTRAINT FK_Oportunidades_Contacto      FOREIGN KEY (ContactoID)    REFERENCES dbo.Contactos(ContactoID),
    CONSTRAINT FK_Oportunidades_CreadoPor     FOREIGN KEY (CreadoPor)     REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT FK_Oportunidades_ModificadoPor FOREIGN KEY (ModificadoPor) REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT FK_Oportunidades_EliminadoPor  FOREIGN KEY (EliminadoPor)  REFERENCES dbo.Usuarios(UsuarioID)
);
GO

-------------------------------------------------------------------------------
-- 7. Tabla de Actividades
-------------------------------------------------------------------------------
CREATE TABLE dbo.Actividades (
    ActividadID         INT           IDENTITY(1,1) PRIMARY KEY,
    OportunidadID       INT           NULL,
    ContactoID          INT           NULL,
    Asunto              NVARCHAR(100) NOT NULL,
    FechaActividad      DATETIME2     NOT NULL,
    Tipo                NVARCHAR(50),
    Descripcion         NVARCHAR(500),

    -- Campos de auditoría
    CreadoPor           INT           NOT NULL,
    FechaCreacion       DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
    ModificadoPor       INT           NULL,
    FechaModificacion   DATETIME2     NULL,
    EliminadoPor        INT           NULL,
    FechaEliminacion    DATETIME2     NULL,
    Estado              BIT           NOT NULL DEFAULT(0),

    -- Foráneas
    CONSTRAINT FK_Actividades_Oportunidad     FOREIGN KEY (OportunidadID) REFERENCES dbo.Oportunidades(OportunidadID),
    CONSTRAINT FK_Actividades_Contacto        FOREIGN KEY (ContactoID)    REFERENCES dbo.Contactos(ContactoID),
    CONSTRAINT FK_Actividades_CreadoPor       FOREIGN KEY (CreadoPor)     REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT FK_Actividades_ModificadoPor   FOREIGN KEY (ModificadoPor) REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT FK_Actividades_EliminadoPor    FOREIGN KEY (EliminadoPor)  REFERENCES dbo.Usuarios(UsuarioID)
);
GO