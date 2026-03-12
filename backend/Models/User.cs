using Microsoft.AspNetCore.Identity;

namespace MusicApp.API.Models
{
    public class User : IdentityUser
    {
        public string? FullName { get; set; }
        public string Role { get; set; } = "User"; // User or Artist
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        // Navigation properties
        public virtual Artist? ArtistProfile { get; set; }
        public virtual ICollection<Favorite> Favorites { get; set; } = new List<Favorite>();
        public virtual ICollection<Playlist> Playlists { get; set; } = new List<Playlist>();
    }

    public class Artist
    {
        public int Id { get; set; }
        public string UserId { get; set; } = null!;
        public virtual User User { get; set; } = null!;
        public string ArtistName { get; set; } = null!;
        public string? Avatar { get; set; }
        public string? Bio { get; set; }
        
        public virtual ICollection<Song> Songs { get; set; } = new List<Song>();
    }
}
