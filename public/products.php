<?php include __DIR__ . '/../api/db_connect.php'; ?>
<?php // Simple products page that can be expanded ?>
<!doctype html>
<html lang="th"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>สินค้า — IT GAMING GEAR</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/css/custom-dark.css">
</head><body class="bg-dark text-white">
<div class="container py-4">
  <h1 style="color:#ff1f3a;font-family:Orbitron">สินค้าทั้งหมด</h1>
  <div id="productsRow" class="row g-3"></div>
  <a href="/" class="btn btn-secondary mt-3">กลับหน้าหลัก</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
axios.get('/api/products.php').then(r=>{
  const row = document.getElementById('productsRow');
  (r.data.products||[]).forEach(p=>{
    const col = document.createElement('div');
    col.className = 'col-12 col-md-6 col-lg-4';
    col.innerHTML = `<div class="card bg-dark text-white h-100" style="border:1px solid rgba(255,255,255,0.04)">
      <div style="height:180px;background:#0b0b0b;display:flex;align-items:center;justify-content:center">${p.image?'<img src="'+p.image+'" style="max-height:160px">':'<div style="color:#9aa0a6">ไม่มีรูป</div>'}</div>
      <div class="card-body">
        <h5 class="card-title" style="color:#ff1f3a">${p.name}</h5>
        <p class="card-text text-muted">${p.description}</p>
        <div class="d-flex justify-content-between align-items-center"><div class="text-danger fw-bold">฿${p.price}</div><button class="btn btn-outline-light btn-sm">เพิ่มในตะกร้า</button></div>
      </div></div>`;
    row.appendChild(col);
  });
});
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
