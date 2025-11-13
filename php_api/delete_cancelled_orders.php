<?php
include 'condb.php';
header('Content-Type: application/json; charset=utf-8');

// สำหรับ CORS ถ้า Vue รันคนละ port
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

try {
    $conn->beginTransaction();

    // 1️⃣ ดึง order_id ทั้งหมดที่มี order_items status = 'ยกเลิก'
    $stmt = $conn->prepare("SELECT DISTINCT order_id FROM order_items WHERE status = 'ยกเลิก'");
    $stmt->execute();
    $ordersToCheck = $stmt->fetchAll(PDO::FETCH_COLUMN);

    // 2️⃣ ลบรายการสินค้าที่ status = 'ยกเลิก'
    $stmt = $conn->prepare("DELETE FROM order_items WHERE status = 'ยกเลิก'");
    $stmt->execute();

    // 3️⃣ ตรวจสอบแต่ละ order หลังลบ
    $deleteOrder = $conn->prepare("DELETE FROM orders WHERE id = ?");
    $updateOrderStatus = $conn->prepare("UPDATE orders SET status = ? WHERE id = ?");
    $checkItems = $conn->prepare("SELECT COUNT(*) as total_items FROM order_items WHERE order_id = ?");

    foreach ($ordersToCheck as $order_id) {
        // เช็คว่ามีรายการสินค้าเหลืออยู่หรือไม่
        $checkItems->execute([$order_id]);
        $row = $checkItems->fetch(PDO::FETCH_ASSOC);
        
        if ($row['total_items'] == 0) {
            // ถ้าไม่มีสินค้าเหลือเลย (ลบหมด) → ลบ order ทิ้งเลย
            $deleteOrder->execute([$order_id]);
        } else {
            // ถ้ายังมีสินค้าเหลือ → เช็คว่าสินค้าที่เหลือทั้งหมดเสร็จแล้วหรือไม่
            $checkFinished = $conn->prepare("
                SELECT COUNT(*) as unfinished_items 
                FROM order_items 
                WHERE order_id = ? AND status != 'เสร็จแล้ว'
            ");
            $checkFinished->execute([$order_id]);
            $finishRow = $checkFinished->fetch(PDO::FETCH_ASSOC);
            
            if ($finishRow['unfinished_items'] == 0) {
                // ถ้าสินค้าที่เหลือทั้งหมดเสร็จแล้ว → อัปเดต order เป็น 'เสร็จแล้ว'
                $updateOrderStatus->execute(['เสร็จแล้ว', $order_id]);
            }
            // ถ้ายังมีสินค้าที่ไม่เสร็จ → ไม่ต้องทำอะไร (ปล่อยสถานะเดิม)
        }
    }

    $conn->commit();
    echo json_encode(['success' => true, 'message' => 'ลบรายการยกเลิกทั้งหมดเรียบร้อยแล้ว']);
} catch (Exception $e) {
    $conn->rollBack();
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}