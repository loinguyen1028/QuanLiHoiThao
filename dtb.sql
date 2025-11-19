CREATE DATABASE quan_li_hoi_thao;
USE quan_li_hoi_thao;

CREATE TABLE Admin (
    id_admin INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50)
);

CREATE TABLE category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE seminar (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    location VARCHAR(255),
    speaker VARCHAR(255),
    category_id INT,
    max_attendees INT DEFAULT 0,
    status VARCHAR(50) DEFAULT 'Đang mở đăng ký',
    image_url VARCHAR(500),
    FOREIGN KEY (category_id) REFERENCES category(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seminar_id INT NOT NULL,
    register_date DATE DEFAULT (CURRENT_DATE),
    registration_code VARCHAR(50),
    is_vip BOOLEAN DEFAULT FALSE,
    checkin_time DATETIME,

    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255),
    phone VARCHAR(20),
    user_type VARCHAR(50),

    FOREIGN KEY (seminar_id) REFERENCES seminar(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

ALTER TABLE category
CHANGE COLUMN name categoryName VARCHAR(100) NOT NULL;
INSERT INTO category (id, categoryName)
VALUES
    (1, 'Hội thảo môi trường'),
    (2, 'Hội thảo công nghệ'),
    (3, 'Hội thảo khoa học');

INSERT INTO seminar 
(name, description, start_date, end_date, location, speaker, category_id, max_attendees, status, image_url)
VALUES
('Giải pháp giảm ô nhiễm không khí tại đô thị1',
 'Thảo luận giải pháp công nghệ và chính sách nhằm giảm ô nhiễm tại các thành phố lớn1.',
 '2025-12-10 08:00:00', '2025-12-10 11:30:00',
 'Hội trường A, ĐHQG TP.HCM1',
 'PGS.TS Nguyễn Văn Long1',
 2, 200, 'Đang mở đăng ký',
 'images/seminar1.jpg'),

('Ứng dụng AI trong chuyển đổi số doanh nghiệp',
 'Chia sẻ kinh nghiệm triển khai AI trong sản xuất và vận hành doanh nghiệp.',
 '2025-12-15 09:00:00', '2025-12-15 12:00:00',
 'Trung tâm Hội nghị GEM Center, TP.HCM',
 'TS. Lê Hoàng Minh',
 2, 300, 'Đang mở đăng ký',
 'images/seminar2.jpg'),

('Nghiên cứu công nghệ pin mới cho xe điện',
 'Cập nhật tiến bộ khoa học về pin thể rắn và hướng phát triển trong tương lai.',
 '2025-12-20 13:30:00', '2025-12-20 17:00:00',
 'Hội trường B, Đại học Bách Khoa',
 'GS. Trần Quốc Tuấn',
 3, 150, 'Đang mở đăng ký',
 'images/seminar3.jpg');

INSERT INTO seminar 
(name, description, start_date, end_date, location, speaker, category_id, max_attendees, status, image_url)
VALUES
('Xu hướng năng lượng tái tạo năm 2025',
 'Phân tích các công nghệ năng lượng gió – mặt trời – hydrogen và tiềm năng ứng dụng tại Việt Nam.',
 '2025-12-22 08:00:00', '2025-12-22 11:30:00',
 'Hội trường lớn – Đại học Sư phạm Kỹ thuật TP.HCM',
 'TS. Phạm Văn Hải',
 3, 180, 'Đang mở đăng ký',
 'images/seminar4.jpg'),

('Ứng dụng IoT trong quản lý đô thị thông minh',
 'Giới thiệu các mô hình và giải pháp IoT giúp tối ưu hóa vận hành đô thị và nâng cao chất lượng cuộc sống.',
 '2025-12-25 09:00:00', '2025-12-25 12:00:00',
 'Trung tâm Hội nghị Quốc tế TP.HCM',
 'ThS. Lê Minh Tâm',
 2, 250, 'Đang mở đăng ký',
 'images/seminar5.jpg'),

('An toàn thông tin trong thời đại AI',
 'Nhận diện rủi ro và chiến lược bảo mật dành cho doanh nghiệp khi triển khai ứng dụng trí tuệ nhân tạo.',
 '2025-12-28 13:00:00', '2025-12-28 16:30:00',
 'Hội trường B – Đại học Công nghệ Thông tin',
 'PGS.TS. Đỗ Quang Vinh',
 2, 220, 'Đang mở đăng ký',
 'images/seminar6.jpg');


 select * from seminar;
 select * from registrations;