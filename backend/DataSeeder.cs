using Microsoft.AspNetCore.Identity;
using MusicApp.API.Data;
using MusicApp.API.Models;
using Microsoft.EntityFrameworkCore;

namespace MusicApp.API
{
    public class DataSeeder
    {
        public static async Task SeedAsync(AppDbContext context, UserManager<User> userManager)
        {
            if (await context.Songs.AnyAsync()) return;

            // 1. Create Artists
            var artistsData = new List<(string username, string email, string artistName, string avatar)>
            {
                ("son_tung_mtp", "sontung@mtp.com", "Sơn Tùng M-TP", "https://avatar-ex-swe.nixcdn.com/artist/2021/01/21/e/8/f/1/1611210156976_500.jpg"),
                ("den_vau", "denvau@rap.com", "Đen Vâu", "https://avatar-ex-swe.nixcdn.com/artist/2020/09/22/e/4/b/5/1600745582236_500.jpg"),
                ("hoang_thuy_linh", "htl@pop.com", "Hoàng Thùy Linh", "https://avatar-ex-swe.nixcdn.com/artist/2019/10/22/d/a/a/c/1571731557088_500.jpg"),
                ("thinh_suy", "thinhsuy@indie.com", "Thịnh Suy", "https://avatar-ex-swe.nixcdn.com/artist/2019/07/26/5/a/2/b/1564111303273_500.jpg"),
                ("chillies", "chillies@band.com", "Chillies", "https://avatar-ex-swe.nixcdn.com/artist/2021/03/17/7/4/1/b/1615967008781_500.jpg"),
                ("jack_j97", "jack@mtp.com", "Jack - J97", "https://avatar-ex-swe.nixcdn.com/artist/2021/10/01/9/3/3/0/1633083391740_500.jpg"),
                ("mck", "mck@rap.com", "MCK", "https://avatar-ex-swe.nixcdn.com/artist/2020/11/04/b/0/b/4/1604475510006_500.jpg"),
                ("tlinh", "tlinh@rap.com", "tlinh", "https://avatar-ex-swe.nixcdn.com/artist/2020/11/17/8/c/0/d/1605587747864_500.jpg"),
                ("low_g", "lowg@rap.com", "Low G", "https://avatar-ex-swe.nixcdn.com/artist/2021/04/16/a/0/2/8/1618583488210_500.jpg"),
                ("mono", "mono@pop.com", "MONO", "https://avatar-ex-swe.nixcdn.com/artist/2022/08/18/7/e/9/f/1660795493136_500.jpg")
            };

            var createdArtists = new List<Artist>();

            foreach (var artistInfo in artistsData)
            {
                var user = new User { UserName = artistInfo.username, Email = artistInfo.email, Role = "Artist" };
                var result = await userManager.CreateAsync(user, "Artist@123");
                if (result.Succeeded)
                {
                    var artist = new Artist
                    {
                        UserId = user.Id,
                        ArtistName = artistInfo.artistName,
                        Avatar = artistInfo.avatar
                    };
                    context.Artists.Add(artist);
                    createdArtists.Add(artist);
                }
            }
            await context.SaveChangesAsync();

            // 2. Generate Hundreds of Songs
            var genres = new[] { "V-Pop", "Pop", "Rock", "Indie", "Jazz", "EDM", "Podcast", "Acoustic" };
            var baseMp3Url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-"; // 1 to 16 available
            var baseCoverUrl = "https://picsum.photos/seed/";

            var allSongs = new List<Song>();
            var random = new Random();

            for (int i = 1; i <= 200; i++)
            {
                var artist = createdArtists[random.Next(createdArtists.Count)];
                var genre = genres[random.Next(genres.Length)];
                var songIdx = (i % 16) + 1; // SoundHelix has 1-16

                allSongs.Add(new Song
                {
                    Title = $"Bài hát số {i} - {genre}",
                    ArtistId = artist.Id,
                    Genre = genre,
                    FileUrl = $"{baseMp3Url}{songIdx}.mp3",
                    CoverImage = $"{baseCoverUrl}song{i}/400/400",
                    Duration = random.Next(180, 360),
                    CreatedAt = DateTime.UtcNow.AddDays(-random.Next(0, 365))
                });
            }

            context.Songs.AddRange(allSongs);
            await context.SaveChangesAsync();
        }
    }
}
