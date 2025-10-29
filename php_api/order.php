<?php
// 1. เรียกใช้ไฟล์เชื่อมต่อ PDO ของคุณ
include_once 'condb.php'; 

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$data = json_decode(file_get_contents("php://input"));

// 2. ตรวจสอบข้อมูล (เหมือนเดิม)
if (
    !isset($data->customer_username) || 
    !isset($data->items) || 
    empty($data->items) ||
    !isset($data->total)
) {
    echo json_encode(["success" => false, "message" => "ข้อมูลไม่ครบถ้วน (customer_username, items, total)"]);
    exit();
}

try {
    // 3. เริ่ม Transaction (เหมือนเดิม)
    $conn->beginTransaction();

    // 4. INSERT ลงในตาราง 'orders' (ตารางแม่) (เหมือนเดิม)
    $sql_order = "INSERT INTO orders (customer_username, total_price, order_date, status) 
                  VALUES (?, ?, NOW(), 'รอดำเนินการ')";
    
    $stmt_order = $conn->prepare($sql_order);
    
    $stmt_order->execute([
        $data->customer_username,
        $data->total
    ]);

    // 5. ดึง ID ของออเดอร์ที่เพิ่งสร้าง (เหมือนเดิม)
    $order_id = $conn->lastInsertId();

    // 6. ✨✨✨ (ส่วนที่แก้ไข) ✨✨✨
    // วนลูป 'items' เพื่อ INSERT ลงใน 'order_items' (ตารางลูก)
    // (ลบ product_name ออกจาก SQL Query)
    $sql_items = "INSERT INTO order_items (order_id, product_id, quantity, price) 
                  VALUES (?, ?, ?, ?)"; // 👈 ลบ product_name ออกแล้ว
    
    $stmt_items = $conn->prepare($sql_items);

    foreach ($data->items as $item) {
        $stmt_items->execute([
            $order_id,
            $item->product_id,
            // $item->product_name, // 👈 (ลบออก)
            $item->quantity,
            $item->price
        ]);
    }
    // ✨✨✨ (สิ้นสุดส่วนที่แก้ไข) ✨✨✨

    // 7. ยืนยัน Transaction (เหมือนเดิม)
    $conn->commit();
    
    echo json_encode(["success" => true, "message" => "สั่งซื้อสำเร็จ! Order ID: " . $order_id]);

} catch (PDOException $e) {
    // 8. ถ้ามีอะไรผิดพลาด, ยกเลิกทั้งหมด (เหมือนเดิม)
    $conn->rollBack();
    echo json_encode(["success" => false, "message" => "Database Error: " . $e->getMessage()]);
}

// 9. ปิดการเชื่อมต่อ (เหมือนเดิม)
$conn = null;
?>