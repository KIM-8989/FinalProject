<?php
// ✨ 1. เรียกใช้ไฟล์เชื่อมต่อ PDO ของคุณ
include_once 'condb.php'; 

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$data = json_decode(file_get_contents("php://input"));

if (
    !isset($data->username) ||
    !isset($data->password) ||
    !isset($data->full_name) ||
    !isset($data->email)
) {
    echo json_encode(["success" => false, "message" => "ข้อมูลไม่ครบถ้วน"]);
    exit();
}

// ✨ 2. เราจะใช้ try...catch เพราะ PDO ถูกตั้งค่าให้โยน Exceptions
try {
    // 3. ตรวจสอบว่า Username ซ้ำหรือไม่
    // ✨ ใช้ PDO::prepare
    $sql_check_user = "SELECT customer_id FROM customers WHERE username = ?";
    $stmt_check_user = $conn->prepare($sql_check_user);
    // ✨ ใช้ $stmt->execute([...])
    $stmt_check_user->execute([$data->username]);
    
    // ✨ ใช้ fetchColumn() เพื่อนับ
    if ($stmt_check_user->fetchColumn() > 0) {
        echo json_encode(["success" => false, "message" => "Username นี้ถูกใช้งานแล้ว"]);
        $conn = null; // ปิดการเชื่อมต่อ
        exit();
    }

    // 4. ตรวจสอบว่า Email ซ้ำหรือไม่
    $sql_check_email = "SELECT customer_id FROM customers WHERE email = ?";
    $stmt_check_email = $conn->prepare($sql_check_email);
    $stmt_check_email->execute([$data->email]);
    
    if ($stmt_check_email->fetchColumn() > 0) {
        echo json_encode(["success" => false, "message" => "Email นี้ถูกใช้งานแล้ว"]);
        $conn = null; 
        exit();
    }

    // 5. เข้ารหัสรหัสผ่าน (เหมือนเดิม)
    $hashed_password = password_hash($data->password, PASSWORD_DEFAULT);

    // 6. เพิ่มผู้ใช้ใหม่ลงในฐานข้อมูล
    $sql_insert = "INSERT INTO customers (username, password, full_name, email) VALUES (?, ?, ?, ?)";
    $stmt_insert = $conn->prepare($sql_insert);
    
    // ✨ ส่ง array เข้าไปใน execute
    if ($stmt_insert->execute([$data->username, $hashed_password, $data->full_name, $data->email])) {
        echo json_encode(["success" => true, "message" => "สมัครสมาชิกสำเร็จ!"]);
    } else {
        echo json_encode(["success" => false, "message" => "สมัครสมาชิกไม่สำเร็จ"]);
    }

} catch (PDOException $e) {
    // 7. ดักจับ Error จาก PDO
    echo json_encode(["success" => false, "message" => "Database Error: " . $e->getMessage()]);
}

$conn = null; // ปิดการเชื่อมต่อ
?>