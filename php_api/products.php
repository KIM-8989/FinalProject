<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/condb.php';

// simple API: GET /api/products.php
$method = $_SERVER['REQUEST_METHOD'];
if ($method === 'GET') {
    $mysqli = require __DIR__ . '/condb.php';
    $res = $mysqli->query('SELECT id, name, description, price, image FROM products ORDER BY id DESC');
    $items = [];
    if($res){
        while($row = $res->fetch_assoc()){
            $items[] = $row;
        }
    }
    echo json_encode(['products' => $items], JSON_UNESCAPED_UNICODE);
    exit;
}

http_response_code(405);
echo json_encode(['error' => 'Method not allowed']);
?>