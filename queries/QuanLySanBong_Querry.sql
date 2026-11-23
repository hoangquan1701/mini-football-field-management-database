USE QuanLySanBong;

-- Câu 1: Hiển thị toàn bộ sân bóng
SELECT 
    SANBONG.MaSan,
    SANBONG.TenSan,
    LOAISAN.TenLoai,
    LOAISAN.SoNguoi,
    SANBONG.GiaThue,
    SANBONG.TinhTrang
FROM SANBONG
JOIN LOAISAN ON SANBONG.MaLoai = LOAISAN.MaLoai;


-- Câu 2: Tìm các sân 5 người
SELECT 
    SANBONG.MaSan,
    SANBONG.TenSan,
    SANBONG.GiaThue,
    SANBONG.TinhTrang
FROM SANBONG
JOIN LOAISAN ON SANBONG.MaLoai = LOAISAN.MaLoai
WHERE LOAISAN.TenLoai = 'San 5 nguoi';


-- Câu 3: Tìm các sân đang hoạt động
SELECT 
    MaSan,
    TenSan,
    GiaThue,
    TinhTrang
FROM SANBONG
WHERE TinhTrang = 'Hoat dong';


-- Câu 4: Tìm khách hàng theo số điện thoại
SELECT
    MaKH,
    HoTen,
    SoDienThoai,
    DiaChi
FROM KHACHHANG
WHERE SoDienThoai = '0901234567';


-- Câu 5: Lịch sử đặt sân của khách hàng
SELECT
    KHACHHANG.MaKH,
    KHACHHANG.HoTen,
    SANBONG.TenSan,
    DAT_SAN.ThoiGianBatDau,
    DAT_SAN.ThoiGianKetThuc,
    DAT_SAN.GiaThueLucDat,
    DAT_SAN.TrangThai
FROM DAT_SAN
JOIN KHACHHANG
    ON DAT_SAN.MaKH = KHACHHANG.MaKH
JOIN SANBONG
    ON DAT_SAN.MaSan = SANBONG.MaSan
WHERE KHACHHANG.MaKH = 1
ORDER BY DAT_SAN.ThoiGianBatDau;


-- Câu 6: Danh sách tất cả lượt đặt sân
SELECT
    DAT_SAN.MaDatSan,
    KHACHHANG.HoTen AS TenKhachHang,
    SANBONG.TenSan,
    NHANVIEN.HoTen AS TenNhanVien,
    DAT_SAN.ThoiGianBatDau,
    DAT_SAN.ThoiGianKetThuc,
    DAT_SAN.GiaThueLucDat,
    DAT_SAN.TrangThai
FROM DAT_SAN
JOIN KHACHHANG
    ON DAT_SAN.MaKH = KHACHHANG.MaKH
JOIN SANBONG
    ON DAT_SAN.MaSan = SANBONG.MaSan
JOIN NHANVIEN
    ON DAT_SAN.MaNV = NHANVIEN.MaNV
ORDER BY DAT_SAN.ThoiGianBatDau;


-- Câu 7: Các lượt đặt sân trong ngày 01/10/2026
SELECT
    DAT_SAN.MaDatSan,
    KHACHHANG.HoTen AS TenKhachHang,
    SANBONG.TenSan,
    DAT_SAN.ThoiGianBatDau,
    DAT_SAN.ThoiGianKetThuc,
    DAT_SAN.TrangThai
FROM DAT_SAN
JOIN KHACHHANG
    ON DAT_SAN.MaKH = KHACHHANG.MaKH
JOIN SANBONG
    ON DAT_SAN.MaSan = SANBONG.MaSan
WHERE DATE(DAT_SAN.ThoiGianBatDau) = '2026-10-01'
ORDER BY DAT_SAN.ThoiGianBatDau;


