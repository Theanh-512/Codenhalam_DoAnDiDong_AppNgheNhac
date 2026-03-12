using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace MusicApp.API.DTOs
{
    public class SongDto
    {
        public int Id { get; set; }
        public string Title { get; set; } = null!;
        public int ArtistId { get; set; }
        public string ArtistName { get; set; } = null!;
        public string FileUrl { get; set; } = null!;
        public string? CoverImage { get; set; }
        public int Duration { get; set; }
        public string Genre { get; set; } = null!;
        public DateTime CreatedAt { get; set; }
        public bool IsFavorite { get; set; }
    }

    public class UploadSongDto
    {
        [Required]
        public string Title { get; set; } = null!;
        [Required]
        public IFormFile MusicFile { get; set; } = null!;
        public IFormFile? CoverImage { get; set; }
        public string Genre { get; set; } = "General";
    }
}
