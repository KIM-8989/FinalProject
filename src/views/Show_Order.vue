<template>
  <div class="container my-5 gaming-theme">
    <h2 class="text-center mb-4 text-purple">📋 จัดการคำสั่งซื้อทั้งหมด</h2>

    <div class="mb-3 d-flex justify-content-between align-items-center">
      <div class="d-flex">
        <input
          type="text"
          class="form-control me-2"
          placeholder="🔍 กรอกรหัสคำสั่งซื้อ..."
          v-model="searchKeyword"
        />
        <select v-model="statusFilter" class="form-select w-auto">
          <option value="">ทุกสถานะ</option>
          <option value="รอดำเนินการ">รอดำเนินการ</option>
          <option value="ยกเลิก">ยกเลิก</option>
          <option value="เสร็จแล้ว">เสร็จแล้ว</option>
        </select>
      </div>

      <div>
        <label class="me-2">แสดงต่อหน้า:</label>
        <select v-model.number="rowsPerPage" class="form-select d-inline-block w-auto">
          <option :value="5">5</option>
          <option :value="10">10</option>
          <option :value="20">20</option>
          <option :value="50">50</option>
        </select>
      </div>
    </div>

    <div class="mb-3 text-end">
      <button class="btn btn-outline-danger" @click="deleteAllCancelledOrders">
        <i class="bi bi-trash-fill me-1"></i>
        ลบรายการยกเลิกทั้งหมด
      </button>
    </div>

    <div v-if="loading" class="text-center">⏳ กำลังโหลดข้อมูล...</div>
    <div v-if="error" class="text-danger text-center">{{ error }}</div>

    <table v-if="paginatedOrders.length > 0" class="table table-hover align-middle mt-3">
      <thead class="table-dark-header text-center">
        <tr>
          <th>รหัสคำสั่งซื้อ</th>
          <th>รหัสสินค้า</th>
          <th>สินค้า</th>
          <th>จำนวน</th>
          <th>ราคา/หน่วย</th>
          <th>ราคารวม</th>
          <th>วันที่สั่ง</th>
          <th>สถานะ</th>
          <th>จัดการ</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(order, index) in paginatedOrders" :key="index">
          <td>{{ order.order_id }}</td>
          <td>{{ order.product_id }}</td>
          <td>{{ order.product_name }}</td>
          <td>{{ order.quantity }}</td>
          <td>{{ order.price.toFixed(2) }}</td>
          <td>{{ order.subtotal.toFixed(2) }}</td>
          <td>{{ order.order_date }}</td>
          <td>
            <select v-model="order.status" @change="updateStatus(order)" class="form-select form-select-sm">
              <option value="รอดำเนินการ">รอดำเนินการ</option>
              <option value="ยกเลิก">ยกเลิก</option>
              <option value="เสร็จแล้ว">เสร็จแล้ว</option>
            </select>
          </td>
          <td class="text-center">
            <button
              v-if="order.status === 'ยกเลิก'"
              class="btn btn-danger btn-sm"
              @click="deleteOrder(order)"
            >
              ลบ
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <div v-else-if="!loading" class="text-center text-muted">
      ❗ ยังไม่มีข้อมูลคำสั่งซื้อ
    </div>

    <div v-if="totalPages > 1" class="d-flex justify-content-center align-items-center mt-4 gap-2">
      <button class="btn btn-outline-purple btn-sm" :disabled="currentPage === 1" @click="currentPage--">
        ⬅ ก่อนหน้า
      </button>
      <span>หน้า {{ currentPage }} จาก {{ totalPages }}</span>
      <button class="btn btn-outline-purple btn-sm" :disabled="currentPage === totalPages" @click="currentPage++">
        ถัดไป ➡
      </button>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed, watch } from "vue";

