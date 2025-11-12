<?php
header('Content-Type: application/json; charset=utf-8');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");

require_once __DIR__ . '/condb.php';

// Handle OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    try {
        // ดึงข้อมูลสินค้าทั้งหมด - เปลี่ยนจาก id เป็น product_id
        $stmt = $conn->prepare("
            SELECT 
                product_id, 
                product_name, 
                description, 
                price, 
                image, 
                category_id 
            FROM products 
            ORDER BY product_id DESC
        ");
        
        $stmt->execute();
        $items = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        // ส่งข้อมูลกลับในรูปแบบ JSON
        echo json_encode([
            'success' => true,
            'products' => $items,
            'count' => count($items)
        ], JSON_UNESCAPED_UNICODE);
        exit;
        
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'error' => 'Database error: ' . $e->getMessage()
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }
}

// ถ้าไม่ใช่ GET method
http_response_code(405);
echo json_encode([
    'success' => false,
    'error' => 'Method not allowed'
], JSON_UNESCAPED_UNICODE);
?>