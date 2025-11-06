<template>
  <div class="container my-5 gaming-theme">
    <h2 class="text-center mb-4 text-purple">📦 ประวัติการสั่งซื้อ (Admin)</h2>

    <div class="mb-3 search-bar">
      <i class="bi bi-search search-icon"></i>
      <input
        type:="text"
        class="form-control"
        placeholder="🔍 กรอกรหัสคำสั่งซื้อ..."
        v-model="searchText"
      />
    </div>

    <div v-if="loading" class="text-center text-light">⏳ กำลังโหลดข้อมูล...</div>
    <div v-if="error" class="text-danger text-center">{{ error }}</div>

    <table v-if="paginatedOrders.length" class="table table-hover align-middle mt-3">
      <thead class="table-dark-header text-center">
        <tr>
          <th>รหัสคำสั่งซื้อ</th>
          <th>จำนวนรายการ</th>
          <th>ยอดรวมทั้งหมด</th>
          <th>วันที่สั่ง</th>
          <th>สถานะ</th>
          <th>รายละเอียด</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="order in paginatedOrders" :key="order.order_id">
          <td>#{{ order.order_id }}</td>
          <td class="text-center">{{ order.items_count }}</td>
          <td class="text-price fw-bold">{{ order.total_amount.toFixed(2) }} บาท</td>
          <td>{{ new Date(order.order_date).toLocaleString() }}</td>
          <td class="text-center">
            <span :class="['badge', getStatusClass(order.status)]">{{ order.status }}</span>
          </td>
          <td class="text-center">
            <button class="btn btn-sm btn-purple" @click="showDetails(order)">ดูรายละเอียด</button>
          </td>
        </tr>
      </tbody>
    </table>

    <div v-else-if="!loading" class="text-center text-muted">
      ❗ ยังไม่มีข้อมูลคำสั่งซื้อ
    </div>

    <div v-if="filteredOrders.length > 0" class="d-flex justify-content-between align-items-center mt-4">
      <div>
        แสดง
        <select v-model.number="rowsPerPage" class="form-select d-inline-block w-auto mx-2">
          <option v-for="n in [5,10,20,50]" :key="n" :value="n">{{ n }}</option>
        </select>
        แถวต่อหน้า
      </div>
      <div class="d-flex gap-2">
        <button class="btn btn-outline-purple btn-sm" @click="prevPage" :disabled="currentPage === 1">◀ ก่อนหน้า</button>
        <span>หน้า {{ currentPage }} / {{ totalPages }}</span>
        <button class="btn btn-outline-purple btn-sm" @click="nextPage" :disabled="currentPage === totalPages">ถัดไป ▶</button>
      </div>
    </div>

    <div v-if="selectedOrder" class="modal fade show d-block" tabindex="-1" style="background-color: rgba(0,0,0,0.5);">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">
              รายละเอียดออเดอร์ #{{ selectedOrder.order_id }}
              (ลูกค้า: {{ selectedOrder.customer_username }})
            </h5>
            <button type="button" class="btn-close" @click="selectedOrder=null"></button>
          </div>
          <div class="modal-body">
            <table class="table table-bordered">
              <thead>
                <tr>
                  <th>สินค้า</th>
                  <th>จำนวน</th>
                  <th>ราคา/หน่วย</th>
                  <th>ราคารวม</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="item in selectedOrder.items" :key="item.product_id">
                  <td>{{ item.product_name }}</td>
                  <td>{{ item.quantity }}</td>
                  <td>{{ Number(item.price).toFixed(2) }}</td>
                  <td>{{ Number(item.subtotal).toFixed(2) }}</td>
                </tr>
              </tbody>
            </table>
            <h5 class="text-end text-price">ยอดรวมทั้งหมด: {{ selectedOrder.total_amount.toFixed(2) }} บาท</h5>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import { ref, onMounted, computed, watch } from "vue";
import axios from "axios"; // ✨ (อย่าลืม import axios)

