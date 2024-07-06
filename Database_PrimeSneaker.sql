create database Database_PrimeSneaker
go

use Database_PrimeSneaker
go

create table Brand
(
	brand_id int identity(1,1) primary key,
	brand_name nvarchar(20),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	deleted bit default 1
)
go

create table Category
(
	category_id int identity(1,1) primary key,
	category_name nvarchar(50),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	deleted bit default 1
)
go

create table Size
(
	size_id int identity(1,1) primary key,
	size_number float,
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	deleted bit default 1,
	check (size_number > 0)
)
go

create table Color
(
	color_id int identity(1,1) primary key,
	color_name nvarchar(20),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	deleted bit default 1
)
go

create table Sole
(
	sole_id int identity(1,1) primary key,
	sole_name nvarchar(50),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	deleted bit default 1
)
go

create table Material
(
	material_id int identity(1,1) primary key,
	material_name nvarchar(50),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	deleted bit default 1
)
go

create table Voucher
(
	voucher_id int identity(1,1) primary key,
	voucher_code varchar(10) unique,
	quantity int check(quantity >= 0),
	[start_date] date,
	end_date date check(end_date <= getdate()),
	[type] varchar(10),
	[value] float check([value] >=0 and [value] <= 100),
	[status] nvarchar(30),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	deleted bit default 1
)
go

create table [Role]
(
	role_id int identity(1,1) primary key,
	role_name nvarchar(50)
)
go

create table [User]
(
	[user_id] int identity(1,1) primary key,
	role_id int,
	user_code varchar(10) unique,
	full_name nvarchar(60),
	gender bit,
	date_of_birth date check(date_of_birth <= getdate()),
	phone_number varchar(15),
	[address] nvarchar(150),
	email varchar(100),
	account_name varchar(30),
	[password] varchar(20),
	[status] nvarchar(50),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int
)
go

create table Customer
(
	customer_id int identity(1,1) primary key,
	full_name nvarchar(60),
	gender bit,
	date_of_birth date check(date_of_birth <= getdate()),
	[address] nvarchar(150),
	phone_number varchar(15),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int
)
go

create table PaymentMethod
(
	payment_method_id int identity(1,1) primary key,
	method_name nvarchar(50),
	[description] nvarchar(200),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	deleted bit default 1
)
go

create table Sneaker
(
	sneaker_id int identity(1,1) primary key,
	sneaker_name nvarchar(100),
	[description] nvarchar(200),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int
)
go

create table SneakerDetail
(
	sneaker_detail_id int identity(1,1) primary key,
	sneaker_id int,
	size_id int,
	color_id int,
	brand_id int,
	category_id int,
	sole_id int,
	material_id int,
	sneaker_detail_code varchar(10) unique,
	gender nvarchar(20),
	price money check(price > 0),
	quantity int check(quantity > 0),
	[status] nvarchar(50),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int
)
go

create table [Image]
(
	image_id int identity(1,1) primary key,
	sneaker_detail_id int,
	image_name nvarchar(50),
	image_url varchar(100),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	deleted bit default 1
)
go

create table [Order]
(
	order_id int identity(1,1) primary key,
	[user_id] int,
	customer_id int,
	voucher_id int,
	order_qr_code varchar(50),
	total_cost money check(total_cost >= 0),
	[change] money check([change] >= 0),
	[status] nvarchar(50),
	note nvarchar(255),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int
)
go

create table OrderDetail
(
	sneaker_detail_id int not null,
	order_id int not null,
	quantity int check(quantity >= 0),
	price money check(price > 0),
	total_cost money check(total_cost > 0),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	primary key(sneaker_detail_id, order_id)
)
go

create table OrderHistory
(
	order_history_id int identity(1,1) primary key,
	order_id int,
	total_cost money check(total_cost > 0),
	[status] nvarchar(50),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	deleted bit default 1
)
go

create table Exchange
(
	exchange_id int identity(1,1) primary key,
	order_id int,
	sneaker_detail_id int,
	reason nvarchar(100),
	[status] nvarchar(50),
	note nvarchar(255),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	deleted bit default 1
)
go

