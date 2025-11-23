<?php
$connect = new mysqli("localhost", "root", "", "database_mahasiswa");

if ($connect->connect_error) {
    die("Connection failed: " . $connect->connect_error);
}
?>
