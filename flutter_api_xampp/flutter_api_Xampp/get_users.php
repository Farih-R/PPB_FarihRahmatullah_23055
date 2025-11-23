<?php
include 'config.php';

$query = "SELECT * FROM mahasiswa";
$result = $connect->query($query);

// Jika query gagal, tampilkan pesan error
if (!$result) {
    die("Query Error: " . $connect->error);
}

$data = array();

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
?>
