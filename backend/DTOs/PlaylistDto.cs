using System.ComponentModel.DataAnnotations;

namespace MusicApp.API.DTOs
{
    public class PlaylistDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public string UserId { get; set; } = null!;
        public DateTime CreatedAt { get; set; }
        public int SongCount { get; set; }
    }

    public class CreatePlaylistDto
    {
        [Required]
        public string Name { get; set; } = null!;
    }

    public class AddSongToPlaylistDto
    {
        [Required]
        public int SongId { get; set; }
    }
}
