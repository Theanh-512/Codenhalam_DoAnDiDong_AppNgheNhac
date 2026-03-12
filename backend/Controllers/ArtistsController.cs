using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MusicApp.API.Data;
using MusicApp.API.DTOs;
using System.Security.Claims;

namespace MusicApp.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ArtistsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ArtistsController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetArtists()
        {
            var artists = await _context.Artists
                .Select(a => new
                {
                    a.Id,
                    a.ArtistName,
                    a.Avatar,
                    a.Bio,
                    SongCount = a.Songs.Count
                }).ToListAsync();

            return Ok(artists);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetArtist(int id)
        {
            var artist = await _context.Artists
                .Where(a => a.Id == id)
                .Select(a => new
                {
                    a.Id,
                    a.ArtistName,
                    a.Avatar,
                    a.Bio,
                }).FirstOrDefaultAsync();

            if (artist == null) return NotFound();
            return Ok(artist);
        }

        [HttpGet("{id}/songs")]
        public async Task<IActionResult> GetArtistSongs(int id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var songs = await _context.Songs
                .Where(s => s.ArtistId == id)
                .Select(s => new SongDto
                {
                    Id = s.Id,
                    Title = s.Title,
                    ArtistId = s.ArtistId,
                    ArtistName = s.Artist.ArtistName,
                    FileUrl = s.FileUrl,
                    CoverImage = s.CoverImage,
                    Duration = s.Duration,
                    CreatedAt = s.CreatedAt,
                    IsFavorite = userId != null && _context.Favorites.Any(f => f.UserId == userId && f.SongId == s.Id)
                }).ToListAsync();

            return Ok(songs);
        }
    }
}