-- Câu 8: Dịch vụ được sử dụng trong một lượt đặt sân
SELECT
    DAT_SAN.MaDatSan,
    KHACHHANG.HoTen AS TenKhachHang,
    DICHVU.TenDV,
    CHITIET_DICHVU.SoLuong,
    CHITIET_DICHVU.DonGiaLucDung,
    CHITIET_DICHVU.SoLuong * CHITIET_DICHVU.DonGiaLucDung AS ThanhTien
FROM CHITIET_DICHVU
JOIN DAT_SAN
    ON CHITIET_DICHVU.MaDatSan = DAT_SAN.MaDatSan
JOIN KHACHHANG
    ON DAT_SAN.MaKH = KHACHHANG.MaKH
JOIN DICHVU
    ON CHITIET_DICHVU.MaDV = DICHVU.MaDV
WHERE DAT_SAN.MaDatSan = 1;


-- Câu 9: Hóa đơn của một khách hàng
SELECT
    HOADON.MaHD,
    KHACHHANG.HoTen AS TenKhachHang,
    SANBONG.TenSan,
    HOADON.NgayLap,
    HOADON.TongTien,
    HOADON.TrangThaiThanhToan
FROM HOADON
JOIN DAT_SAN
    ON HOADON.MaDatSan = DAT_SAN.MaDatSan
JOIN KHACHHANG
    ON DAT_SAN.MaKH = KHACHHANG.MaKH
JOIN SANBONG
    ON DAT_SAN.MaSan = SANBONG.MaSan
WHERE KHACHHANG.MaKH = 1;


-- Câu 10: Số lượt đặt của từng sân
SELECT
    SANBONG.MaSan,
    SANBONG.TenSan,
    COUNT(DAT_SAN.MaDatSan) AS SoLuotDat
FROM SANBONG
LEFT JOIN DAT_SAN
    ON SANBONG.MaSan = DAT_SAN.MaSan
GROUP BY
    SANBONG.MaSan,
    SANBONG.TenSan
ORDER BY SoLuotDat DESC;


-- Câu 11: Tổng doanh thu theo sân
SELECT
    SANBONG.MaSan,
    SANBONG.TenSan,
    SUM(DAT_SAN.GiaThueLucDat) AS TongTienThue
FROM SANBONG
JOIN DAT_SAN
    ON SANBONG.MaSan = DAT_SAN.MaSan
GROUP BY
    SANBONG.MaSan,
    SANBONG.TenSan
ORDER BY TongTienThue DESC;


-- Câu 12: Tổng tiền dịch vụ của từng lượt đặt sân
SELECT
    DAT_SAN.MaDatSan,
    KHACHHANG.HoTen AS TenKhachHang,
    SUM(
        CHITIET_DICHVU.SoLuong * CHITIET_DICHVU.DonGiaLucDung
    ) AS TongTienDichVu
FROM DAT_SAN
JOIN KHACHHANG
    ON DAT_SAN.MaKH = KHACHHANG.MaKH
JOIN CHITIET_DICHVU
    ON DAT_SAN.MaDatSan = CHITIET_DICHVU.MaDatSan
GROUP BY
    DAT_SAN.MaDatSan,
    KHACHHANG.HoTen
ORDER BY DAT_SAN.MaDatSan;


-- Câu 13: Tính tổng tiền của từng lượt đặt sân
SELECT
    DAT_SAN.MaDatSan,
    KHACHHANG.HoTen AS TenKhachHang,
    DAT_SAN.GiaThueLucDat AS TienSan,
    COALESCE(
        SUM(
            CHITIET_DICHVU.SoLuong * CHITIET_DICHVU.DonGiaLucDung
        ), 0
    ) AS TienDichVu,
    DAT_SAN.GiaThueLucDat
    + COALESCE(
        SUM(
            CHITIET_DICHVU.SoLuong * CHITIET_DICHVU.DonGiaLucDung
        ), 0
    ) AS TongTien
FROM DAT_SAN
JOIN KHACHHANG
    ON DAT_SAN.MaKH = KHACHHANG.MaKH
