<?php
//error_reporting(0);

if (!isset($_POST['userid']) || !isset($_POST['old_password']) || !isset($_POST['new_password'])) {
    $response = array('status' => 'failed', 'message' => 'Missing parameters');
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$old_password = sha1($_POST['old_password']);
$new_password = sha1($_POST['new_password']);

$sqlCheckPassword = "SELECT * FROM `tb_users` WHERE `user_id` = '$userid' AND `user_pass` = '$old_password'";
$result = $conn->query($sqlCheckPassword);

if ($result->num_rows > 0) {
    // Password match found, update the password
    $sqlUpdatePassword = "UPDATE `tb_users` SET `user_pass` = '$new_password' WHERE `user_id` = '$userid'";
    if ($conn->query($sqlUpdatePassword) === TRUE) {
        $response = array('status' => 'success', 'message' => 'Password updated successfully');
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to update password: ' . $conn->error);
        sendJsonResponse($response);
    }
} else {
    // No matching user ID and old password found
    $response = array('status' => 'failed', 'message' => 'Invalid user ID or old password');
    sendJsonResponse($response);
}

$conn->close();

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>