SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

USE [MusicAppDb];
GO

-- 1. Create Artist User if not exists
DECLARE @UserId NVARCHAR(450) = N'artist-static-id-001';

IF NOT EXISTS (SELECT 1 FROM AspNetUsers WHERE UserName = 'son_tung_mtp')
BEGIN
    INSERT INTO AspNetUsers (Id, UserName, NormalizedUserName, Email, NormalizedEmail, EmailConfirmed, PasswordHash, SecurityStamp, ConcurrencyStamp, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEnabled, AccessFailedCount)
    VALUES (@UserId, 'son_tung_mtp', 'SON_TUNG_MTP', 'sontung@mtp.com', 'SONTUNG@MTP.COM', 1, 'AQAAAAEAACcQAAAAE...', NEWID(), NEWID(), 0, 0, 1, 0);
END
ELSE
BEGIN
    SELECT @UserId = Id FROM AspNetUsers WHERE UserName = 'son_tung_mtp';
END

-- 2. Create Artist Profile
IF NOT EXISTS (SELECT 1 FROM Artists WHERE UserId = @UserId)
BEGIN
    INSERT INTO Artists (UserId, ArtistName, Avatar)
    VALUES (@UserId, N'Sơn Tùng M-TP', 'https://avatar-ex-swe.nixcdn.com/artist/2021/01/21/e/8/f/1/1611210156976_500.jpg');
END

DECLARE @ArtistId INT = (SELECT Id FROM Artists WHERE UserId = @UserId);

-- 3. Add Sample Songs
IF NOT EXISTS (SELECT 1 FROM Songs WHERE Title = N'Lạc Trôi')
BEGIN
    INSERT INTO Songs (Title, ArtistId, FileUrl, CoverImage, Duration, CreatedAt)
    VALUES 
    (N'Lạc Trôi', @ArtistId, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', 'https://i.ytimg.com/vi/Llw9Q6akRo4/maxresdefault.jpg', 230, GETDATE()),
    (N'Chúng Ta Của Hiện Tại', @ArtistId, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3', 'https://i.ytimg.com/vi/psZ1g9fM_Sg/maxresdefault.jpg', 300, GETDATE()),
    (N'Nơi Này Có Anh', @ArtistId, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3', 'https://i.ytimg.com/vi/FN7ALfpGxiI/maxresdefault.jpg', 280, GETDATE());
END
GO
