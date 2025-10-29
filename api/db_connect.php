<?php
// db_connect.php - ตัวอย่างการเชื่อมต่อ MySQL (ใช้กับ phpMyAdmin)
$host = getenv('DB_HOST') ?: 'localhost';
$user = getenv('DB_USER') ?: 'root';
$pass = getenv('DB_PASS') ?: '';
$dbname = getenv('DB_NAME') ?: 'it_gaming_gear';

$mysqli = new mysqli($host, $user, $pass, $dbname);
if ($mysqli->connect_errno) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to connect to MySQL: ' . $mysqli->connect_error]);
    exit;
}
$mysqli->set_charset('utf8mb4');
return $mysqli;
?>