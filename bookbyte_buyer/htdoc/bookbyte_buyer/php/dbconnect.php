<?php
$servername = "infinitebe.com";
$username   = "infinmwk_junhong";
$password   = "Happily123@@@";
$dbname     = "infinmwk_junhong_bookbytedb";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>