using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using MusicApp.API.Data;
using MusicApp.API.DTOs;
using MusicApp.API.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace MusicApp.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly UserManager<User> _userManager;
        private readonly AppDbContext _context;
        private readonly IConfiguration _configuration;

        public AuthController(UserManager<User> userManager, AppDbContext context, IConfiguration configuration)
        {
            _userManager = userManager;
            _context = context;
            _configuration = configuration;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDto model)
        {
            var user = new User
            {
                UserName = model.Username,
                Email = model.Email,
                FullName = model.FullName,
                Role = model.Role
            };

            var result = await _userManager.CreateAsync(user, model.Password);

            if (result.Succeeded)
            {
                if (model.Role == "Artist")
                {
                    var artist = new Artist
                    {
                        UserId = user.Id,
                        ArtistName = model.ArtistName ?? model.FullName ?? model.Username
                    };
                    _context.Artists.Add(artist);
                    await _context.SaveChangesAsync();
                }

                return Ok(new AuthResponseDto { IsSuccess = true, Message = "User registered successfully" });
            }

            return BadRequest(new AuthResponseDto { IsSuccess = false, Message = string.Join(", ", result.Errors.Select(e => e.Description)) });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto model)
        {
            var user = await _userManager.FindByNameAsync(model.Username);
            if (user != null && await _userManager.CheckPasswordAsync(user, model.Password))
            {
                var token = GenerateJwtToken(user);
                return Ok(new AuthResponseDto
                {
                    IsSuccess = true,
                    Token = token,
                    Username = user.UserName,
                    Role = user.Role,
                    Email = user.Email
                });
            }

            return Unauthorized(new AuthResponseDto { IsSuccess = false, Message = "Invalid username or password" });
        }

        private string GenerateJwtToken(User user)
        {
            var jwtSettings = _configuration.GetSection("Jwt");
            var key = Encoding.ASCII.GetBytes(jwtSettings["Key"]!);

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id),
                new Claim(ClaimTypes.Name, user.UserName!),
                new Claim(ClaimTypes.Role, user.Role)
            };

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.AddMinutes(double.Parse(jwtSettings["DurationInMinutes"]!)),
                Issuer = jwtSettings["Issuer"],
                Audience = jwtSettings["Audience"],
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }
    }
}
