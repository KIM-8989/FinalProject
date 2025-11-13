<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include_once 'condb.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->order_id)) {
    echo json_encode(["success" => false, "message" => "ไม่ได้รับ order_id"]);
    exit();
}

try {
    $conn->beginTransaction();
    
    $sql1 = "UPDATE orders SET status = 'ยกเลิก' WHERE id = :order_id";
    $stmt1 = $conn->prepare($sql1);
    $stmt1->execute([':order_id' => $data->order_id]);
    
    $sql2 = "UPDATE order_items SET status = 'ยกเลิก' WHERE order_id = :order_id";
    $stmt2 = $conn->prepare($sql2);
    $stmt2->execute([':order_id' => $data->order_id]);
    
    $conn->commit();
    echo json_encode(["success" => true, "message" => "ยกเลิกคำสั่งซื้อสำเร็จ"]);
    
} catch (PDOException $e) {
    $conn->rollBack();
    echo json_encode(["success" => false, "message" => "Error: " . $e->getMessage()]);
}

$conn = null;
?>