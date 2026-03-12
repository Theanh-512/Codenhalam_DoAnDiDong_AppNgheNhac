using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MusicApp.API.Data;
using MusicApp.API.DTOs;
using MusicApp.API.Models;
using System.Security.Claims;

namespace MusicApp.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SongsController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IWebHostEnvironment _env;

        public SongsController(AppDbContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }

        [HttpGet]
        public async Task<IActionResult> GetSongs([FromQuery] string? search = null, [FromQuery] string? genre = null)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var query = _context.Songs.Include(s => s.Artist).AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(s => s.Title.Contains(search) || s.Artist.ArtistName.Contains(search));
            }

            if (!string.IsNullOrEmpty(genre))
            {
                query = query.Where(s => s.Genre == genre);
            }

            var songs = await query
                .Select(s => new SongDto
                {
                    Id = s.Id,
                    Title = s.Title,
                    ArtistId = s.ArtistId,
                    ArtistName = s.Artist.ArtistName,
                    Genre = s.Genre,
                    FileUrl = s.FileUrl,
                    CoverImage = s.CoverImage,
                    Duration = s.Duration,
                    CreatedAt = s.CreatedAt,
                    IsFavorite = userId != null && _context.Favorites.Any(f => f.UserId == userId && f.SongId == s.Id)
                }).ToListAsync();

            return Ok(songs);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetSong(int id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var song = await _context.Songs
                .Include(s => s.Artist)
                .Where(s => s.Id == id)
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
                }).FirstOrDefaultAsync();

            if (song == null) return NotFound();
            return Ok(song);
        }

        [Authorize(Roles = "Artist")]
        [HttpPost("upload")]
        public async Task<IActionResult> UploadSong([FromForm] UploadSongDto model)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var artist = await _context.Artists.FirstOrDefaultAsync(a => a.UserId == userId);

            if (artist == null) return Unauthorized("User is not registered as an artist.");

            if (model.MusicFile == null || model.MusicFile.Length == 0)
                return BadRequest("Music file is required.");

            // Save Music File
            var musicFileName = Guid.NewGuid().ToString() + Path.GetExtension(model.MusicFile.FileName);
            var musicPath = Path.Combine(_env.WebRootPath, "uploads", "music", musicFileName);
            using (var stream = new FileStream(musicPath, FileMode.Create))
            {
                await model.MusicFile.CopyToAsync(stream);
            }

            // Save Cover Image if provided
            string? coverUrl = null;
            if (model.CoverImage != null && model.CoverImage.Length > 0)
            {
                var coverFileName = Guid.NewGuid().ToString() + Path.GetExtension(model.CoverImage.FileName);
                var coverPath = Path.Combine(_env.WebRootPath, "uploads", "covers", coverFileName);
                using (var stream = new FileStream(coverPath, FileMode.Create))
                {
                    await model.CoverImage.CopyToAsync(stream);
                }
                coverUrl = $"/uploads/covers/{coverFileName}";
            }

            var song = new Song
            {
                Title = model.Title,
                ArtistId = artist.Id,
                FileUrl = $"/uploads/music/{musicFileName}",
                CoverImage = coverUrl,
                Duration = 0, // In a real app, you'd calculate this from the file
                Genre = model.Genre,
                CreatedAt = DateTime.UtcNow
            };

            _context.Songs.Add(song);
            await _context.SaveChangesAsync();

            return Ok(song);
        }

        [Authorize(Roles = "Artist")]
        [HttpPost("upload-external")]
        public async Task<IActionResult> UploadExternalSong([FromBody] CreateExternalSongDto model)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var artist = await _context.Artists.FirstOrDefaultAsync(a => a.UserId == userId);

            if (artist == null) return Unauthorized("User is not registered as an artist.");

            var song = new Song
            {
                Title = model.Title,
                ArtistId = artist.Id,
                FileUrl = model.FileUrl,
                CoverImage = model.CoverImageUrl,
                Duration = 0,
                Genre = model.Genre,
                CreatedAt = DateTime.UtcNow
            };

            _context.Songs.Add(song);
            await _context.SaveChangesAsync();

            return Ok(song);
        }
    }
}
