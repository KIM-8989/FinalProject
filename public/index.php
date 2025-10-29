<?php
// Public index.php for IT GAMING GEAR (ดัดแปลงจาก MK_SHOP)
// This uses Bootstrap 5 (CDN) and axios (CDN fallback). For production, run `npm install axios` and serve node_modules if desired.
?>
<!doctype html>
<html lang="th">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>IT GAMING GEAR</title>
  <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Kanit:wght@300;400;600&display=swap" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="/css/custom-dark.css">
</head>
<body class="bg-dark text-white">
<nav class="navbar navbar-expand-lg navbar-dark bg-black">
  <div class="container">
    <a class="navbar-brand d-flex align-items-center" href="#">
      <div style="width:48px;height:48px;border-radius:8px;background:#0b0b0b;color:#ff1f3a;display:flex;align-items:center;justify-content:center;font-family:Orbitron">IT</div>
      <div class="ms-2">
        <div style="font-family:Orbitron;font-size:16px">IT GAMING GEAR</div>
        <small class="text-muted">อุปกรณ์เกมมิ่ง</small>
      </div>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navCollapse">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navCollapse">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link active" href="#">หน้าแรก</a></li>
        <li class="nav-item"><a class="nav-link" href="/products.php">สินค้า</a></li>
        <li class="nav-item"><a class="nav-link" href="/contact.php">ติดต่อ</a></li>
      </ul>
    </div>
  </div>
</nav>

<header class="py-5 text-center">
  <div class="container">
    <h1 class="display-5" style="color:#ff1f3a;font-family:Orbitron">ยินดีต้อนรับสู่ IT GAMING GEAR</h1>
    <p class="lead text-muted">อัพเกรดการเล่นของคุณด้วยอุปกรณ์คุณภาพ</p>
    <a href="/products.php" class="btn btn-danger">ช้อปเลย</a>
  </div>
</header>

<main class="container">
  <h2 class="mb-4">สินค้าแนะนำ</h2>
  <div id="productsRow" class="row g-3">
    <!-- products loaded by axios -->
  </div>
</main>

<footer class="py-4 mt-5 bg-black">
  <div class="container text-muted d-flex justify-content-between">
    <div>© 2025 IT GAMING GEAR</div>
    <div>Line: @itgaming • Facebook: IT GAMING GEAR</div>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
// Fallback if axios from npm is served locally, otherwise use CDN above
if(typeof axios === 'undefined' && window.require){
  try{ axios = require('axios'); }catch(e){}
}
document.addEventListener('DOMContentLoaded', ()=>{
  axios.get('/api/products.php').then(resp=>{
    const products = resp.data.products || [];
    const row = document.getElementById('productsRow');
    products.forEach(p=>{
      const col = document.createElement('div');
      col.className = 'col-12 col-md-6 col-lg-4';
      col.innerHTML = `
        <div class="card bg-dark text-white h-100" style="border:1px solid rgba(255,255,255,0.04)">
          <div style="height:180px;background:#0b0b0b;display:flex;align-items:center;justify-content:center">${p.image?'<img src="'+p.image+'" alt="" style="max-height:160px">':'<div style="color:#9aa0a6">ไม่มีรูป</div>'}</div>
          <div class="card-body">
            <h5 class="card-title" style="color:#ff1f3a">${p.name}</h5>
            <p class="card-text text-muted">${p.description}</p>
            <div class="d-flex justify-content-between align-items-center">
              <div class="text-danger fw-bold">฿${p.price}</div>
              <a href="/products.php" class="btn btn-outline-light btn-sm">ดูรายละเอียด</a>
            </div>
          </div>
        </div>`;
      row.appendChild(col);
    });
  }).catch(err=>{ console.error(err); });
});
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
