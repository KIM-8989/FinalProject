<?php
// customer_orders.php - API สำหรับ Customer ดูคำสั่งซื้อของตัวเอง
include_once 'condb.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

try {
    // รับ username จาก POST (หรือ GET สำหรับทดสอบ)
    $data = json_decode(file_get_contents("php://input"), true);
    $username = $data['username'] ?? $_GET['username'] ?? null;

    if (!$username) {
        echo json_encode([
            "success" => false, 
            "message" => "กรุณาระบุ username"
        ]);
        exit;
    }

    // ดึงข้อมูลคำสั่งซื้อของ Customer คนนี้ พร้อมรายละเอียดสินค้า
    $sql = "SELECT 
                o.id AS order_id,
                o.customer_username,
                o.order_date,
                o.status AS order_status,
                o.total_price,
                oi.id AS order_item_id,
                oi.product_id,
                oi.quantity,
                oi.price,
                oi.subtotal,
                oi.status AS item_status,
                p.product_name,
                p.image
            FROM orders AS o
            LEFT JOIN order_items AS oi ON o.id = oi.order_id
            LEFT JOIN products AS p ON oi.product_id = p.product_id
            WHERE o.customer_username = :username
            ORDER BY o.order_date DESC, o.id DESC";
    
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':username', $username, PDO::PARAM_STR);
    $stmt->execute();
    
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (empty($results)) {
        echo json_encode([
            "success" => true, 
            "data" => [],
            "message" => "ยังไม่มีคำสั่งซื้อ"
        ]);
        exit;
    }

    // จัดกลุ่มข้อมูลตาม order_id
    $orders = [];
    foreach ($results as $row) {
        $order_id = $row['order_id'];
        
        if (!isset($orders[$order_id])) {
            $orders[$order_id] = [
                'order_id' => $order_id,
                'customer_username' => $row['customer_username'],
                'order_date' => $row['order_date'],
                'order_status' => $row['order_status'],
                'total_price' => (float)$row['total_price'],
                'items' => []
            ];
        }
        
        // เพิ่มรายการสินค้าในคำสั่งซื้อ
        if ($row['product_id']) {
            $quantity = (int)$row['quantity'];
            $price = (float)$row['price'];
            // คำนวณ subtotal ใหม่ถ้าเป็น 0
            $subtotal = (float)$row['subtotal'];
            if ($subtotal == 0 || $subtotal == null) {
                $subtotal = $quantity * $price;
            }
            
            $orders[$order_id]['items'][] = [
                'order_item_id' => $row['order_item_id'],
                'product_id' => $row['product_id'],
                'product_name' => $row['product_name'],
                'image' => $row['image'],
                'quantity' => $quantity,
                'price' => $price,
                'subtotal' => $subtotal,
                'item_status' => $row['item_status']
            ];
        }
    }

    // แปลงเป็น array
    $orders = array_values($orders);

    echo json_encode([
        "success" => true, 
        "data" => $orders
    ]);

} catch (PDOException $e) {
    echo json_encode([
        "success" => false, 
        "message" => "Database Error: " . $e->getMessage()
    ]);
}

$conn = null;
?>