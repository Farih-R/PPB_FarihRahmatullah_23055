<?php
include 'config.php';

$nama          = $_POST['nama'];
$npm           = $_POST['npm'];
$email         = $_POST['email'];
$alamat        = $_POST['alamat'];
$tgl_lahir     = $_POST['tgl_lahir'];
$jam_bimbingan = $_POST['jam_bimbingan'];

// Query insert
$query = $connect->query("
    INSERT INTO mahasiswa (nama, npm, email, alamat, tgl_lahir, jam_bimbingan)
    VALUES ('$nama', '$npm', '$email', '$alamat', '$tgl_lahir', '$jam_bimbingan')
");

// Respon JSON
if ($query) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => $connect->error]);
}

header('Content-Type: application/json');
echo json_encode(["status" => "success"]);

?>
