USE crmaria;
GO

-------------------------------------------------------------------------------
-- 1. Usuarios
-------------------------------------------------------------------------------

-- Insertar Usuario
CREATE PROCEDURE dbo.usp_Usuarios_Insertar
    @NombreUsuario       NVARCHAR(50),
    @ContrasenaHash      NVARCHAR(255),
    @Nombre              NVARCHAR(50)   = NULL,
    @Apellido            NVARCHAR(50)   = NULL,
    @CorreoElectronico   NVARCHAR(100)  = NULL,
    @Activo              BIT            = 1,
    @CreadoPor           INT,
    @NuevoUsuarioID      INT            OUTPUT,
    @Exito               BIT            OUTPUT,
    @Mensaje             NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO dbo.Usuarios
            (NombreUsuario, ContrasenaHash, Nombre, Apellido, CorreoElectronico, Activo,
             CreadoPor, FechaCreacion, Estado)
        VALUES
            (@NombreUsuario, @ContrasenaHash, @Nombre, @Apellido, @CorreoElectronico, @Activo,
             @CreadoPor, SYSUTCDATETIME(), 0);

        SET @NuevoUsuarioID = SCOPE_IDENTITY();
        SET @Exito = 1;
        SET @Mensaje = 'Usuario creado correctamente.';
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        SET @Exito = 0;
        SET @Mensaje = ERROR_MESSAGE();
    END CATCH
END
GO

-- Actualizar Usuario
CREATE PROCEDURE dbo.usp_Usuarios_Actualizar
    @UsuarioID           INT,
    @NombreUsuario       NVARCHAR(50),
    @Nombre              NVARCHAR(50)   = NULL,
    @Apellido            NVARCHAR(50)   = NULL,
    @CorreoElectronico   NVARCHAR(100)  = NULL,
    @Activo              BIT            = 1,
    @ModificadoPor       INT,
    @Exito               BIT            OUTPUT,
    @Mensaje             NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        UPDATE dbo.Usuarios
        SET
            NombreUsuario     = @NombreUsuario,
            Nombre            = @Nombre,
            Apellido          = @Apellido,
            CorreoElectronico = @CorreoElectronico,
            Activo            = @Activo,
            ModificadoPor     = @ModificadoPor,
            FechaModificacion = SYSUTCDATETIME()
        WHERE UsuarioID = @UsuarioID
          AND Estado = 0;

        IF @@ROWCOUNT = 0
        BEGIN
            ROLLBACK TRAN;
            SET @Exito = 0;
            SET @Mensaje = 'Usuario no encontrado o ya eliminado.';
            RETURN;
        END

        SET @Exito = 1;
        SET @Mensaje = 'Usuario actualizado correctamente.';
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        SET @Exito = 0;
        SET @Mensaje = ERROR_MESSAGE();
    END CATCH
END
GO

-- Eliminar Usuario (lógico)
CREATE PROCEDURE dbo.usp_Usuarios_Eliminar
    @UsuarioID           INT,
    @EliminadoPor        INT,
    @Exito               BIT            OUTPUT,
    @Mensaje             NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        UPDATE dbo.Usuarios
        SET
            Estado            = 1,
            EliminadoPor      = @EliminadoPor,
            FechaEliminacion  = SYSUTCDATETIME()
        WHERE UsuarioID = @UsuarioID
          AND Estado = 0;

        IF @@ROWCOUNT = 0
        BEGIN
            ROLLBACK TRAN;
            SET @Exito = 0;
            SET @Mensaje = 'Usuario no encontrado o ya estaba eliminado.';
            RETURN;
        END

        SET @Exito = 1;
        SET @Mensaje = 'Usuario eliminado lógicamente.';
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        SET @Exito = 0;
        SET @Mensaje = ERROR_MESSAGE();
    END CATCH
END
GO

-------------------------------------------------------------------------------
-- 2. Cuentas
-------------------------------------------------------------------------------

-- Insertar Cuenta
CREATE PROCEDURE dbo.usp_Cuentas_Insertar
    @NombreCuenta        NVARCHAR(100),
    @Industria           NVARCHAR(50)   = NULL,
    @SitioWeb            NVARCHAR(100)  = NULL,
    @Telefono            NVARCHAR(20)   = NULL,
    @Direccion           NVARCHAR(200)  = NULL,
    @CorreoElectronico   NVARCHAR(100)  = NULL,
    @CreadoPor           INT,
    @NuevaCuentaID       INT            OUTPUT,
    @Exito               BIT            OUTPUT,
    @Mensaje             NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO dbo.Cuentas
            (NombreCuenta, Industria, SitioWeb, Telefono, Direccion, CorreoElectronico,
             CreadoPor, FechaCreacion, Estado)
        VALUES
            (@NombreCuenta, @Industria, @SitioWeb, @Telefono, @Direccion, @CorreoElectronico,
             @CreadoPor, SYSUTCDATETIME(), 0);

        SET @NuevaCuentaID = SCOPE_IDENTITY();
        SET @Exito = 1;
        SET @Mensaje = 'Cuenta creada correctamente.';
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        SET @Exito = 0;
        SET @Mensaje = ERROR_MESSAGE();
    END CATCH
END
GO

-- Actualizar Cuenta
CREATE PROCEDURE dbo.usp_Cuentas_Actualizar
    @CuentaID            INT,
    @NombreCuenta        NVARCHAR(100),
    @Industria           NVARCHAR(50)   = NULL,
    @SitioWeb            NVARCHAR(100)  = NULL,
    @Telefono            NVARCHAR(20)   = NULL,
    @Direccion           NVARCHAR(200)  = NULL,
    @CorreoElectronico   NVARCHAR(100)  = NULL,
    @ModificadoPor       INT,
    @Exito               BIT            OUTPUT,
    @Mensaje             NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        UPDATE dbo.Cuentas
        SET
            NombreCuenta      = @NombreCuenta,
            Industria         = @
