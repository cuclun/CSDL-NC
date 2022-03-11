CREATE DATABASE BANHANG
GO

USE BANHANG
GO

CREATE TABLE KHACHHANG(
	MaKH char(10) PRIMARY KEY,
	TenKH nvarchar(50),
	Email nvarchar(20),
	SoDienThoai char(10),
	DiaChi nvarchar(20))
GO

CREATE TABLE SANPHAM(
	MaSP char(10) PRIMARY KEY,
	TenSP nvarchar(50),
	MoTa nvarchar(20),
	Gia bigint,
	SoLuong int)
GO

CREATE TABLE PHUONGTHUCTHANHTOAN(
	MaPT char(10) PRIMARY KEY,
	TenPT nvarchar(50),
	PhiTT bigint)
GO

CREATE TABLE DONHANG(
	MaDH char(10) PRIMARY KEY,
	MaKH char(10),
	FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
	MaPT char(10),
	FOREIGN KEY (MaPT) REFERENCES PHUONGTHUCTHANHTOAN(MaPT),
	NgayDatHang date,
	TrangThaiDatHang nvarchar(20),
	Tong bigint)
GO

CREATE TABLE CHITIET(
	MaCT char(10) PRIMARY KEY,
	MaSP char(10),
	FOREIGN KEY (MaSP) REFERENCES SANPHAM(MaSP),
	MaDH char(10),
	FOREIGN KEY (MaDH) REFERENCES DONHANG(MaDH),
	SoLuongMua int,
	GiaSP bigint,
	ThanhTien bigint)
GO

INSERT INTO KHACHHANG(MaKH, TenKH, Email, SoDienThoai, DiaChi) 
VALUES	('KH001', N'Trần Thị Thanh Cúc', 'tttc@gmail.com', '0771234561', N'Quảng Nam'),
		('KH002', N'Phan Thị Mỹ Dung', 'ptmd@gmail.com', '0771234562', N'Đà nẵng'),
		('KH003', N'Lê Thị Thùy Dung', 'lttd@gmail.com', '0771234563', N'Quảng Trị'),
		('KH004', N'Lương Thị Mỹ Duyên', 'ltmd@gmail.com', '0771234564', N'Kon Tum'),
		('KH005', N'Phạm Thành Đạt', 'ptd@gmail.com', '0771234565', N'Quảng Nam'),
		('KH006', N'Đinh Thị Hiền', 'dth@gmail.com', '0771234566', N'Nghệ An'),
		('KH007', N'Nguyễn Thị Mỹ Quyên', 'ntmq@gmail.com', '0771234567', N'Quảng Nam')
GO

INSERT INTO SANPHAM(MaSP, TenSP, MoTa, Gia, SoLuong)
VALUES	('SP001', N'Bánh', N'Đặt biệt thơm ngon', '50000', '100'),
		('SP002', N'Kẹo', N'Đặt biệt thơm ngon', '30000', '100'),
		('SP003', N'Nước ngọt', N'Đặt biệt thơm ngon', '200000', '100'),
		('SP004', N'Nước lọc', N'Đặt biệt thơm ngon', '100000', '100'),
		('SP005', N'Bia', N'Đặt biệt thơm ngon', '400000', '100')
GO

INSERT INTO PHUONGTHUCTHANHTOAN (MaPT, TenPT, PhiTT)
VALUES	('PT001', N'Nhận hàng - Thanh toán', '0'),
		('PT002', N'Chuyển khoản', '10000')
GO

INSERT INTO DONHANG(MaDH, MaKH, MaPT, NgayDatHang, TrangThaiDatHang, Tong)
VALUES	('DH001', 'KH001', 'PT001', '3/9/2022', N'Đang giao', '130000'),
		('DH002', 'KH005', 'PT001', '2/15/2022', N'Đã giao', '250000'),
		('DH003', 'KH003', 'PT002', '4/2/2022', N'Đang giao', '4050000'),
		('DH004', 'KH007', 'PT002', '8/2/2020', N'Đã giao', '110000'),
		('DH005', 'KH003', 'PT001', '1/12/2021', N'Đã giao', '770000')
GO
--Liệt kê thông tin khách hàng đã mua sản phẩm có mã là 'SP002'
INSERT INTO CHITIET(MaCT, MaDH, MaSP, SoLuongMua, GiaSP, ThanhTien)
VALUES	('CT001', 'DH001', 'SP001', '2', '50000', '100000'),
		('CT002', 'DH001', 'SP002', '1', '30000', '30000'),
		('CT003', 'DH002', 'SP001', '5', '50000', '250000'),
		('CT004', 'DH003', 'SP004', '4', '100000', '40000'),
		('CT005', 'DH003', 'SP005', '10', '400000', '4000000'),
		('CT006', 'DH004', 'SP001', '2', '50000', '100000'),
		('CT007', 'DH005', 'SP001', '6', '50000', '300000'),
		('CT008', 'DH005', 'SP002', '9', '30000', '270000'),
		('CT009', 'DH005', 'SP004', '2', '100000', '200000')