export default {
  // ✨ (ตรวจสอบว่า name ตรงกับที่ router เรียกใช้)
  name: "OrderList", // หรือ OrderSummary
  setup() {
    const orders = ref([]); // ✨ นี่คือ State หลักที่รับ "สรุป" มาจาก API
    const loading = ref(true);
    const error = ref(null);
    const searchText = ref("");
    const selectedOrder = ref(null);
    const currentPage = ref(1);
    const rowsPerPage = ref(10);

    const fetchOrders = async () => {
      loading.value = true;
      error.value = null;
      try {
        // ✨ (API ที่เราแก้ไปครั้งที่แล้ว)
        const res = await axios.get("http://localhost:8081/finalproject/php_api/order_bill.php");
        if (res.data.success) {
          orders.value = res.data.data; // 👈 (รับ [สรุป] มาเก็บ)
        } else {
          error.value = res.data.message || "ไม่สามารถโหลดข้อมูลได้";
        }
      } catch (err) {
        error.value = "เกิดข้อผิดพลาด: " + err.message;
      } finally {
        loading.value = false;
      }
    };

    onMounted(fetchOrders);

    // ✨ 8. (แก้ไข Bug NaN) - แก้ไข Computed Properties
    
    // 8a. กรองจาก 'orders' (ที่เป็น [สรุป] อยู่แล้ว)
    const filteredOrders = computed(() => {
      if (!searchText.value) return orders.value;
      const kw = searchText.value.toString().toLowerCase();
      // (กรองจาก order_id)
      return orders.value.filter(o => 
        o.order_id.toString().includes(kw)
      );
    });

    // ❌ 8b. ลบ `orderSummaries` (ตัวที่ทำให้เกิด Bug) ทิ้งไป
    //    (เพราะ API `order_bill.php` สรุป (group) มาให้เราแล้ว)

    // 8c. แก้ไข Pagination ให้อ้างอิงจาก 'filteredOrders'
    const totalPages = computed(() => Math.ceil(filteredOrders.value.length / rowsPerPage.value));
    
    const paginatedOrders = computed(() => {
      const start = (currentPage.value - 1) * rowsPerPage.value;
      // 👈 อ้างอิงจาก 'filteredOrders'
      return filteredOrders.value.slice(start, start + rowsPerPage.value);
    });

    const nextPage = () => { if (currentPage.value < totalPages.value) currentPage.value++; };
    const prevPage = () => { if (currentPage.value > 1) currentPage.value--; };
    watch([rowsPerPage, searchText], () => { currentPage.value = 1; });

    // ✨ 9. (ปรับดีไซน์) - เปลี่ยน Class ของสถานะ
    const getStatusClass = (status) => {
      status = status.toLowerCase();
      if (status.includes("เสร็จ")) return "bg-success";
      if (status.includes("รอดำเนินการ")) return "bg-warning text-dark";
      if (status.includes("ยกเลิก")) return "bg-danger";
      return "bg-secondary";
    };

    const showDetails = (order) => {
      selectedOrder.value = order;
    };

    return {
      orders, // (มีไว้เผื่อ Debug)
      loading,
      error,
      searchText,
      selectedOrder,
      paginatedOrders, // 👈 (ส่งตัวนี้ไปแสดงใน <table>)
      filteredOrders,  // 👈 (ใช้คำนวณ totalPages)
      currentPage,
      rowsPerPage,
      totalPages,
      nextPage,
      prevPage,
      getStatusClass,
      showDetails
    };
  }
};
</script>

<style scoped>
/* ✨ 10. (CSS ธีมใหม่) */

/* --- ธีมสีหลัก --- */
:root, .gaming-theme {
  --primary-purple: #9d4edd;
  --primary-purple-hover: #c77dff;
  /* --dark-bg: #ffffff; */
  --card-bg: #ffffff;
  --text-light: #000000;
  --cyber-red: #e02a6f;
  --border-color: #333;
}
.gaming-theme {
  background-color: var(--dark-bg);
  color: var(--text-light);
  min-height: calc(100vh - 70px); 
}
.text-purple { color: var(--primary-purple) !important; }
.text-price { color: var(--primary-purple-hover) !important; font-weight: bold; }

/* --- สไตล์ช่องค้นหา --- */
.search-bar {
  position: relative;
}
.search-icon {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  color: #888;
}
.search-bar .form-control {
  padding-left: 40px; /* เว้นที่ให้ไอคอน */
}

/* --- สไตล์ฟอร์ม (ค้นหา, Pagination) --- */
.form-control,
.form-select {
  background-color: var(--card-bg);
  color: var(--text-light);
  border-color: var(--border-color);
  border-radius: 8px;
}
.form-control:focus,
.form-select:focus {
  background-color: var(--card-bg);
  color: var(--text-light);
  border-color: var(--primary-purple);
  box-shadow: 0 0 0 0.25rem rgba(157, 78, 221, 0.25);
}

/* --- สไตล์ตาราง --- */
.table {
  background-color: var(--card-bg);
  color: var(--text-light);
  border-color: var(--border-color);
  border-radius: 8px; /* ทำให้ขอบตารางมน */
  overflow: hidden; /* บังคับให้ขอบมน */
}
.table th, .table td {
  vertical-align: middle;
  border-color: var(--border-color);
}
.table-hover tbody tr:hover {
  background-color: var(--dark-bg);
  color: var(--primary-purple-hover);
}
.table-dark-header th {
  background-color: var(--primary-purple);
  color: var(--dark-bg);
  font-weight: bold;
  border-color: var(--primary-purple);
}

/* --- สไตล์ Modal --- */
.modal-content {
  background-color: var(--card-bg);
  color: var(--text-light);
  border: 1px solid var(--primary-purple);
}
.modal-header { border-bottom-color: var(--border-color); }
.modal-body .table { background-color: var(--dark-bg); }
.btn-close { background-color: #fff; border-radius: 50%; }

/* --- สไตล์ปุ่ม --- */
.btn-purple {
  background-color: var(--primary-purple);
  color: #fff;
  border-color: var(--primary-purple);
}
.btn-purple:hover { background-color: var(--primary-purple-hover); }
.btn-outline-purple {
  color: var(--primary-purple);
  border-color: var(--primary-purple);
}
.btn-outline-purple:hover { background-color: var(--primary-purple); color: #fff; }
.btn-outline-purple:disabled { color: var(--border-color); border-color: var(--border-color); }

/* --- สไตล์ Badge (สถานะ) --- */
.badge {
  font-size: 0.85rem;
  padding: 0.4em 0.7em;
  font-weight: 600;
}
.bg-warning {
  color: #333 !important; /* ทำให้ตัวอักษรบนพื้นเหลืองชัดขึ้น */
}

</style>