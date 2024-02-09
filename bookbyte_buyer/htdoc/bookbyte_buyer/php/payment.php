<?php
//error_reporting(0);

$email = $_GET['email']; //email
$name = $_GET['name']; 
$userid = $_GET['userid'];
$amount = $_GET['amount']; 
//$sellerid = $_GET['sellerid'];


$api_key = '66522b3c-e6ff-4efe-9192-eb10f94cf0f4';
$collection_id = 'ye4w2j4o6';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'name' => $name,
          'mobile' => '60123456789',
          'amount' => ($amount) * 100, // RM20
          'description' => 'Payment for order by '.$name,
          'callback_url' => "https://junhong.infinitebe.com/bookbyte_buyer/return_url",
          'redirect_url' => "https://junhong.infinitebe.com/bookbyte_buyer/php/payment_update.php?userid=$userid&email=$email&phone=$phone&amount=$amount&name=$name" 
);

$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data)); 

$return = curl_exec($process);
curl_close($process);
$bill = json_decode($return, true);
print_r($bill);
header("Location: {$bill['url']}");
?>