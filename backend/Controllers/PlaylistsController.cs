using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MusicApp.API.Data;
using MusicApp.API.DTOs;
using MusicApp.API.Models;
using System.Security.Claims;

namespace MusicApp.API.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class PlaylistsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PlaylistsController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetPlaylists()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var playlists = await _context.Playlists
                .Where(p => p.UserId == userId)
                .Select(p => new PlaylistDto
                {
                    Id = p.Id,
                    Name = p.Name,
                    UserId = p.UserId,
                    CreatedAt = p.CreatedAt,
                    SongCount = p.PlaylistSongs.Count
                }).ToListAsync();

            return Ok(playlists);
        }

        [HttpPost]
        public async Task<IActionResult> CreatePlaylist(CreatePlaylistDto model)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            var playlist = new Playlist
            {
                Name = model.Name,
                UserId = userId
            };

            _context.Playlists.Add(playlist);
            await _context.SaveChangesAsync();

            return Ok(new PlaylistDto
            {
                Id = playlist.Id,
                Name = playlist.Name,
                UserId = playlist.UserId,
                CreatedAt = playlist.CreatedAt,
                SongCount = 0
            });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePlaylist(int id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var playlist = await _context.Playlists.FirstOrDefaultAsync(p => p.Id == id && p.UserId == userId);

            if (playlist == null) return NotFound();

            _context.Playlists.Remove(playlist);
            await _context.SaveChangesAsync();

            return Ok();
        }

        [HttpGet("{id}/songs")]
        public async Task<IActionResult> GetPlaylistSongs(int id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var playlist = await _context.Playlists.AnyAsync(p => p.Id == id && p.UserId == userId);
            if (!playlist) return NotFound("Playlist not found or you don't have access.");

            var songs = await _context.PlaylistSongs
                .Where(ps => ps.PlaylistId == id)
                .Select(ps => new SongDto
                {
                    Id = ps.Song.Id,
                    Title = ps.Song.Title,
                    ArtistId = ps.Song.ArtistId,
                    ArtistName = ps.Song.Artist.ArtistName,
                    FileUrl = ps.Song.FileUrl,
                    CoverImage = ps.Song.CoverImage,
                    Duration = ps.Song.Duration,
                    Genre = ps.Song.Genre,
                    CreatedAt = ps.Song.CreatedAt,
                    IsFavorite = userId != null && _context.Favorites.Any(f => f.UserId == userId && f.SongId == ps.Song.Id)
                }).ToListAsync();

            return Ok(songs);
        }

        [HttpPost("{id}/songs")]
        public async Task<IActionResult> AddSongToPlaylist(int id, AddSongToPlaylistDto model)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var playlist = await _context.Playlists.FirstOrDefaultAsync(p => p.Id == id && p.UserId == userId);

            if (playlist == null) return NotFound("Playlist not found.");

            // Check if song already exists in playlist
            if (await _context.PlaylistSongs.AnyAsync(ps => ps.PlaylistId == id && ps.SongId == model.SongId))
            {
                return BadRequest("Song is already in the playlist.");
            }

            var playlistSong = new PlaylistSong
            {
                PlaylistId = id,
                SongId = model.SongId
            };

            _context.PlaylistSongs.Add(playlistSong);
            await _context.SaveChangesAsync();

            return Ok();
        }

        [HttpDelete("{id}/songs/{songId}")]
        public async Task<IActionResult> RemoveSongFromPlaylist(int id, int songId)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var playlist = await _context.Playlists.AnyAsync(p => p.Id == id && p.UserId == userId);
            if (!playlist) return NotFound();

            var playlistSong = await _context.PlaylistSongs.FirstOrDefaultAsync(ps => ps.PlaylistId == id && ps.SongId == songId);
            if (playlistSong == null) return NotFound("Song not found in playlist.");

            _context.PlaylistSongs.Remove(playlistSong);
            await _context.SaveChangesAsync();

            return Ok();
        }
    }
}
