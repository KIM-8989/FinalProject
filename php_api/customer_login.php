<?php
// ✨ 1. เรียกใช้ไฟล์เชื่อมต่อ PDO ของคุณ
include_once 'condb.php'; 

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->username) || !isset($data->password)) {
    echo json_encode(["success" => false, "message" => "กรุณากรอก Username และ Password"]);
    exit();
}

try {
    // ✨ 2. ใช้ PDO::prepare
    $sql = "SELECT customer_id, username, password FROM customers WHERE username = ?";
    $stmt = $conn->prepare($sql);
    
    // ✨ 3. ใช้ $stmt->execute([...])
    $stmt->execute([$data->username]);
    
    // ✨ 4. ใช้ fetch(PDO::FETCH_ASSOC)
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user) {
        // 5. ตรวจสอบรหัสผ่าน (เหมือนเดิม)
        if (password_verify($data->password, $user['password'])) {
            // รหัสผ่านถูกต้อง
            echo json_encode([
                "success" => true,
                "message" => "เข้าสู่ระบบสำเร็จ",
                "username" => $user['username'] 
            ]);
        } else {
            // รหัสผ่านไม่ถูกต้อง
            echo json_encode(["success" => false, "message" => "Username หรือ Password ไม่ถูกต้อง"]);
        }
    } else {
        // ไม่พบผู้ใช้
        echo json_encode(["success" => false, "message" => "Username หรือ Password ไม่ถูกต้อง"]);
    }

} catch (PDOException $e) {
    // 6. ดักจับ Error จาก PDO
    echo json_encode(["success" => false, "message" => "Database Error: " . $e->getMessage()]);
}

$conn = null; // ปิดการเชื่อมต่อ
?>