GO

--Thực hiện tạo các truy vấn nâng cao
--Câu 1: Hiển thị thông tin các khách hàng chưa mua sản phẩm nào trong năm 2021.

SELECT * FROM KHACHHANG
EXCEPT
SELECT k.*
FROM KHACHHANG k join DONHANG d on k.MaKH = d.MaKH
WHERE NgayDatHang BETWEEN '1/1/2021' AND '12/31/2021'
GO

--Câu 2: Liệt kê các đơn hàng được mua bởi khách hàng có tên là 'Trần Thị Thanh Cúc'
SELECT d.MaDH
FROM KHACHHANG k JOIN DONHANG d ON k.MaKH = d.MaKH
WHERE k.TenKH = N'Trần Thị Thanh Cúc'
GO

--Câu 3: Liệt kê thông tin khách hàng đã mua sản phẩm có mã là 'SP002'
SELECT k.*
FROM KHACHHANG k JOIN DONHANG d ON k.MaKH = d.MaKH JOIN CHITIET c ON d.MaDH = c.MaDH
WHERE c.MaSP = 'SP002'
GO

--Thực hiện tạo các VIEW
--Câu 1: Tạo khung nhìn có tên V_CustomerInfo để lấy thông tin của tất cả các khách hàng đã từng mua hàng trong năm 2021.
CREATE VIEW V_CustomerInfo
AS
	SELECT k.*
	FROM KHACHHANG k join DONHANG d on k.MaKH = d.MaKH
	WHERE NgayDatHang BETWEEN '1/1/2021' AND '12/31/2021'
GO

--Câu 2: Tạo khung nhìn có tên V_PaymentInfo để lấy thông tin các phương thức thanh toán chưa được sử dụng.
CREATE VIEW V_PaymentInfo
AS
	SELECT *
	FROM PHUONGTHUCTHANHTOAN 
	WHERE MaPT NOT IN (SELECT MaPT FROM DONHANG)
GO

-- Câu 3: Tạo khung nhìn có tên V_ProductInfo để lấy thông tin sản phẩm đã được bán từ 9 sản phẩm trở lên.
CREATE VIEW V_ProductInfo
AS
	SELECT c.MaSP, s.TenSP, s.MoTa, s.Gia, s.SoLuong, SUM(c.SoLuongMua) TongSLBan
	FROM SANPHAM s JOIN CHITIET c ON s.MaSP = c.MaSP
	GROUP BY c.MaSP, s.TenSP, s.MoTa, s.Gia, s.SoLuong
	HAVING SUM(c.SoLuongMua) >= 9
GO

--Câu 4: Tạo khung nhìn có tên V_OrderInfo để lấy thông tin các đơn hàng được khách hàng có tên 'Lê Thị Thùy Dung' đặt hàng.
CREATE VIEW V_OrderInfo
AS
	SELECT d.*
	FROM KHACHHANG k JOIN DONHANG d ON k.MaKH = d.MaKH
	WHERE k.TenKH LIKE N'Lê Thị Thùy Dung'
GO

--Câu 5: Tạo khung nhìn có tên V_DetailInfo để lấy thông tin chi tiết của các đơn hàng đã được đặt vào ngày 2/15/2022.
CREATE VIEW V_DetailInfo
AS
	SELECT c.*, d.NgayDatHang
	FROM DONHANG d JOIN CHITIET c ON d.MaDH = c.MaDH
	WHERE d.NgayDatHang = '2/15/2022'
GO

--Thực hiện tạo các FUNCTION
--Câu 1: Tạo Function có tên là F_TongSLMua. Khi truyền vào Mã SP hiển thị ra số lượng đã được mua.
CREATE FUNCTION F_TongSLMua(@MaSP char(10))
RETURNS TABLE
AS
	RETURN (SELECT SUM(c.SoLuongMua) TongSLMua
			FROM SANPHAM s JOIN CHITIET c ON s.MaSP = c.MaSP
			WHERE s.MaSP = @MaSP
			GROUP BY c.MaSP)
GO

SELECT * FROM dbo.F_TongSLMua('SP001') TongSLMua
GO

--Câu 2: Tạo Function có tên là F_TongTien. Khi truyền vào Mã KH hiển thị ra số tiền mà khách hàng đã mua.
CREATE FUNCTION F_TongTien (@MaKH char(10))
RETURNS bigint
AS
BEGIN
	DECLARE @TongTien bigint
	SELECT @TongTien = SUM(Tong)
	FROM DONHANG
	WHERE MaKH = @MaKH
	RETURN @TongTien
END
GO

SELECT dbo.F_TongTien ('KH001') TongTien
GO

--Câu 3: Tạo Function có tên là F_KhachHangVip. Khi truyền vào năm hiển thị ra khách hàng đã chi nhiều nhất.
CREATE FUNCTION F_KhachHangVip (@nam int)
RETURNS char(10)
AS
BEGIN
	DECLARE @KhachHangVip char(10)
	SELECT TOP 1 @KhachHangVip = MaKH
	FROM DONHANG d
	WHERE year(d.NgayDatHang) = @nam 
	GROUP BY MaKH
	ORDER BY SUM(d.Tong) DESC
	RETURN @KhachHangVip
