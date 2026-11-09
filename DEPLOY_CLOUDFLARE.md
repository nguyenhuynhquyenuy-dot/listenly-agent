# Hướng Dẫn Cài Đặt và Triển Khai Listenly Agent Lên Cloudflare

Dự án này đã được tùy biến nhận diện thương hiệu từ repo **GoClaw** thành **Listenly Agent**, bao gồm:
- **Tone màu chủ đạo**: Gradient kết hợp giữa Primary `#39A0F5` (Xanh Dương) và Secondary `#50D2CA` (Xanh Ngọc).
- **Logo**: Logo Listenly với biểu tượng gradient và chữ "Listenly" màu trắng thanh lịch.
- **Favicon**: Bộ icon đa phân giải (`favicon.ico`, `favicon.png`, `favicon.svg`) sắc nét.
- **Dashboard**: Đã ẩn text logo trùng lặp ở sidebar, hiển thị logo tinh tế và tự nhiên.
- **Đồng bộ GitHub**: Thiết lập remote origin về `https://github.com/nguyenhuynhquyenuy-dot/listenly-agent`.

---

## 1. Cơ Chế Tự Động Push Đồng Bộ Lên GitHub Mỗi Khi Sửa Đổi

Mỗi khi bạn chỉnh sửa bất kỳ file nào trong dự án, bạn chỉ cần chạy 1 lệnh duy nhất:

### Trên Windows (PowerShell):
```powershell
.\sync.ps1 -Message "Nội dung cập nhật của bạn"
```
*(Nếu không nhập `-Message`, script sẽ tự gắn thời gian cập nhật hiện tại)*

### Trên Linux / Mac / VPS (Bash):
```bash
chmod +x sync.sh
./sync.sh "Nội dung cập nhật của bạn"
```

Script sẽ tự động:
1. `git add -A` toàn bộ thay đổi.
2. `git commit -m "..."`.
3. `git push origin <nhánh-hiện-tại>` lên GitHub repo [listenly-agent](https://github.com/nguyenhuynhquyenuy-dot/listenly-agent).

---

## 2. Triển Khai Lên Tên Miền Miễn Phí Tại Cloudflare

Dự án GoClaw / Listenly có kiến trúc Go backend kết hợp Web Dashboard & WebSocket (cổng mặc định `18790`). Cách tốt nhất, bảo mật và miễn phí 100% của Cloudflare là sử dụng **Cloudflare Tunnel (`cloudflared`)**.

### Cách 1: Dùng tên miền ngẫu nhiên miễn phí ngay lập tức (Quick Tunnel)
*Không cần mua domain, không cần thẻ tín dụng, không cần tài khoản Cloudflare.*

1. **Khởi động Listenly Agent bằng Docker**:
   ```powershell
   # Tạo file .env với các token bí mật ngẫu nhiên:
   .\prepare-env.ps1

   # Khởi động dịch vụ:
   docker compose -f docker-compose.yml -f docker-compose.postgres.yml up -d
   ```
2. **Kích hoạt Cloudflare Quick Tunnel**:
   - Nếu đã cài `cloudflared` trên máy:
     ```bash
     cloudflared tunnel --url http://localhost:18790
     ```
   - Hoặc chạy qua Docker:
     ```bash
     docker run --rm --net=host cloudflare/cloudflared:latest tunnel --url http://localhost:18790
     ```
3. Cloudflare sẽ in ra đường dẫn dạng:
   ```
   https://listenly-agent-xyz.trycloudflare.com
   ```
   Bạn có thể mở link này trên điện thoại hoặc chia sẻ cho bất kỳ ai trên internet với kết nối HTTPS bảo mật.

---

### Cách 2: Gắn tên miền riêng trên Cloudflare sau này (Zero Trust Tunnel)
*Sau khi bạn đã add tên miền của bạn (ví dụ: `yourdomain.com`) vào Cloudflare.*

1. Đăng nhập [Cloudflare Zero Trust Dashboard](https://one.dash.cloudflare.com/).
2. Vào **Networks** → **Tunnels** → Bấm **Create a Tunnel**.
3. Đặt tên tunnel (ví dụ: `listenly-tunnel`) → Chọn **Save tunnel**.
4. Tại bước **Install and run a connector**, Cloudflare sẽ cung cấp một đoạn mã có chứa `eyJhIjoi...` (đây là **Tunnel Token** của bạn).
5. Tạo file `.env.cloudflared` trong thư mục dự án:
   ```env
   TUNNEL_TOKEN=eyJhIjoi...paste_token_vao_day...
   ```
6. Tại tab **Public Hostnames** trên Cloudflare:
   - **Subdomain**: nhập subdomain bạn muốn (ví dụ: `agent` hoặc `app`).
   - **Domain**: chọn tên miền của bạn (ví dụ: `yourdomain.com`).
   - **Service**:
     - Type: `HTTP`
     - URL: `goclaw:18790` *(chú ý dùng `goclaw:18790`, không dùng localhost vì container tunnel gọi qua mạng docker)*.
7. Chạy dự án kèm dịch vụ tunnel có sẵn trong repo:
   ```bash
   docker compose -f docker-compose.yml -f docker-compose.postgres.yml -f docker-compose.cloudflared.yml up -d
   ```
Ngay lập tức, bạn có thể truy cập Listenly Agent qua địa chỉ `https://agent.yourdomain.com` với SSL tự động và chống tấn công DDoS từ Cloudflare!

---

## 3. Cập Nhật Phiên Bản Từ Goclaw Gốc (Upstream Sync)

Nếu tác giả repo `goclaw` gốc có bản cập nhật mới trong tương lai và bạn muốn kéo về:
```bash
git fetch upstream
git merge upstream/dev
.\sync.ps1 -Message "Merge latest updates from upstream goclaw"
```
Mọi tùy biến thương hiệu của Listenly vẫn được giữ nguyên và sao lưu an toàn trên GitHub của bạn.
