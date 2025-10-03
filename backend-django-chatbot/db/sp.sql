CREATE PROCEDURE [dbo].[document_registration_user] 
    (@nik varchar(6), @user_id varchar(20), @email varchar(50), @password varchar(50))
AS
BEGIN
 
 
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF EXISTS (SELECT 1 FROM [dbo].[localsys_auth_ctrl] WHERE (nik = @nik OR userid = @user_id) and systemid='90')
        BEGIN
            RAISERROR('User with this NIK or User ID already exists in the system.', 16, 1);
            RETURN;
        END
 
        DECLARE @section_cd varchar(3);
        DECLARE @section_nm varchar(100);
        DECLARE @username varchar(100);
 
 
        SELECT 
            @username = a.Name,
            @section_cd = a.section,
            @section_nm = b.Sect_nm 
        FROM [SBILOCAL].[LOCALSYS].[dbo].[View_emp_mst] a 
        INNER JOIN [SBILOCAL].[LOCALSYS].[dbo].[View_hrd_section] b ON a.section = b.Sect_c
        WHERE nik = @nik;
 
        IF @username IS NULL
        BEGIN
            RAISERROR('No employee found with the provided NIK.', 16, 1);
            RETURN;
        END
 
        INSERT INTO [dbo].[localsys_auth_ctrl]
        (systemid, nik, userid, password, access_ctrl, status, autologin, mailsystem, pcname, upd_by, ent_dt)
        VALUES
        ('90', @nik, @user_id, @password, 'B', 1, 1, @email, 'SBILOCAL', 'SYSTEM', GETDATE());
 
        INSERT INTO [dbo].[is_document_user]
        (nik, user_id, user_name, email, section, role, ent_by, section_nm)
        VALUES
        (@nik, @user_id, @username, @email, @section_cd, 1, 'SYSTEM', @section_nm);
 
 
        DECLARE @token NVARCHAR(64) = CONVERT(NVARCHAR(64), 
            CONCAT(
                NEWID(), 
                REPLACE(CONVERT(NVARCHAR(36), NEWID()), '-', '')
            ));
        DECLARE @expiration_date DATETIME = DATEADD(HOUR, 24, GETDATE());
 
 
        INSERT INTO [dbo].[is_document_auth_token]
        (user_id, email, token, exp_date, ent_dt)
        VALUES
        (@user_id, @email, @token, @expiration_date, GETDATE());
 
 
        COMMIT TRANSACTION;
 
        SELECT @token AS token;
    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
 
		SET @ErrorMessage = ERROR_MESSAGE();
		SET @ErrorSeverity = ERROR_SEVERITY();
		SET @ErrorState = ERROR_STATE();
 
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
 
		  RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO
 