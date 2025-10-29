<?php
// 1. เรียกใช้ไฟล์เชื่อมต่อ PDO ของคุณ
include_once 'condb.php'; 

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

try {
    // 2. ✨ (ส่วนที่แก้ไข) ✨
    // JOIN ตารางที่จำเป็น และ "ลบ o.table_no ออกจาก SELECT list"
    $sql = "SELECT 
                o.id AS order_id,
                o.customer_username, 
                o.order_date,
                o.status,
                oi.product_id,
                oi.quantity,
                oi.price,
                (oi.quantity * oi.price) AS subtotal,
                p.product_name
            FROM orders AS o
            JOIN order_items AS oi ON o.id = oi.order_id
            JOIN products AS p ON oi.product_id = p.product_id
            ORDER BY o.order_date DESC";
    
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    
    // 3. ดึงข้อมูลทั้งหมด
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode(["success" => true, "data" => $results]);

} catch (PDOException $e) {
    // 4. ดักจับ Error
    echo json_encode(["success" => false, "message" => "Database Error: " . $e->getMessage()]);
}

$conn = null; // ปิดการเชื่อมต่อ
?>