LEFT JOIN CHITIET_DICHVU
    ON DAT_SAN.MaDatSan = CHITIET_DICHVU.MaDatSan
GROUP BY
    DAT_SAN.MaDatSan,
    KHACHHANG.HoTen,
    DAT_SAN.GiaThueLucDat
ORDER BY DAT_SAN.MaDatSan;


-- Câu 14: Doanh thu theo tháng
SELECT
    YEAR(HOADON.NgayLap) AS Nam,
    MONTH(HOADON.NgayLap) AS Thang,
    SUM(HOADON.TongTien) AS DoanhThu
FROM HOADON
WHERE HOADON.TrangThaiThanhToan = 'Da thanh toan'
GROUP BY
    YEAR(HOADON.NgayLap),
    MONTH(HOADON.NgayLap)
ORDER BY
    Nam,
    Thang;
    

-- Câu 15: Khách hàng có tổng tiền thanh toán cao nhất
SELECT
    KHACHHANG.MaKH,
    KHACHHANG.HoTen,
    SUM(HOADON.TongTien) AS TongChiTieu
FROM KHACHHANG
JOIN DAT_SAN
    ON KHACHHANG.MaKH = DAT_SAN.MaKH
JOIN HOADON
    ON DAT_SAN.MaDatSan = HOADON.MaDatSan
WHERE HOADON.TrangThaiThanhToan = 'Da thanh toan'
GROUP BY
    KHACHHANG.MaKH,
    KHACHHANG.HoTen
ORDER BY TongChiTieu DESC
LIMIT 1;


-- Câu 16: Danh sách đội tham gia giải đấu
SELECT
    GIAIDAU.TenGiai,
    DOIBONG.TenDoi,
    DOIBONG.TenDoiTruong,
    DOIBONG.SoDienThoai
FROM THAMGIA_GIAIDAU
JOIN GIAIDAU
    ON THAMGIA_GIAIDAU.MaGiai = GIAIDAU.MaGiai
JOIN DOIBONG
    ON THAMGIA_GIAIDAU.MaDoi = DOIBONG.MaDoi
ORDER BY
    GIAIDAU.MaGiai,
    DOIBONG.MaDoi;


-- Câu 17: Lịch thi đấu
SELECT
    GIAIDAU.TenGiai,
    TRANDAU.MaTran,
    DOINHA.TenDoi AS DoiNha,
    DOIKHACH.TenDoi AS DoiKhach,
    SANBONG.TenSan,
    TRANDAU.ThoiGianThiDau
FROM TRANDAU
JOIN GIAIDAU
    ON TRANDAU.MaGiai = GIAIDAU.MaGiai
JOIN DOIBONG AS DOINHA
    ON TRANDAU.MaDoiNha = DOINHA.MaDoi
JOIN DOIBONG AS DOIKHACH
    ON TRANDAU.MaDoiKhach = DOIKHACH.MaDoi
JOIN SANBONG
    ON TRANDAU.MaSan = SANBONG.MaSan
ORDER BY TRANDAU.ThoiGianThiDau;


-- Câu 18: Kết quả các trận đã có kết quả
SELECT
    GIAIDAU.TenGiai,
    DOINHA.TenDoi AS DoiNha,
    DOIKHACH.TenDoi AS DoiKhach,
    TRANDAU.TySoNha,
    TRANDAU.TySoKhach,
    TRANDAU.ThoiGianThiDau
FROM TRANDAU
JOIN GIAIDAU
    ON TRANDAU.MaGiai = GIAIDAU.MaGiai
JOIN DOIBONG AS DOINHA
    ON TRANDAU.MaDoiNha = DOINHA.MaDoi
JOIN DOIBONG AS DOIKHACH
    ON TRANDAU.MaDoiKhach = DOIKHACH.MaDoi
WHERE TRANDAU.TySoNha IS NOT NULL
  AND TRANDAU.TySoKhach IS NOT NULL
ORDER BY TRANDAU.ThoiGianThiDau;