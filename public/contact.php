<!doctype html><html lang='th'><head><meta charset='utf-8'><meta name='viewport' content='width=device-width,initial-scale=1'><title>ติดต่อเรา</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/css/custom-dark.css"></head><body class='bg-dark text-white'>
<div class='container py-4'><h1 style='color:#ff1f3a;font-family:Orbitron'>ติดต่อเรา</h1>
<div class='row'><div class='col-md-6'><form id='contactForm'>
<div class='mb-2'><label class='form-label'>ชื่อ</label><input class='form-control' name='name' required></div>
<div class='mb-2'><label class='form-label'>อีเมล</label><input class='form-control' name='email' type='email' required></div>
<div class='mb-2'><label class='form-label'>ข้อความ</label><textarea class='form-control' name='message' rows='5' required></textarea></div>
<button class='btn btn-danger' type='submit'>ส่งข้อความ</button>
</form></div><div class='col-md-6 text-muted'><h5>ช่องทางอื่น</h5><p>Line: @itgaming</p><p>โทร: 02-123-4567</p></div></div></div>

<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
document.getElementById('contactForm').addEventListener('submit', function(e){
  e.preventDefault();
  const f = e.target;
  const data = { name: f.name.value, email: f.email.value, message: f.message.value };
  axios.post('/api/contact.php', data).then(r=>{
    alert(r.data.message || 'ส่งเรียบร้อย');
    f.reset();
  }).catch(err=>{
    alert('เกิดข้อผิดพลาด');
    console.error(err);
  });
});
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