END
GO

SELECT dbo.F_KhachHangVip('2020') KhachHangVip
GO

--Câu 4: Tạo Function có tên là F_SPVip. Hiển thị sản phẩm được mua nhiều nhất.
CREATE FUNCTION F_SPVip()
RETURNS TABLE
AS
	RETURN (SELECT TOP 1 MaSP
			FROM CHITIET
			GROUP BY MaSP
			ORDER BY SUM(CHITIET.SoLuongMua) DESC)
GO

SELECT * FROM dbo.F_SPVip()
GO

--Thực hiện tạo các PROCEDURE
--Câu 1: Tạo Procedure có tên là Sp_ThemSP. Để thêm bảng ghi mới vào bảng SANPHAM, kiểm tra các điều kiện.
CREATE PROC Sp_ThemSP	(@MaSP char(10),
						@TenSP nvarchar(50),
						@MoTa nvarchar(20),
						@Gia bigint,
						@SoLuong int)
AS
BEGIN
	IF EXISTS (SELECT MaSP FROM SANPHAM WHERE MaSP = @MaSP)
	BEGIN
		PRINT N'Đã có mã sản phẩm này'
		RETURN
	END

	IF (@Gia < 0)
	BEGIN
		PRINT N'Giá sản phẩm phải lớn hơn 0'
		RETURN 
	END

	IF (@SoLuong < 0)
	BEGIN
		PRINT N'Số lượng sản phẩm phải lớn hơn 0'
		RETURN
	END

	INSERT INTO SANPHAM	VALUES (@MaSP,
								@TenSP,
								@MoTa,
								@Gia,
								@SoLuong)
END
GO

--Câu 2: Tạo Procedure có tên là Sp_DonHang. Để thêm bảng ghi mới vào bảng DONHANG, kiểm tra các điều kiện.
CREATE PROC Sp_DonHang	(@MaDH char(10),
						@MaKH char(10),
						@MaPT char(10),
						@NgayDatHang date NULL,
						@TrangThaiDatHang nvarchar(20) NULL,
						@Tong bigint NULL)
AS
BEGIN
	IF EXISTS (SELECT MaDH FROM DONHANG WHERE MaDH = @MaDH)
	BEGIN
		PRINT N'Đã có mã đơn hàng này'
		RETURN
	END

	IF NOT EXISTS (SELECT MaKH FROM KHACHHANG WHERE MaKH = @MaKH)
	BEGIN
		PRINT N'Không tồn tại mã khách hàng này'
		RETURN
	END

	IF NOT EXISTS (SELECT MaPT FROM PHUONGTHUCTHANHTOAN WHERE MaPT = @MaPT)
	BEGIN
		PRINT N'Không tồn tại phương thức thanh toán này'
		RETURN
	END

	INSERT INTO DONHANG	VALUES (@MaDH,
								@MaKH,
								@MaPT,
								@NgayDatHang,
								@TrangThaiDatHang,
								@Tong)
END
GO

--Câu 3: Tạo Procedure có tên là Sp_XoaSP. Xóa thông tin sản phẩm với mã sản phẩm được truyền vào như tham số.
CREATE PROC Sp_XoaSP (@MaSP char(10))
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM SANPHAM WHERE MaSP = @MaSP)
	BEGIN
		PRINT N'Không có sản phẩm bạn muốn xóa!!!'
		RETURN
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT * FROM SANPHAM s LEFT JOIN CHITIET c ON s.MaSP = c.MaSP
					WHERE c.MaSP IS NULL AND c.MaSP = @MaSP)
		BEGIN
			PRINT N'Xóa bản ghi có chứa sản phẩm' + @MaSP + N'trong bảng CHITIET'
			RETURN
		END
		ELSE
			BEGIN 
				DELETE FROM SANPHAM WHERE MaSP = @MaSP
			END
	END
END
GO

--Câu 4: Tạo Procedure có tên là Sp_DaMua. Kiểm tra xem khách hàng đã mua sản phẩm nào chưa 
--nếu có thì hiển thị sản phẩm mà khách hàng đã mua. Với mã KH là tham số truyền vào.
CREATE PROC Sp_DaMua (@MaKH char(10))
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM KHACHHANG WHERE MaKH = @MaKH)
	BEGIN 
		PRINT N'Không có khách hàng này!!!'
		RETURN
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT * FROM DONHANG WHERE MaKH = @MaKH)
		BEGIN 
			PRINT N'Khách hàng này chưa mua sản phẩm nào.'
			RETURN
		END
		ELSE
		BEGIN
			SELECT c.* FROM DONHANG d JOIN CHITIET c ON d.MaDH = c.MaDH
			WHERE d.MaKH = @MaKH
		END
	END
END
GO

EXECUTE Sp_DaMua 'KH009'