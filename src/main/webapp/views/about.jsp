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
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #f8f9fa;
        }
        
        .about-hero {
            background: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.6)), 
                        url('https://images.unsplash.com/photo-1459865264687-595d652de67e?w=1920&q=80') center/cover;
            color: white;
            padding: 120px 0 100px;
            margin-bottom: 50px;
            position: relative;
            overflow: hidden;
        }
        
        .about-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(46, 204, 113, 0.7) 0%, rgba(39, 174, 96, 0.7) 100%);
            animation: pulse 3s ease-in-out infinite;
        }
        
        @keyframes pulse {
            0%, 100% { opacity: 0.7; }
            50% { opacity: 0.85; }
        }
        
        .about-hero .container {
            position: relative;
            z-index: 1;
        }
        
        .about-hero h1 {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .about-hero p {
            font-size: 1.4rem;
            opacity: 0.95;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
        }
        
        .section-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: #2d3748;
        }
        
        .intro-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            border-left: 5px solid #27ae60;
        }
        
        .intro-card h3 {
            color: #27ae60;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .intro-card p {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #4a5568;
        }
        
        .mission-card {
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
            color: white;
            border-radius: 20px;
            padding: 35px;
            margin-bottom: 20px;
            height: 100%;
            box-shadow: 0 10px 30px rgba(46, 204, 113, 0.3);
            transition: transform 0.3s;
        }
        
        .mission-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(46, 204, 113, 0.4);
        }
        
        .mission-card h4 {
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .mission-card p {
            font-size: 1rem;
            line-height: 1.7;
            margin: 0;
            opacity: 0.95;
        }
    </style>
</head>
<body>

    <jsp:include page="common/header.jsp"></jsp:include>

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
        <div class="intro-card">
            <h3><i class="fas fa-building me-2"></i>Giới Thiệu Công Ty</h3>
            <p>
                <strong>Sport Field</strong> là hệ thống sân bóng đá chuyên nghiệp được thành lập vào năm <strong>2020</strong> tại <strong>Đà Nẵng</strong>. 
                Với mục tiêu mang đến trải nghiệm thể thao tốt nhất cho cộng đồng yêu bóng đá, chúng tôi không ngừng 
                phát triển và cải tiến chất lượng dịch vụ.
            </p>
            <p class="mb-0">
                Hiện tại, Sport Field sở hữu hơn <strong>15 sân bóng</strong> trải dài khắp Đà Nẵng, được trang bị hiện đại với cỏ nhân tạo cao cấp, 
                hệ thống đèn chiếu sáng chuyên nghiệp và đã phục vụ hơn <strong>10,000 khách hàng</strong> với đánh giá 
                <strong>4.8/5 sao</strong>. Chúng tôi tự hào là đơn vị hàng đầu trong lĩnh vực cho thuê sân bóng tại thành phố biển xinh đẹp.
            </p>
        </div>

        <!-- Mission & Values -->
        <div class="row mb-4">
            <div class="col-md-6 mb-3">
                <div class="mission-card">
                    <h4><i class="fas fa-bullseye me-2"></i>Sứ Mệnh</h4>
                    <p>Mang đến trải nghiệm thể thao tốt nhất cho cộng đồng yêu bóng đá. Chúng tôi cam kết cung cấp 
                    sân bóng chất lượng cao, dịch vụ chuyên nghiệp và môi trường an toàn.</p>
                </div>
            </div>
            <div class="col-md-6 mb-3">
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
            <div class="col-md-3 col-6 mb-3">
                <div class="intro-card text-center" style="border-left: none; padding: 25px;">
                    <i class="fas fa-futbol" style="font-size: 2.5rem; color: #27ae60; margin-bottom: 15px;"></i>
                    <div style="font-size: 2.5rem; color: #27ae60; font-weight: 800;">15+</div>
                    <div style="color: #718096; font-weight: 600;">Sân Bóng</div>
                </div>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <div class="intro-card text-center" style="border-left: none; padding: 25px;">
                    <i class="fas fa-users" style="font-size: 2.5rem; color: #27ae60; margin-bottom: 15px;"></i>
                    <div style="font-size: 2.5rem; color: #27ae60; font-weight: 800;">10K+</div>
                    <div style="color: #718096; font-weight: 600;">Khách Hàng</div>
                </div>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <div class="intro-card text-center" style="border-left: none; padding: 25px;">
                    <i class="fas fa-star" style="font-size: 2.5rem; color: #27ae60; margin-bottom: 15px;"></i>
                    <div style="font-size: 2.5rem; color: #27ae60; font-weight: 800;">4.8</div>
                    <div style="color: #718096; font-weight: 600;">Đánh Giá</div>
                </div>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <div class="intro-card text-center" style="border-left: none; padding: 25px;">
                    <i class="fas fa-calendar-check" style="font-size: 2.5rem; color: #27ae60; margin-bottom: 15px;"></i>
                    <div style="font-size: 2.5rem; color: #27ae60; font-weight: 800;">6+</div>
                    <div style="color: #718096; font-weight: 600;">Năm Kinh Nghiệm</div>
                </div>
            </div>
        </div>

        <!-- Cơ sở vật chất -->
        <h2 class="section-title"><i class="fas fa-building me-2"></i>Cơ Sở Vật Chất</h2>
        <div class="intro-card mb-4">
            <ul style="font-size: 1.05rem; line-height: 2;">
                <li><strong>Loại sân:</strong> Sân 5 người, Sân 7 người, Sân 11 người</li>
                <li><strong>Mặt sân:</strong> Cỏ nhân tạo cao cấp, đạt tiêu chuẩn quốc tế</li>
                <li><strong>Hệ thống đèn:</strong> Chiếu sáng hiện đại cho trận đấu ban đêm</li>
                <li><strong>Tiện ích:</strong> Phòng thay đồ, WC, căng tin, bãi đỗ xe</li>
            </ul>
        </div>

        <!-- Cam kết -->
        <h2 class="section-title"><i class="fas fa-handshake me-2"></i>Cam Kết Chất Lượng</h2>
        <div class="intro-card mb-4">
            <ul style="font-size: 1.05rem; line-height: 2;">
                <li><strong>Bảo trì định kỳ:</strong> Sân được kiểm tra và bảo dưỡng thường xuyên</li>
                <li><strong>Giá cả minh bạch:</strong> Không phát sinh chi phí ẩn</li>
                <li><strong>Hỗ trợ 24/7:</strong> Đội ngũ chăm sóc khách hàng luôn sẵn sàng</li>
                <li><strong>Chính sách linh hoạt:</strong> Hủy miễn phí trước 24h</li>
            </ul>
        </div>

        <!-- Timeline -->
        <h2 class="section-title"><i class="fas fa-history me-2"></i>Lịch Sử Phát Triển</h2>
        <div class="intro-card mb-4">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <h5 style="color: #27ae60; font-weight: 700;">2020 - Thành lập</h5>
                    <p>Khởi đầu với 3 sân bóng tại Đà Nẵng</p>
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
        <div class="intro-card mb-4">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <h5 style="color: #27ae60; font-weight: 700;"><i class="fas fa-clock me-2"></i>Đặt Sân & Hủy Sân</h5>
                    <ul style="font-size: 0.95rem; line-height: 1.8;">
                        <li>Đặt sân trước tối thiểu 2 tiếng</li>
                        <li>Hủy miễn phí trước 24 tiếng</li>
                        <li>Hủy trong 24h tính phí 50%</li>
                        <li>Không hủy được trong 2h trước giờ chơi</li>
                    </ul>
                </div>
                <div class="col-md-6 mb-3">
                    <h5 style="color: #27ae60; font-weight: 700;"><i class="fas fa-credit-card me-2"></i>Thanh Toán</h5>
                    <ul style="font-size: 0.95rem; line-height: 1.8;">
                        <li>Thanh toán online qua VNPay</li>
                        <li>Thanh toán tiền mặt tại sân</li>
                        <li>Đặt cọc 30% khi đặt online</li>
                        <li>Hoàn tiền trong 3-5 ngày làm việc</li>
                    </ul>
                </div>
                <div class="col-md-6 mb-3">
                    <h5 style="color: #27ae60; font-weight: 700;"><i class="fas fa-users me-2"></i>Quy Định Sân</h5>
                    <ul style="font-size: 0.95rem; line-height: 1.8;">
                        <li>Có mặt đúng giờ, trễ 15p mất slot</li>
                        <li>Không mang đồ ăn, thức uống từ ngoài</li>
                        <li>Giữ gìn vệ sinh chung</li>
                        <li>Không hút thuốc trong khu vực sân</li>
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
        <div class="text-center">
            <a href="${pageContext.request.contextPath}/shop" class="btn btn-lg" 
               style="background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%); color: white; padding: 15px 50px; border-radius: 50px; font-weight: 700; border: none; font-size: 1.1rem;">
                <i class="fas fa-futbol me-2"></i>Đặt Sân Ngay
            </a>
        </div>

    </div>

    <jsp:include page="common/footer.jsp"></jsp:include>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
