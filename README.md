# 🎶 Music Streaming App - Project Overview

Welcome to the comprehensive music streaming application project. This repository contains both the **Backend (ASP.NET Core)** and the **Mobile Client (Flutter)**.

---

## 🇻🇳 TIẾNG VIỆT: TỔNG KẾT DỰ ÁN (PROJECT SUMMARY)

### 1. 🖥️ Backend (ASP.NET Core API - Thư mục `backend`)
- **Cấu trúc dữ liệu:** Hoàn thiện Database Schema với các thực thể **User (Identity)**, **Artist**, **Song** và **Favorite**.
- **Quản lý nhạc:** API cho phép lấy danh sách bài hát, hỗ trợ **Tìm kiếm (Search)** và **Lọc theo thể loại (Genre)**.
- **Xác thực và phân quyền:** Hệ thống Đăng nhập/Đăng ký sử dụng **JWT (JSON Web Token)**. Phân chia vai trò rõ ràng giữa **Người nghe (User)** và **Nghệ sĩ (Artist)**.
- **Streaming & Static Files:** Server cấu hình phục vụ tệp âm nhạc và hình ảnh trực tiếp qua URL.
- **Dữ liệu mẫu:** Tích hợp bộ Seed dữ liệu ban đầu để kiểm tra ứng dụng ngay lập tức.

### 2. 📱 Flutter App (Mobile)
- **Hệ thống Audio:** Phát nhạc trực tuyến (Streaming) qua Internet với đầy đủ tính năng: Trình phát nhạc toàn màn hình, Thanh nhạc thu nhỏ (Mini-Player), thanh tiến trình (Seek bar), Trộn bài (Shuffle) và Lặp lại (Repeat).
- **Giao diện Premium (Spotify UI):** Thiết kế rực rỡ với hiệu ứng Glassmorphism và màu sắc theo chủ đề bài hát.
- **Tính năng tìm kiếm:** Chức năng tìm kiếm bài hát theo thời gian thực kết nối trực tiếp với backend.
- **Cá nhân hóa:** Trang Thư viện và Trang Cá nhân được thiết kế để quản lý tài khoản và danh sách phát cá nhân.

---

## 🇺🇸 ENGLISH: PROJECT ACHIEVEMENTS

### 1. 🖥️ Backend (ASP.NET Core API - `backend` folder)
- **Core Architecture:** Implemented a robust Database Schema including **Users**, **Artists**, **Songs**, and **Favorites**.
- **Music Management:** Built APIs for song retrieval with support for **Search** and **Category/Genre Filtering**.
- **Authentication:** Integrated **JWT Authentication** with support for **Standard Users** and **Artists**.
- **Static Content Hosting:** Enabled static file serving for music files (`.mp3`) and cover images.
- **Data Seeding:** Automated initial data setup for immediate testing.

### 2. 📱 Flutter App (Mobile Client)
- **Audio Engine:** Developed a comprehensive `AudioProvider` supporting remote streaming, real-time progress bars, and playback modes (Shuffle/Repeat).
- **Aesthetic UI (Spotify-like):** Crafted a modern, premium user interface with Glassmorphism and vibrant gradients.
- **Search & Discovery:** Implemented a functional search bar and genre-based category exploration.
- **Mini-Player:** Added a persistent mini-player for seamless navigation across the app.
- **Full Player Screen:** Designed a rich playback screen with large album art and high-quality controls.

---

## 🛠️ Technology Stack
- **Backend:** ASP.NET Core 8.0, Entity Framework Core, SQL Server, Identity.
- **Frontend:** Flutter, Provider (State Management), `just_audio` (Audio Engine), Material 3.

## 🚀 Current Status
- ✅ **Playback:** Working (Internet Streaming)
- ✅ **Search:** Functional
- ✅ **Auth:** Fully Implemented (Login/Register/Role-based)
- ✅ **UI:** Complete for Home, Search, Library, and Profile.

---
*Last updated: March 12, 2026*