create table OrderPayment
(
	order_payment_id int identity(1,1) primary key,
	order_id int,
	payment_method_id int,
	total_cost money check(total_cost > 0),
	created_at date default getdate(),
	updated_at date default getdate(),
	created_by int,
	updated_by int,
	deleted bit default 1
)
go

alter table [Image] add foreign key (sneaker_detail_id) references SneakerDetail (sneaker_detail_id)

alter table SneakerDetail add foreign key (sneaker_id) references Sneaker (sneaker_id)
alter table SneakerDetail add foreign key (size_id) references Size (size_id)
alter table SneakerDetail add foreign key (color_id) references Color (color_id)
alter table SneakerDetail add foreign key (brand_id) references Brand (brand_id)
alter table SneakerDetail add foreign key (category_id) references Category (category_id)
alter table SneakerDetail add foreign key (sole_id) references Sole (sole_id)
alter table SneakerDetail add foreign key (material_id) references Material (material_id)

alter table OrderDetail add foreign key (sneaker_detail_id) references SneakerDetail (sneaker_detail_id)
alter table OrderDetail add foreign key (order_id) references [Order] (order_id)

alter table Exchange add foreign key (order_id) references [Order] (order_id)
alter table Exchange add foreign key (sneaker_detail_id) references SneakerDetail (sneaker_detail_id)

alter table [Order] add foreign key ([user_id]) references [User] ([user_id])
alter table [Order] add foreign key (customer_id) references Customer (customer_id)
alter table [Order] add foreign key (voucher_id) references Voucher (voucher_id)

alter table [User] add foreign key (role_id) references [Role] (role_id)

alter table OrderPayment add foreign key (order_id) references [Order] (order_id)
alter table OrderPayment add foreign key (payment_method_id) references PaymentMethod (payment_method_id)

alter table OrderHistory add foreign key (order_id) references [Order] (order_id)


insert into Brand(brand_name) values('Nike'), ('Adidas'), ('Li-ning'), ('Converse'), ('MLB'), ('Fila'), ('New Balance'), ('Jordan'), ('Puma'), ('VANS'), ('Reebok')

insert into Category(category_name) values (N'Giày bóng rổ'), (N'Giày chạy'), (N'Giày tập gym'), (N'Giày golf')

insert into Size(size_number) values (34),(35),(36),(37),(38),(39),(40),(41),(42),(43),(44),(44.5),(45),(46),(47),(47.5)

insert into Color(color_name) values (N'Trắng'), (N'Nâu'), (N'Xanh'), (N'Xám'), (N'Vàng'), (N'Đen'), (N'Lục'), (N'Hồng'), (N'Cam')

insert into Sole(sole_name) values(N'Đế cao su'), (N'Đế EVA'), (N'Đế PU'), (N'Đế da'), (N'Đế PVC'), (N'Đế TPR')

insert into Material(material_name) values(N'Da'), (N'Da Suede'), (N'Da Nubuck'), (N'Vải canvas'), (N'Vải Denim'), (N'Vật liệu tổng hợp')

insert into Sneaker(sneaker_name, [description]) values
--#den, da, nike
(N'Giày Nike Air Jordan 4', N'Phiên bản đặc biệt của dòng sản phẩm Air Jordan, được thiết kế để tôn vinh và tái hiện lại phiên bản kinh điển “Bred” (Black and Red) của dòng Air Jordan 4')

--xám, đế cao su, nike
insert into Sneaker(sneaker_name, [description]) values
(N'Jordan 1 High Dior', N'Được giới thiệu tại triển lãm “Paris 3020.” của nghệ sĩ đương đại Daniel Arsham')

--Đen, da, vải, nike
insert into Sneaker(sneaker_name, [description]) values
(N'Air Jordan Mid SE GS All Star 2021', N'Ra mắt kỷ niệm mùa giải của NBA với một thiết kế mới độc đáo')

