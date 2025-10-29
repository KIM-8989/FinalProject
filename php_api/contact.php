<?php
header('Content-Type: application/json; charset=utf-8');
// POST: name, email, message
$method = $_SERVER['REQUEST_METHOD'];
if($method !== 'POST'){
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}
$data = json_decode(file_get_contents('php://input'), true);
$name = trim($data['name'] ?? '');
$email = trim($data['email'] ?? '');
$message = trim($data['message'] ?? '');

if(!$name || !$email || !$message){
    http_response_code(400);
    echo json_encode(['error' => 'Missing fields']);
    exit;
}

// Optionally store into database if configured
try {
    $mysqli = require __DIR__ . '/condb.php';
    $stmt = $mysqli->prepare('INSERT INTO contacts (name, email, message, created_at) VALUES (?, ?, ?, NOW())');
    if($stmt){
        $stmt->bind_param('sss', $name, $email, $message);
        $stmt->execute();
        $stmt->close();
    }
} catch(Exception $e){
    // ignore DB errors for now
}

echo json_encode(['status' => 'ok', 'message' => 'ขอบคุณที่ติดต่อเรา']);
?>