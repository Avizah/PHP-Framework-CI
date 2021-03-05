-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 17, 2018 at 05:36 PM
-- Server version: 10.1.30-MariaDB
-- PHP Version: 7.2.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_perpus`
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_buku`
--

CREATE TABLE `tb_buku` (
  `kd_buku` int(5) NOT NULL,
  `kd_genre` int(5) NOT NULL,
  `kd_subgenre` int(5) NOT NULL,
  `judul` varchar(30) NOT NULL,
  `kd_penulis` int(5) NOT NULL,
  `kd_penerbit` int(5) NOT NULL,
  `tahun_terbit` year(4) NOT NULL,
  `edisi` varchar(3) NOT NULL,
  `isbn` varchar(13) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_buku`
--

INSERT INTO `tb_buku` (`kd_buku`, `kd_genre`, `kd_subgenre`, `judul`, `kd_penulis`, `kd_penerbit`, `tahun_terbit`, `edisi`, `isbn`) VALUES
(6, 4, 5, 'Eloquent JavaScript', 4, 2, 2014, '2', '9781593276614'),
(7, 4, 6, 'Pengantar Teknologi Informasi', 5, 3, 2014, '-', '9786022803690'),
(8, 5, 7, 'Spiritual Capital', 6, 4, 2004, '-', '9781609943912'),
(9, 5, 8, 'Kiat Sukses Menetaskan Telur', 7, 5, 2012, '-', '9789790064287'),
(10, 7, 9, 'A Little History of Economics', 8, 6, 2017, '-', '9780300226317'),
(11, 7, 10, 'Sapiens: A Brief History ', 9, 7, 2015, '-', '9780062316103'),
(12, 8, 11, 'Lonely Planet Trekking in the ', 10, 8, 2015, '-', '9781760340056'),
(13, 8, 12, 'London Travel Guide 2018', 11, 9, 2015, '-', '9781609943621'),
(14, 9, 13, 'Smart Grammar', 12, 10, 2014, '3', '9786021576137'),
(15, 9, 14, 'Pintar Bahasa Jepang', 13, 11, 2014, '2', '9789797752200'),
(16, 9, 15, 'Bebas', 6, 4, 1998, '1', '123');

-- --------------------------------------------------------

--
-- Table structure for table `tb_detailpeminjaman`
--

CREATE TABLE `tb_detailpeminjaman` (
  `no_data` int(5) NOT NULL,
  `kd_transaksi` int(5) NOT NULL,
  `kd_buku` int(5) NOT NULL,
  `status` enum('T','F') NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_detailpeminjaman`
--

INSERT INTO `tb_detailpeminjaman` (`no_data`, `kd_transaksi`, `kd_buku`, `status`) VALUES
(3, 2, 11, 'F'),
(4, 3, 9, 'F'),
(5, 3, 8, 'T'),
(6, 3, 10, 'F'),
(7, 4, 7, 'T'),
(8, 4, 6, 'T');

--
-- Triggers `tb_detailpeminjaman`
--
DELIMITER $$
CREATE TRIGGER `peminjaman_delete_update` BEFORE DELETE ON `tb_detailpeminjaman` FOR EACH ROW BEGIN
	UPDATE tb_stokbuku SET jml_stok = jml_stok + 1
    	WHERE kd_buku = OLD.kd_buku;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `peminjaman_insert_update` AFTER INSERT ON `tb_detailpeminjaman` FOR EACH ROW BEGIN
	UPDATE tb_stokbuku SET jml_stok = jml_stok - 1
    	WHERE kd_buku = NEW.kd_buku;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_detailpengembalian`
--

CREATE TABLE `tb_detailpengembalian` (
  `no_data` int(5) NOT NULL,
  `kd_transaksi` int(5) NOT NULL,
  `kd_peminjaman` int(5) NOT NULL,
  `kd_buku` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_detailpengembalian`
--

INSERT INTO `tb_detailpengembalian` (`no_data`, `kd_transaksi`, `kd_peminjaman`, `kd_buku`) VALUES
(5, 7, 4, 7),
(6, 7, 4, 6),
(7, 8, 3, 8);

--
-- Triggers `tb_detailpengembalian`
--
DELIMITER $$
CREATE TRIGGER `pengembalian_delete_update` BEFORE DELETE ON `tb_detailpengembalian` FOR EACH ROW BEGIN
	UPDATE tb_stokbuku SET jml_stok = jml_stok - 1
    	WHERE kd_buku = OLD.kd_buku;
    UPDATE tb_detailpeminjaman SET tb_detailpeminjaman.status = 'F'
    	WHERE kd_buku = OLD.kd_buku
        AND kd_transaksi = OLD.kd_peminjaman;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `pengembalian_insert_update` AFTER INSERT ON `tb_detailpengembalian` FOR EACH ROW BEGIN
	UPDATE tb_stokbuku SET jml_stok = jml_stok + 1
    	WHERE kd_buku = NEW.kd_buku;
    UPDATE tb_detailpeminjaman SET tb_detailpeminjaman.status = 'T'
    	WHERE kd_buku = NEW.kd_buku
        AND kd_transaksi = NEW.kd_peminjaman;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_genre`
--

CREATE TABLE `tb_genre` (
  `kd_genre` int(5) NOT NULL,
  `nama_genre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_genre`
--

INSERT INTO `tb_genre` (`kd_genre`, `nama_genre`) VALUES
(4, 'Komputer & Teknologi'),
(5, 'Bisnis & Investasi'),
(7, 'Sejarah'),
(8, 'Wisata'),
(9, 'Bahasa Asing');

-- --------------------------------------------------------

--
-- Table structure for table `tb_member`
--

CREATE TABLE `tb_member` (
  `id_member` int(5) NOT NULL,
  `nama` varchar(30) NOT NULL,
  `alamat` varchar(50) NOT NULL,
  `tempat_lahir` varchar(20) NOT NULL,
  `tgl_lahir` date NOT NULL,
  `jenkel` varchar(1) NOT NULL,
  `no_kontak` varchar(13) NOT NULL,
  `email` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_member`
--

INSERT INTO `tb_member` (`id_member`, `nama`, `alamat`, `tempat_lahir`, `tgl_lahir`, `jenkel`, `no_kontak`, `email`) VALUES
(1, 'Yudha Permana', 'Jakarta Selatan', 'Jakarta Selatan', '1998-06-23', 'P', '087888977103', 'yudhapermana@gmail.com'),
(2, 'Muhammad Ammar Fakhri', 'Kutabumi', 'Tangerang', '1998-05-15', 'P', '082298069486', 'amfakh@gmail.com'),
(3, 'Jessica', 'Cipadu', 'Tangerang', '1998-10-21', 'W', '08988632180', 'jessica@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `tb_peminjaman`
--

CREATE TABLE `tb_peminjaman` (
  `kd_transaksi` int(5) NOT NULL,
  `tgl_pinjam` date NOT NULL,
  `kd_member` int(5) NOT NULL,
  `kd_staf` int(5) NOT NULL,
  `tgl_jth_tempo` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_peminjaman`
--

INSERT INTO `tb_peminjaman` (`kd_transaksi`, `tgl_pinjam`, `kd_member`, `kd_staf`, `tgl_jth_tempo`) VALUES
(2, '2018-06-22', 2, 1, '2018-07-06'),
(3, '2018-06-24', 1, 3, '2018-07-08'),
(4, '2018-06-20', 3, 2, '2018-07-04');

--
-- Triggers `tb_peminjaman`
--
DELIMITER $$
CREATE TRIGGER `clear_detail_peminjaman` BEFORE DELETE ON `tb_peminjaman` FOR EACH ROW BEGIN
	DELETE FROM tb_detailpeminjaman
    	WHERE kd_transaksi = OLD.kd_transaksi;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_penerbit`
--

CREATE TABLE `tb_penerbit` (
  `kd_penerbit` int(5) NOT NULL,
  `nama` varchar(30) NOT NULL,
  `alamat` varchar(50) NOT NULL,
  `no_kontak` varchar(13) NOT NULL,
  `email` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_penerbit`
--

INSERT INTO `tb_penerbit` (`kd_penerbit`, `nama`, `alamat`, `no_kontak`, `email`) VALUES
(2, 'No Starch Press', 'Barcelona', '-', 'info@nostarch.com'),
(3, 'deePublish', 'Jakarta', '-', 'deepublish@gmail.com'),
(4, 'Berrett-Koehler Publishers', 'California', '(800)929-2929', 'bkpub@bkpub.com'),
(5, 'AgroMedia', 'Jakarta', '021-78883030', 'redaksi@agromedia.com'),
(6, 'Yale University Press', 'Amerika', '+60 11-3745 2', 'trade@yaleup.co.uk'),
(7, 'Harper Collins', 'New York', '+44 208741707', 'enquiries@harpercollins.c'),
(8, 'Lonely Planet', 'Australia', '(03) 8379 800', ' social@lonelyplanet.com'),
(9, 'T Turner', 'Amerika', '404-827-1700', 'turner.info@turner.com'),
(10, 'Ruang Kelas', 'Surabaya', '087877892584', 'cs@bukabuku.com'),
(11, 'IndonesiaTera', 'Yogyakarta', '0274 583421', 'redaksi@indonesiatera.com');

-- --------------------------------------------------------

--
-- Table structure for table `tb_pengembalian`
--

CREATE TABLE `tb_pengembalian` (
  `kd_transaksi` int(5) NOT NULL,
  `tgl_pengembalian` date NOT NULL,
  `kd_member` int(5) NOT NULL,
  `kd_staf` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_pengembalian`
--

INSERT INTO `tb_pengembalian` (`kd_transaksi`, `tgl_pengembalian`, `kd_member`, `kd_staf`) VALUES
(7, '2018-07-03', 3, 1),
(8, '2018-07-10', 1, 3);

--
-- Triggers `tb_pengembalian`
--
DELIMITER $$
CREATE TRIGGER `clear_detail_pengembalian` BEFORE DELETE ON `tb_pengembalian` FOR EACH ROW BEGIN
	DELETE FROM tb_detailpengembalian
    	WHERE kd_transaksi = OLD.kd_transaksi;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_penulis`
--

CREATE TABLE `tb_penulis` (
  `kd_penulis` int(5) NOT NULL,
  `nama` varchar(30) NOT NULL,
  `alamat` varchar(50) NOT NULL,
  `tempat_lahir` varchar(20) NOT NULL,
  `tgl_lahir` date NOT NULL,
  `jenkel` varchar(1) NOT NULL,
  `no_kontak` varchar(13) NOT NULL,
  `email` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_penulis`
--

INSERT INTO `tb_penulis` (`kd_penulis`, `nama`, `alamat`, `tempat_lahir`, `tgl_lahir`, `jenkel`, `no_kontak`, `email`) VALUES
(4, 'Marijn Haverbeke', 'Barcelona', 'Barcelona', '1970-02-06', 'P', '-', 'marijnh@gmail.com'),
(5, 'Edy Irwansyah', 'Jakarta', 'Jakarta', '1956-03-15', 'P', '-', 'edyirwansyah@binus.ac.id'),
(6, 'Ian Marshall', 'Amerika', 'Scotland', '1966-09-08', 'P', '-', 'Ian.Marshall@ed.ac.uk'),
(7, 'Tirto Hartono', 'Semarang', 'Semarang', '1940-04-28', 'P', '-', '-'),
(8, 'Niall Kishtainy', 'London', 'London', '1955-08-20', 'P', '-', 'niall@niallkishtainy.com'),
(9, 'Yuval Noah Harari', 'UK', 'Ibrani, Israel', '1976-02-24', 'P', '-', 'www.ynharari.com'),
(10, 'Lonely Planet', 'Australia', 'New York', '1973-02-14', 'W', '(03) 8379 800', 'privacy@lonelyplanet.com'),
(11, 'T Turner', 'Amerika', 'Amerika', '1988-05-07', 'P', '404-827-1700', 'turner.info@turner.com'),
(12, 'Jerry Mahas', 'Surabaya', 'Surabaya', '1989-03-09', 'P', '021-57932696', 'upptpa@gmail.com'),
(13, 'Primasari N. Dewi', 'Yogyakarta', 'Bantul', '1986-10-18', 'W', '08976888133', 'primasari.n.dewi@gmail.co');

-- --------------------------------------------------------

--
-- Table structure for table `tb_staf`
--

CREATE TABLE `tb_staf` (
  `id_staf` int(5) NOT NULL,
  `nama` varchar(30) NOT NULL,
  `alamat` varchar(50) NOT NULL,
  `tempat_lahir` varchar(20) NOT NULL,
  `tgl_lahir` date NOT NULL,
  `jenkel` varchar(1) NOT NULL,
  `no_kontak` varchar(13) NOT NULL,
  `email` varchar(25) NOT NULL,
  `level` varchar(15) NOT NULL,
  `user` varchar(10) NOT NULL,
  `password` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_staf`
--

INSERT INTO `tb_staf` (`id_staf`, `nama`, `alamat`, `tempat_lahir`, `tgl_lahir`, `jenkel`, `no_kontak`, `email`, `level`, `user`, `password`) VALUES
(1, 'Imam Nududdin', 'Pondok Ranji', 'Tangerang', '1998-02-24', 'P', '085810558921', 'imannududin@gmail.com', 'Admin', 'Imam', '202cb962ac59075b964b07152d234b70'),
(2, 'Bimo Tunggal Dewo', 'Pondok Aren', 'Tangerang Selatan', '1998-02-04', 'P', '085774266989', 'btunggaldewo@gmail.com', 'Pegawai', 'BimoTD', '202cb962ac59075b964b07152d234b70'),
(3, 'Fiki Fadlan', 'Ciledug', 'Tangerang', '1998-05-06', 'P', '087887152617', 'fiki.fadlan@outlook.com', 'Pegawai', 'FikiFadlan', '202cb962ac59075b964b07152d234b70');

-- --------------------------------------------------------

--
-- Table structure for table `tb_stokbuku`
--

CREATE TABLE `tb_stokbuku` (
  `kd_buku` int(5) NOT NULL,
  `jml_stok` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_stokbuku`
--

INSERT INTO `tb_stokbuku` (`kd_buku`, `jml_stok`) VALUES
(6, 472),
(7, 318),
(8, 216),
(9, 107),
(10, 287),
(11, 4),
(12, 49),
(13, 56),
(14, 200),
(15, 406),
(16, 2);

-- --------------------------------------------------------

--
-- Table structure for table `tb_subgenre`
--

CREATE TABLE `tb_subgenre` (
  `kd_subgenre` int(5) NOT NULL,
  `kd_genre` int(5) NOT NULL,
  `nama_subgenre` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_subgenre`
--

INSERT INTO `tb_subgenre` (`kd_subgenre`, `kd_genre`, `nama_subgenre`) VALUES
(5, 4, 'Bahasa Pemrograman'),
(6, 4, 'Ilmu Komputer'),
(7, 5, 'Etika Bisnis'),
(8, 5, 'Kewiraswastaan'),
(9, 7, 'Dunia'),
(10, 7, 'Peradaban'),
(11, 8, 'Asia'),
(12, 8, 'Eropa'),
(13, 9, 'Bahasa Inggris'),
(14, 9, ''),
(15, 9, 'Bebas');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_buku`
--
ALTER TABLE `tb_buku`
  ADD PRIMARY KEY (`kd_buku`),
  ADD KEY `kd_genre` (`kd_genre`),
  ADD KEY `kd_subgenre` (`kd_subgenre`),
  ADD KEY `kd_penerbit` (`kd_penerbit`),
  ADD KEY `kd_penulis` (`kd_penulis`,`kd_penerbit`) USING BTREE;

--
-- Indexes for table `tb_detailpeminjaman`
--
ALTER TABLE `tb_detailpeminjaman`
  ADD PRIMARY KEY (`no_data`),
  ADD KEY `kd_transaksi` (`kd_transaksi`,`kd_buku`) USING BTREE,
  ADD KEY `kd_buku` (`kd_buku`);

--
-- Indexes for table `tb_detailpengembalian`
--
ALTER TABLE `tb_detailpengembalian`
  ADD PRIMARY KEY (`no_data`),
  ADD KEY `kd_transaksi` (`kd_transaksi`,`kd_buku`) USING BTREE,
  ADD KEY `kd_buku` (`kd_buku`),
  ADD KEY `kd_peminjaman` (`kd_peminjaman`);

--
-- Indexes for table `tb_genre`
--
ALTER TABLE `tb_genre`
  ADD PRIMARY KEY (`kd_genre`);

--
-- Indexes for table `tb_member`
--
ALTER TABLE `tb_member`
  ADD PRIMARY KEY (`id_member`);

--
-- Indexes for table `tb_peminjaman`
--
ALTER TABLE `tb_peminjaman`
  ADD PRIMARY KEY (`kd_transaksi`),
  ADD KEY `kd_member` (`kd_member`,`kd_staf`),
  ADD KEY `kd_staf` (`kd_staf`);

--
-- Indexes for table `tb_penerbit`
--
ALTER TABLE `tb_penerbit`
  ADD PRIMARY KEY (`kd_penerbit`);

--
-- Indexes for table `tb_pengembalian`
--
ALTER TABLE `tb_pengembalian`
  ADD PRIMARY KEY (`kd_transaksi`),
  ADD KEY `kd_member` (`kd_member`,`kd_staf`),
  ADD KEY `kd_staf` (`kd_staf`);

--
-- Indexes for table `tb_penulis`
--
ALTER TABLE `tb_penulis`
  ADD PRIMARY KEY (`kd_penulis`);

--
-- Indexes for table `tb_staf`
--
ALTER TABLE `tb_staf`
  ADD PRIMARY KEY (`id_staf`);

--
-- Indexes for table `tb_stokbuku`
--
ALTER TABLE `tb_stokbuku`
  ADD PRIMARY KEY (`kd_buku`);

--
-- Indexes for table `tb_subgenre`
--
ALTER TABLE `tb_subgenre`
  ADD PRIMARY KEY (`kd_subgenre`),
  ADD KEY `kd_genre` (`kd_genre`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_buku`
--
ALTER TABLE `tb_buku`
  MODIFY `kd_buku` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `tb_detailpeminjaman`
--
ALTER TABLE `tb_detailpeminjaman`
  MODIFY `no_data` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tb_detailpengembalian`
--
ALTER TABLE `tb_detailpengembalian`
  MODIFY `no_data` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tb_genre`
--
ALTER TABLE `tb_genre`
  MODIFY `kd_genre` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tb_member`
--
ALTER TABLE `tb_member`
  MODIFY `id_member` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tb_peminjaman`
--
ALTER TABLE `tb_peminjaman`
  MODIFY `kd_transaksi` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_penerbit`
--
ALTER TABLE `tb_penerbit`
  MODIFY `kd_penerbit` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tb_pengembalian`
--
ALTER TABLE `tb_pengembalian`
  MODIFY `kd_transaksi` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tb_penulis`
--
ALTER TABLE `tb_penulis`
  MODIFY `kd_penulis` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `tb_staf`
--
ALTER TABLE `tb_staf`
  MODIFY `id_staf` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tb_stokbuku`
--
ALTER TABLE `tb_stokbuku`
  MODIFY `kd_buku` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `tb_subgenre`
--
ALTER TABLE `tb_subgenre`
  MODIFY `kd_subgenre` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb_buku`
--
ALTER TABLE `tb_buku`
  ADD CONSTRAINT `tb_buku_ibfk_2` FOREIGN KEY (`kd_genre`) REFERENCES `tb_genre` (`kd_genre`),
  ADD CONSTRAINT `tb_buku_ibfk_3` FOREIGN KEY (`kd_subgenre`) REFERENCES `tb_subgenre` (`kd_subgenre`),
  ADD CONSTRAINT `tb_buku_ibfk_4` FOREIGN KEY (`kd_penulis`) REFERENCES `tb_penulis` (`kd_penulis`),
  ADD CONSTRAINT `tb_buku_ibfk_5` FOREIGN KEY (`kd_penerbit`) REFERENCES `tb_penerbit` (`kd_penerbit`);

--
-- Constraints for table `tb_detailpeminjaman`
--
ALTER TABLE `tb_detailpeminjaman`
  ADD CONSTRAINT `tb_detailpeminjaman_ibfk_1` FOREIGN KEY (`kd_transaksi`) REFERENCES `tb_peminjaman` (`kd_transaksi`),
  ADD CONSTRAINT `tb_detailpeminjaman_ibfk_2` FOREIGN KEY (`kd_buku`) REFERENCES `tb_buku` (`kd_buku`);

--
-- Constraints for table `tb_detailpengembalian`
--
ALTER TABLE `tb_detailpengembalian`
  ADD CONSTRAINT `tb_detailpengembalian_ibfk_1` FOREIGN KEY (`kd_transaksi`) REFERENCES `tb_pengembalian` (`kd_transaksi`),
  ADD CONSTRAINT `tb_detailpengembalian_ibfk_2` FOREIGN KEY (`kd_buku`) REFERENCES `tb_buku` (`kd_buku`),
  ADD CONSTRAINT `tb_detailpengembalian_ibfk_3` FOREIGN KEY (`kd_peminjaman`) REFERENCES `tb_peminjaman` (`kd_transaksi`);

--
-- Constraints for table `tb_peminjaman`
--
ALTER TABLE `tb_peminjaman`
  ADD CONSTRAINT `tb_peminjaman_ibfk_1` FOREIGN KEY (`kd_staf`) REFERENCES `tb_staf` (`id_staf`),
  ADD CONSTRAINT `tb_peminjaman_ibfk_2` FOREIGN KEY (`kd_member`) REFERENCES `tb_member` (`id_member`);

--
-- Constraints for table `tb_pengembalian`
--
ALTER TABLE `tb_pengembalian`
  ADD CONSTRAINT `tb_pengembalian_ibfk_1` FOREIGN KEY (`kd_staf`) REFERENCES `tb_staf` (`id_staf`),
  ADD CONSTRAINT `tb_pengembalian_ibfk_2` FOREIGN KEY (`kd_member`) REFERENCES `tb_member` (`id_member`);

--
-- Constraints for table `tb_stokbuku`
--
ALTER TABLE `tb_stokbuku`
  ADD CONSTRAINT `tb_stokbuku_ibfk_1` FOREIGN KEY (`kd_buku`) REFERENCES `tb_buku` (`kd_buku`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
