using System.ComponentModel.DataAnnotations;

namespace MusicApp.API.Models
{
    public class Song
    {
        public int Id { get; set; }
        [Required]
        public string Title { get; set; } = null!;
        public int ArtistId { get; set; }
        public virtual Artist Artist { get; set; } = null!;
        [Required]
        public string FileUrl { get; set; } = null!;
        public string? CoverImage { get; set; }
        public int Duration { get; set; } // In seconds
        public string Genre { get; set; } = "General";
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public virtual ICollection<Favorite> Favorites { get; set; } = new List<Favorite>();
        public virtual ICollection<PlaylistSong> PlaylistSongs { get; set; } = new List<PlaylistSong>();
    }

    public class Favorite
    {
        public int Id { get; set; }
        public string UserId { get; set; } = null!;
        public virtual User User { get; set; } = null!;
        public int SongId { get; set; }
        public virtual Song Song { get; set; } = null!;
    }

    public class Playlist
    {
        public int Id { get; set; }
        [Required]
        public string Name { get; set; } = null!;
        public string UserId { get; set; } = null!;
        public virtual User User { get; set; } = null!;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public virtual ICollection<PlaylistSong> PlaylistSongs { get; set; } = new List<PlaylistSong>();
    }

    public class PlaylistSong
    {
        public int PlaylistId { get; set; }
        public virtual Playlist Playlist { get; set; } = null!;
        public int SongId { get; set; }
        public virtual Song Song { get; set; } = null!;
    }
}
