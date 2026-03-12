using System.ComponentModel.DataAnnotations;

namespace MusicApp.API.DTOs
{
    public class RegisterDto
    {
        [Required]
        public string Username { get; set; } = null!;
        [Required]
        [EmailAddress]
        public string Email { get; set; } = null!;
        [Required]
        [MinLength(6)]
        public string Password { get; set; } = null!;
        public string? FullName { get; set; }
        public string Role { get; set; } = "User"; // User or Artist
        public string? ArtistName { get; set; } // If role is Artist
    }

    public class LoginDto
    {
        [Required]
        public string Username { get; set; } = null!;
        [Required]
        public string Password { get; set; } = null!;
    }

    public class AuthResponseDto
    {
        public bool IsSuccess { get; set; }
        public string? Message { get; set; }
        public string? Token { get; set; }
        public string? Username { get; set; }
        public string? Role { get; set; }
        public string? Email { get; set; }
    }
}
