<?php
include "config.php";

$id = $_POST['id'];
$query = $connect->query("DELETE FROM mahasiswa WHERE id='$id'");

header('Content-Type: application/json');

if ($query) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error"]);
}
?>