--da, xanh, nike
insert into Sneaker(sneaker_name, [description]) values
(N'Jordan 1 Off White UNC', N'Ngay từ khi ra mắt đã nhận được nhiều sự chú ý, quan tâm rất lớn từ cộng đồng sneakerhead')

--trắng, da, nike
insert into Sneaker(sneaker_name, [description]) values
(N'Nike Air Force 1 Low Triple White', N'Là một trong những form dáng giày thể thao được giới trẻ quan tâm và yêu thích')

--trắng, da, adidas
insert into Sneaker(sneaker_name, [description]) values
(N'adidas Superstar White Black', N'Hiện đã có sẵn tại Sneaker Daily Shop')

--da suede, trắng, đen, nâu, đế EVA, adidas
insert into Sneaker(sneaker_name, [description]) values
(N'adidas Samba OG White Black Gum', N'Giày thể thao cổ điển được thiết kế dành cho bóng đá futsal')

--Xanh, adidas, vải
insert into Sneaker(sneaker_name, [description]) values
(N'adidas Runfalcon Dark Blue', N'Đã được bày bán trên Sneaker Daily Shop')

--Nâu, trắng, adidas
insert into Sneaker(sneaker_name, [description]) values
(N'adidas Forum Exhibit Low Off White Shadow Navy', N'Hiện đã có sẵn tại Sneaker Daily Shop')

--xám, vải, adidas
insert into Sneaker(sneaker_name, [description]) values
(N'Giày nữ Yeezy 500 Blush Desert Rat', N'Hiện đã có sẵn tại Sneaker Daily Shop')

--cao su, đen, converse
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Converse Run Star Motion Low Black', N'Với bộ đế chunky bản to này, chúng được chia thành 2 phần với đường răng để định hình cũng như giữ thăng bằng tốt hơn khi di chuyển')

--trắng, cao su, converse, 2.200.000₫ -> 1.390.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Converse Chuck 70 Hi', N' Là một trong những mẫu giày đang được nhiều bạn trẻ kiếm tìm hiện nay')

--converse, trắng, đế cao su, 2.990.000₫ 1.490.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Converse Chuck Taylor All Star White Black', N'Hứa hẹn là một siêu phẩm mà bất cứ sneakerhead nào cũng mong muốn sở hữu trong tủ giày của mình')

--converse, đen, 1.790.000₫ 900.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Converse Chuck Taylor All Star Black White Bold Wasabi', N'Là một siêu phẩm mà bất cứ sneakerhead nào cũng mong muốn sở hữu trong tủ giày của mình')

--converse, trắng, 5.090.000₫ 3.990.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Converse Comme des Garçons x Chuck Taylor All Star Hi Milk', N'Là một siêu phẩm mà bất cứ sneakerhead nào cũng mong muốn sở hữu trong tủ giày của mình')

--lining, xanh, bóng rổ, 1.490.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Li-Ning bóng rổ nam', N'Đôi giày chuyên dụng được thiết kế đặc biệt cho các vận động viên nam chơi bóng rổ')

--lining, trắng, nâu, bóng rổ, 1.490.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Li-Ning bóng rổ nam 2', N'Được thiết kế đặc biệt để mang lại hiệu suất tốt cho các vận động viên nam chơi bóng rổ')

--lining, trắng, 2.380.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Li-Ning Jinghong Sandshell', N'Phong cách thời trang, cá tính, trẻ trung, phù hợp cho đi học, đi làm, đi chơi, dạo phố')

--lining, vàng, hồng, 2.580.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Li-Ning Super Light 20 Neon Olivine', N'Năng động, trẻ trung, phù hợp cho tập luyện và thi đấu')

--fila, trắng, 1.490.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Fila Ranger White Navy', N'Mức giá hấp dẫn, đừng bỏ lỡ cơ hội')

--fila, trắng, 2.290.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Fila Disruptor 2 Scotch White', N'Là một phiên bản đặc biệt của dòng giày Fila Disruptor 2')

