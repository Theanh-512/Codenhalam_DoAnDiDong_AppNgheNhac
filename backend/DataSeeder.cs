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

            var artistUser = new User
            {
                UserName = "son_tung_mtp",
                Email = "sontung@mtp.com",
                Role = "Artist"
            };

            var result = await userManager.CreateAsync(artistUser, "Artist@123");
            if (result.Succeeded)
            {
                var artist = new Artist
                {
                    UserId = artistUser.Id,
                    ArtistName = "Sơn Tùng M-TP",
                    Avatar = "https://avatar-ex-swe.nixcdn.com/artist/2021/01/21/e/8/f/1/1611210156976_500.jpg"
                };
                context.Artists.Add(artist);
                await context.SaveChangesAsync();

                var songs = new List<Song>
                {
                    new Song { Title = "Lạc Trôi", ArtistId = artist.Id, FileUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", CoverImage = "https://i.ytimg.com/vi/Llw9Q6akRo4/maxresdefault.jpg", Duration = 230, Genre = "V-Pop" },
                    new Song { Title = "Chúng Ta Của Hiện Tại", ArtistId = artist.Id, FileUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", CoverImage = "https://i.ytimg.com/vi/psZ1g9fM_Sg/maxresdefault.jpg", Duration = 300, Genre = "Pop" },
                    new Song { Title = "Nơi Này Có Anh", ArtistId = artist.Id, FileUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3", CoverImage = "https://i.ytimg.com/vi/FN7ALfpGxiI/maxresdefault.jpg", Duration = 280, Genre = "V-Pop" }
                };

                context.Songs.AddRange(songs);
                await context.SaveChangesAsync();
            }
        }
    }
}
