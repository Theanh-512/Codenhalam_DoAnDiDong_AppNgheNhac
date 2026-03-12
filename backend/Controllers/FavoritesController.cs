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
    [Authorize]
    public class FavoritesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public FavoritesController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetFavorites()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            var favoriteSongs = await _context.Favorites
                .Where(f => f.UserId == userId)
                .Include(f => f.Song)
                .ThenInclude(s => s.Artist)
                .Select(f => new SongDto
                {
                    Id = f.Song.Id,
                    Title = f.Song.Title,
                    ArtistId = f.Song.ArtistId,
                    ArtistName = f.Song.Artist.ArtistName,
                    Genre = f.Song.Genre,
                    FileUrl = f.Song.FileUrl,
                    CoverImage = f.Song.CoverImage,
                    Duration = f.Song.Duration,
                    CreatedAt = f.Song.CreatedAt,
                    IsFavorite = true
                }).ToListAsync();

            return Ok(favoriteSongs);
        }

        [HttpPost("{songId}")]
        public async Task<IActionResult> AddToFavorites(int songId)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            var song = await _context.Songs.FindAsync(songId);
            if (song == null) return NotFound("Song not found");

            var existingFavorite = await _context.Favorites
                .FirstOrDefaultAsync(f => f.UserId == userId && f.SongId == songId);

            if (existingFavorite != null) return BadRequest("Song is already in favorites");

            var favorite = new Favorite
            {
                UserId = userId,
                SongId = songId
            };

            _context.Favorites.Add(favorite);
            await _context.SaveChangesAsync();

            return Ok(new { Message = "Added to favorites" });
        }

        [HttpDelete("{songId}")]
        public async Task<IActionResult> RemoveFromFavorites(int songId)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            var favorite = await _context.Favorites
                .FirstOrDefaultAsync(f => f.UserId == userId && f.SongId == songId);

            if (favorite == null) return NotFound("Favorite not found");

            _context.Favorites.Remove(favorite);
            await _context.SaveChangesAsync();

            return Ok(new { Message = "Removed from favorites" });
        }
    }
}