--fila, vàng, 2.090.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Fila Ray Tracer Cream Yellow', N'Đôi giày thể thao với thiết kế hiện đại và phong cách retro')

--fila, cream-black, 1.590.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày FILA Raid N3 2.0 Cream Black', N'Phiên bản phối màu mới của dòng giày FILA Raid N3 2.0')

--jordan, trắng-đen, 6.290.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày nam Air Jordan 35 DNA', N'Giày bóng rổ Jordan')

--jordan, trắng-xanh, 4.690.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Air Jordan 35 PF Sisterhood', N'Mức giá hấp dẫn nhất')

--jordan, đỏ-đen, 4.690.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày nam Air Jordan 35 Chinese New Year', N'Chinese New Year')

--jordan, đỏ-đen, 7.990.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày nam Air Jordan 35 Bred', N'Giày bóng rổ Jordan')

--mlb, trắng, 2.790.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày MLB Chunky Liner New York Yankees Off White', N'No description')

--mlb, đen, 1.290.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày MLB Playball Origin Mule New York Yankees Black', N'Phong cách Mule giúp người mang có được những sự lựa chọn đa dạng outfit để phối cùng')

--mlb, trắng, 1.500.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày MLB BigBall Chunky P Boston Red Sox', N'Phong cách Chunky ')

--mlb, trắng, 3.390.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày MLB Bigball Chunky Mono Heel Boston Red Sox', N'Tạo độ đàn hồi mang lại cảm giác cực kỳ thoải mái, nhẹ nhàng và dễ chịu')

--newb, trắng-lục, 3.790.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày New Balance 550 White Green', N'Một thương hiệu thời trang và giày thể thao từ Mỹ')

--newb, trắng, 2.590.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày New Balance 530 Retro Running Navy', N'Một thương hiệu thời trang và giày thể thao từ Mỹ')

--newb, trắng-đỏ, 4.090.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày New Balance 550 White Team Red', N'Một thương hiệu thời trang và giày thể thao từ Mỹ')

--newb, xám, 1.690.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày New Balance 530 Raincloud', N'Phiên bản thuộc dòng giày thể thao cổ điển của New Balance')

--puma, 1.990.000₫, trắng
insert into Sneaker(sneaker_name, [description]) values
(N'Giày nữ Puma Basket Heart Patent White', N'Giày nữ Puma')

--puma, trắng, 1.980.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Puma Smash Vulc Mule White', N'No description')

--puma, trắng-đen, 2.980.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Puma Mayze White Black', N'PUMA bắt tay với MTV để tạo ra một phiên bản RS-X mới')

--puma, xanh, 2.090.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày nam Puma Suede Classic+ Olympian Blue', N'Khả năng chống thấm nước trên cả tuyệt vời, độ bền màu, chất liệu êm ái')

--reebok, trắng-xanh, 790.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Reebok Mega Flexagon White Neon Blue', N'No description')

--reebok, trắng, 1.890.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Reebok Club MEMT Chalk Vector Navy', N'No description')

--reebok, đen, 1.790.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Reebok Royal Pervader Black Sahara', N'No description')

--reebok, trắng, 1.790.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Reebok Royal Turbo Impuls', N'Phù hợp cho những người yêu thích phong cách thể thao và đang tìm kiếm một đôi giày thể thao năng động và trẻ trung')

--vans, trắng, 2.290.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Vans Style 36 Decon SF Black Pont', N'No description')

--vans, trắng, 2.290.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Vans Old Skool Black Flame', N'No description')

--vans, trắng, 2.500.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Vans Bedwin & The Heartbreakers x Authentic', N'No description')

--vans, đen-lục, 1.690.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Vans Old Skool Black Teal', N'No description')

--vans, trắng, 2.690.000₫
insert into Sneaker(sneaker_name, [description]) values
(N'Giày Vans Knu Skool Red White', N'Lựa chọn hoàn hảo cho những ai yêu thích phong cách đường phố và thể thao')

select * from Sneaker