export default {
  name: "Show_Order", // ✨ 9. เปลี่ยนชื่อ Component
  setup() {
    const orders = ref([]);
    const loading = ref(true);
    const error = ref(null);
    const searchKeyword = ref("");
    // const searchBy = ref("table_no"); // ❌ 10. ลบการค้นหาด้วยโต๊ะ
    const statusFilter = ref("");
    const currentPage = ref(1);
    const rowsPerPage = ref(10);

    const fetchOrders = async () => {
      loading.value = true;
      error.value = null;
      try {
        const res = await fetch("http://localhost:8081/MK_SHOP/php_api/show_orders.php");
        const data = await res.json();
        if (data.success && Array.isArray(data.data)) {
          orders.value = data.data.map((o) => ({
            order_id: o.order_id,
            // table_no: o.table_no, // ❌ 11. ลบ table_no
            product_id: o.product_id,
            product_name: o.product_name,
            quantity: Number(o.quantity),
            price: Number(o.price),
            subtotal: Number(o.subtotal || o.price * o.quantity),
            order_date: o.order_date,
            status: o.status || "รอดำเนินการ",
          }));
        } else {
          error.value = data.message || "ไม่สามารถโหลดข้อมูลได้";
        }
      } catch (err) {
        error.value = "เกิดข้อผิดพลาด: " + err.message;
      } finally {
        loading.value = false;
      }
    };

    onMounted(fetchOrders);

    const filteredOrders = computed(() => {
      let result = orders.value;
      if (statusFilter.value) {
        result = result.filter(order => order.status === statusFilter.value);
      }
      if (searchKeyword.value) {
        const keyword = searchKeyword.value.toString().toLowerCase();
        // ✨ 12. กรองด้วย order_id เท่านั้น
        result = result.filter(order => {
          return order.order_id.toString().toLowerCase().includes(keyword);
        });
      }
      return result;
    });

    const totalPages = computed(() => Math.ceil(filteredOrders.value.length / rowsPerPage.value));
    const paginatedOrders = computed(() => {
      const start = (currentPage.value - 1) * rowsPerPage.value;
      return filteredOrders.value.slice(start, start + rowsPerPage.value);
    });

    // ✨ 13. ลบ searchBy ออกจาก watch
    watch([rowsPerPage, statusFilter, searchKeyword], () => { currentPage.value = 1; });

    const updateStatus = async (order) => {
      try {
        const res = await fetch("http://localhost:8081/MK_SHOP/php_api/update_order_status.php", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ order_id: order.order_id, product_id: order.product_id, status: order.status }),
        });
        const data = await res.json();
        if (!data.success) alert("อัปเดตสถานะไม่สำเร็จ: " + (data.message || "เกิดข้อผิดพลาด"));
        await fetchOrders();
      } catch (err) { alert("เกิดข้อผิดพลาด: " + err.message); }
    };

    const deleteOrder = async (order) => {
      if (!confirm(`คุณต้องการลบคำสั่งซื้อ ${order.order_id} (สินค้า: ${order.product_name}) หรือไม่?`)) return;
      try {
        const res = await fetch("http://localhost:8081/MK_SHOP/php_api/delete_order.php", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ order_id: order.order_id, product_id: order.product_id }),
        });
        const data = await res.json();
        if (data.success) {
          alert("ลบคำสั่งซื้อเรียบร้อยแล้ว");
          await fetchOrders();
        } else {
          alert("ลบไม่สำเร็จ: " + (data.message || "เกิดข้อผิดพลาด"));
        }
      } catch (err) {
        alert("เกิดข้อผิดพลาด: " + err.message);
      }
    };

    // ✅ ฟังก์ชันลบรายการยกเลิกทั้งหมด (เหมือนเดิม)
    const deleteAllCancelledOrders = async () => {
      if (!confirm("คุณต้องการลบคำสั่งซื้อที่ยกเลิกทั้งหมดหรือไม่?")) return;
      try {
        const res = await fetch("http://localhost:8081/MK_SHOP/php_api/delete_cancelled_orders.php", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
        });
        const data = await res.json();
        if (data.success) {
          alert("ลบคำสั่งซื้อที่ยกเลิกทั้งหมดเรียบร้อยแล้ว");
          await fetchOrders();
        } else {
          alert("ลบไม่สำเร็จ: " + (data.message || "เกิดข้อผิดพลาด"));
        }
      } catch (err) {
        alert("เกิดข้อผิดพลาด: " + err.message);
      }
    };

    return {
      orders, loading, error, searchKeyword, statusFilter, // ❌ 14. ลบ searchBy
      currentPage, rowsPerPage, totalPages, paginatedOrders,
      updateStatus, deleteOrder, deleteAllCancelledOrders
    };
  },
};
</script>

<style scoped>
/* ✨ --- 15. เพิ่ม CSS ธีมดำ-ม่วง --- ✨ */

/* --- ธีมสีหลัก --- */
:root,
.gaming-theme {
  --primary-purple: #9d4edd;
  --primary-purple-hover: #c77dff;
  /* --dark-bg: #121212;
  --card-bg: #1e1e1e; */
  --text-light: #515151;
  --cyber-red: #e02a6f;
  --border-color: #333;
}

.gaming-theme {
  background-color: var(--dark-bg);
  color: var(--text-light);
  min-height: calc(100vh - 70px);
}

.text-purple {
  color: var(--primary-purple) !important;
}

/* --- สไตล์ฟอร์ม (ค้นหา, Pagination, Select) --- */
.form-control,
.form-select {
  background-color: var(--card-bg);
  color: var(--text-light);
  border-color: var(--border-color);
  border-radius: 8px; /* ทำให้ขอบมน */
}
.form-control:focus,
.form-select:focus {
  background-color: var(--card-bg);
  color: var(--text-light);
  border-color: var(--primary-purple);
  box-shadow: 0 0 0 0.25rem rgba(157, 78, 221, 0.25);
}
.form-select.form-select-sm {
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
  font-size: 0.875rem;
}

/* --- สไตล์ตาราง --- */
.table {
  background-color: var(--card-bg);
  color: var(--text-light);
  border-color: var(--border-color);
  font-size: 0.95rem;
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
}

/* --- สไตล์ปุ่ม --- */
.btn-outline-purple {
  color: var(--primary-purple);
  border-color: var(--primary-purple);
  transition: all 0.3s;
}
.btn-outline-purple:hover {
  background-color: var(--primary-purple);
  color: #fff;
}
.btn-outline-purple:disabled {
  color: var(--border-color);
  border-color: var(--border-color);
}

.btn-danger {
  background-color: var(--cyber-red);
  border-color: var(--cyber-red);
}
.btn-danger:hover {
  background-color: #ff4d8d;
  border-color: #ff4d8d;
}

.btn-outline-danger {
  color: var(--cyber-red);
  border-color: var(--cyber-red);
}
.btn-outline-danger:hover {
  background-color: var(--cyber-red);
  color: var(--text-light);
}
</style>