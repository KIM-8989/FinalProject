<?php
include_once 'condb.php'; 

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

try {
    $sql = "SELECT 
                o.id AS order_id,
                o.customer_username,
                /* o.total_price AS order_total, */ /* ❌ เราจะไม่ใช้ค่านี้ */
                o.order_date,
                o.status,
                oi.product_id,
                oi.quantity,
                oi.price,
                p.product_name 
            FROM orders AS o
            JOIN order_items AS oi ON o.id = oi.order_id
            JOIN products AS p ON oi.product_id = p.product_id
            ORDER BY o.order_date DESC, o.id ASC";

    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $orders_summary = [];
    foreach ($results as $row) {
        $order_id = $row['order_id'];
        $subtotal = floatval($row['price']) * intval($row['quantity']); // คำนวณราคารายการ
        
        if (!isset($orders_summary[$order_id])) {
            $orders_summary[$order_id] = [
                "order_id" => $order_id,
                "customer_username" => $row['customer_username'],
                "total_amount" => 0, // ✨ 1. เริ่มต้นที่ 0
                "order_date" => $row['order_date'],
                "status" => $row['status'],
                "items" => [], 
                "items_count" => 0 
            ];
        }
        
        $orders_summary[$order_id]['items'][] = [
            "product_id" => $row['product_id'],
            "product_name" => $row['product_name'],
            "quantity" => intval($row['quantity']),
            "price" => floatval($row['price']),
            "subtotal" => $subtotal
        ];
        $orders_summary[$order_id]['items_count']++; 
        $orders_summary[$order_id]['total_amount'] += $subtotal; // ✨ 2. บวกยอดรวมเข้าไป
    }

    echo json_encode(["success" => true, "data" => array_values($orders_summary)]);

} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Database Error: " . $e->getMessage()]);
}

$conn = null;
?>