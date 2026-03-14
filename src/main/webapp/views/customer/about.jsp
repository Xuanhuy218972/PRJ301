<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Về Chúng Tôi - Sport Field</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/customer/base.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/customer/about.css" rel="stylesheet">
</head>
<body>

    <jsp:include page="../common/header.jsp"></jsp:include>

    <!-- Hero Section with Background Image -->
    <div class="about-hero">
        <div class="container text-center">
            <h1 style="font-size: 4rem; font-weight: 900; letter-spacing: 2px; text-transform: uppercase;">
                <i class="fas fa-futbol me-3"></i>SPORT FIELD
            </h1>
            <div style="height: 3px; width: 150px; background: white; margin: 20px auto;"></div>
            <p class="mb-3" style="font-size: 1.5rem; font-weight: 600;">Hệ thống sân bóng đá hàng đầu Đà Nẵng</p>
            <p style="font-size: 1.1rem; opacity: 0.95; font-weight: 400;">Nơi đam mê được thăng hoa - Chất lượng là ưu tiên hàng đầu</p>
        </div>
    </div>

    <div class="container mb-5">
        
        <!-- Giới thiệu -->
        <div class="intro-card reveal">
            <h3><i class="fas fa-building me-2"></i>Giới Thiệu Công Ty</h3>
            <p>
                <strong>Sport Field</strong> là hệ thống sân bóng đá chuyên nghiệp được thành lập vào năm <strong>2020</strong> tại <strong>Đà Nẵng</strong>,
                với sứ mệnh mang đến không gian thể thao chất lượng và trải nghiệm bóng đá tốt nhất cho cộng đồng đam mê thể thao.
            </p>
            <p>
                Sau nhiều năm phát triển, Sport Field hiện sở hữu hơn <strong>15 sân bóng</strong> tiêu chuẩn phân bố khắp thành phố Đà Nẵng.
                Tất cả sân đều được trang bị cỏ nhân tạo cao cấp, hệ thống đèn chiếu sáng hiện đại và cơ sở vật chất đạt chuẩn,
                đảm bảo mang lại trải nghiệm thi đấu thoải mái và an toàn cho người chơi.
            </p>
            <p>
                Đến nay, Sport Field đã phục vụ hơn <strong>10.000 khách hàng</strong> với mức đánh giá trung bình <strong>4.8/5 sao</strong>,
                trở thành một trong những hệ thống sân bóng được yêu thích và tin tưởng hàng đầu tại Đà Nẵng.
            </p>
            <p class="mb-0">
                Chúng tôi luôn không ngừng cải tiến dịch vụ, nâng cấp cơ sở hạ tầng và xây dựng cộng đồng bóng đá năng động,
                nhằm mang lại những trận đấu trọn vẹn và đáng nhớ cho mọi khách hàng.
            </p>
        </div>

        <!-- Mission & Values -->
        <div class="row mb-4">
            <div class="col-md-6 mb-3 reveal">
                <div class="mission-card">
                    <h4><i class="fas fa-bullseye me-2"></i>Sứ Mệnh</h4>
                    <p>Mang đến trải nghiệm thể thao tốt nhất cho cộng đồng yêu bóng đá. Chúng tôi cam kết cung cấp 
                    sân bóng chất lượng cao, dịch vụ chuyên nghiệp và môi trường an toàn.</p>
                </div>
            </div>
            <div class="col-md-6 mb-3 reveal">
                <div class="mission-card">
                    <h4><i class="fas fa-gem me-2"></i>Giá Trị Cốt Lõi</h4>
                    <p><strong>Chất lượng:</strong> Sân bóng đạt tiêu chuẩn cao<br>
                    <strong>Uy tín:</strong> Minh bạch, đúng cam kết<br>
                    <strong>Chuyên nghiệp:</strong> Dịch vụ tận tâm 24/7</p>
                </div>
            </div>
        </div>

        <!-- Thành tựu -->
        <h2 class="section-title"><i class="fas fa-trophy me-2"></i>Thành Tựu</h2>
        <div class="row mb-4">
            <div class="col-md-3 col-6 mb-3 reveal">
                <div class="intro-card text-center" style="border-left: none; padding: 25px;">
                    <i class="fas fa-futbol" style="font-size: 2.5rem; color: #27ae60; margin-bottom: 15px;"></i>
                    <div style="font-size: 2.5rem; color: #27ae60; font-weight: 800;">15+</div>
                    <div style="color: #718096; font-weight: 600;">Sân Bóng</div>
                </div>
            </div>
            <div class="col-md-3 col-6 mb-3 reveal">
                <div class="intro-card text-center" style="border-left: none; padding: 25px;">
                    <i class="fas fa-users" style="font-size: 2.5rem; color: #27ae60; margin-bottom: 15px;"></i>
                    <div style="font-size: 2.5rem; color: #27ae60; font-weight: 800;">10K+</div>
                    <div style="color: #718096; font-weight: 600;">Khách Hàng</div>
                </div>
            </div>
            <div class="col-md-3 col-6 mb-3 reveal">
                <div class="intro-card text-center" style="border-left: none; padding: 25px;">
                    <i class="fas fa-star" style="font-size: 2.5rem; color: #27ae60; margin-bottom: 15px;"></i>
                    <div style="font-size: 2.5rem; color: #27ae60; font-weight: 800;">4.8</div>
                    <div style="color: #718096; font-weight: 600;">Đánh Giá</div>
                </div>
            </div>
            <div class="col-md-3 col-6 mb-3 reveal">
                <div class="intro-card text-center" style="border-left: none; padding: 25px;">
                    <i class="fas fa-calendar-check" style="font-size: 2.5rem; color: #27ae60; margin-bottom: 15px;"></i>
                    <div style="font-size: 2.5rem; color: #27ae60; font-weight: 800;">6+</div>
                    <div style="color: #718096; font-weight: 600;">Năm Kinh Nghiệm</div>
                </div>
            </div>
        </div>

        <!-- Cơ sở vật chất -->
        <h2 class="section-title"><i class="fas fa-building me-2"></i>Cơ Sở Vật Chất</h2>
        <div class="intro-card mb-4 reveal">
            <ul style="font-size: 1.05rem; line-height: 2;">
                <li><strong>Loại sân:</strong> Sân 5 người, Sân 7 người, Sân 11 người</li>
                <li><strong>Mặt sân:</strong> Cỏ nhân tạo cao cấp, đạt tiêu chuẩn quốc tế</li>
                <li><strong>Hệ thống đèn:</strong> Chiếu sáng hiện đại cho trận đấu ban đêm</li>
                <li><strong>Tiện ích:</strong> Phòng thay đồ, WC, căng tin, bãi đỗ xe</li>
            </ul>
        </div>

        <!-- Cam kết -->
        <h2 class="section-title"><i class="fas fa-handshake me-2"></i>Cam Kết Chất Lượng</h2>
        <div class="intro-card mb-4 reveal">
            <ul style="font-size: 1.05rem; line-height: 2;">
                <li><strong>Bảo trì định kỳ:</strong> Sân được kiểm tra và bảo dưỡng thường xuyên</li>
                <li><strong>Giá cả minh bạch:</strong> Không phát sinh chi phí ẩn</li>
                <li><strong>Hỗ trợ 24/7:</strong> Đội ngũ chăm sóc khách hàng luôn sẵn sàng</li>
                <li><strong>Chính sách linh hoạt:</strong> Hủy miễn phí trước 24 giờ</li>
            </ul>
        </div>

        <!-- Timeline -->
        <h2 class="section-title"><i class="fas fa-history me-2"></i>Lịch Sử Phát Triển</h2>
        <div class="intro-card mb-4 reveal">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <h5 style="color: #27ae60; font-weight: 700;">2020 - Thành lập</h5>
                    <p>Khởi đầu with 3 sân bóng tại Đà Nẵng</p>
                </div>
                <div class="col-md-6 mb-3">
                    <h5 style="color: #27ae60; font-weight: 700;">2021 - Mở rộng</h5>
                    <p>Tăng lên 8 sân, đạt 5,000 khách hàng</p>
                </div>
                <div class="col-md-6 mb-3">
                    <h5 style="color: #27ae60; font-weight: 700;">2022 - Số hóa</h5>
                    <p>Ra mắt hệ thống đặt sân online</p>
                </div>
                <div class="col-md-6 mb-3">
                    <h5 style="color: #27ae60; font-weight: 700;">2023 - Thành công</h5>
                    <p>Top 5 sân bóng uy tín Đà Nẵng</p>
                </div>
            </div>
        </div>

        <!-- Điều khoản sử dụng -->
        <h2 class="section-title"><i class="fas fa-file-contract me-2"></i>Điều Khoản Sử Dụng</h2>
        <div class="intro-card mb-4 reveal">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <h5 style="color: #27ae60; font-weight: 700;"><i class="fas fa-clock me-2"></i>Đặt Sân & Hủy Sân</h5>
                    <ul style="font-size: 0.95rem; line-height: 1.8;">
                        <li>Đặt sân trước tối thiểu 2 giờ</li>
                        <li>Hủy sân miễn phí trước 48 giờ</li>
                        <li>Hủy sân 48h trước khi đá tính phí 30%</li>
                        <li>Không được phép huỷ sân trong 2 giờ trước giờ chơi</li>
                    </ul>
                </div>
                <div class="col-md-6 mb-3">
                    <h5 style="color: #27ae60; font-weight: 700;"><i class="fas fa-credit-card me-2"></i>Thanh Toán</h5>
                    <ul style="font-size: 0.95rem; line-height: 1.8;">
                        <li>Thanh toán online qua VNPay</li>
                        <li>Thanh toán tiền mặt/chuyển khoản tại sân</li>
                        <li>Đặt cọc 30% khi đặt online</li>
                        <li>Hoàn tiền trong 3-5 ngày làm việc</li>
                    </ul>
                </div>
                <div class="col-md-6 mb-3">
                    <h5 style="color: #27ae60; font-weight: 700;"><i class="fas fa-users me-2"></i>Quy Định Sân</h5>
                    <ul style="font-size: 0.95rem; line-height: 1.8;">
                        <li>Có mặt đúng giờ</li>
                        <li>Không mang đồ ăn, thức uống từ ngoài</li>
                        <li>Giữ gìn vệ sinh chung</li>
                    </ul>
                </div>
                <div class="col-md-6 mb-3">
                    <h5 style="color: #27ae60; font-weight: 700;"><i class="fas fa-shield-alt me-2"></i>Trách Nhiệm</h5>
                    <ul style="font-size: 0.95rem; line-height: 1.8;">
                        <li>Khách hàng tự chịu trách nhiệm an toàn</li>
                        <li>Bồi thường thiết bị hư hỏng</li>
                        <li>Tuân thủ quy định của sân</li>
                        <li>Báo cáo sự cố ngay lập tức</li>
                    </ul>
                </div>
            </div>
            <div class="mt-3 p-3" style="background: #f8f9fa; border-radius: 10px; border-left: 4px solid #27ae60;">
                <p class="mb-0" style="font-size: 0.9rem; color: #6c757d;">
                    <i class="fas fa-info-circle me-2"></i>
                    <strong>Lưu ý:</strong> Bằng việc sử dụng dịch vụ, khách hàng đồng ý tuân thủ các điều khoản trên. 
                    Sport Field có quyền từ chối phục vụ nếu vi phạm quy định.
                </p>
            </div>
        </div>

        <!-- CTA -->
        <div class="text-center reveal">
            <a href="${pageContext.request.contextPath}/shop" class="btn btn-lg" 
               style="background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%); color: white; padding: 15px 50px; border-radius: 50px; font-weight: 700; border: none; font-size: 1.1rem;">
                <i class="fas fa-futbol me-2"></i>Đặt Sân Ngay
            </a>
        </div>

    </div>

    <jsp:include page="../common/footer.jsp"></jsp:include>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
