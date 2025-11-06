<template>
  <div class="container my-5 gaming-theme">
    <h2 class="text-center mb-4 fw-bold text-purple">🔥 GAMING GEAR 🔥</h2>
    <div class="mb-4">
      <label class="form-label fw-bold text-purple fs-5">เลือกหมวดหมู่:</label>
      <div class="category-scroll-container">
        <button
          type="button"
          class="btn category-btn"
          :class="selectedCategory === '' ? 'btn-purple' : 'btn-outline-purple'"
          @click="filterByCategory('')"
        >
          <i class="bi bi-grid-fill me-1"></i>
          ทั้งหมด
        </button>
        <button
          v-for="category in categories"
          :key="category.category_id"
          type="button"
          class="btn category-btn"
          :class="
            selectedCategory === category.category_id
              ? 'btn-purple'
              : 'btn-outline-purple'
          "
          @click="filterByCategory(category.category_id)"
        >
          {{ category.category_name }}
        </button>
      </div>
    </div>
    <div v-if="loading" class="text-center my-5">
      <div class="spinner-border text-light" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
      <p class="mt-2">กำลังโหลดสินค้า...</p>
    </div>
    <div v-if="error" class="alert alert-danger">{{ error }}</div>
    <div class="row" v-if="!loading && !error">
      <div
        v-if="products.length === 0"
        class="col-12 text-center text-muted my-5"
      >
        <h5>ไม่พบสินค้าในหมวดหมู่นี้</h5>
      </div>
      <div
        class="col-md-3 col-sm-6"
        v-for="product in products"
        :key="product.product_id"
      >
        <div class="card shadow-sm mb-4 h-100">
          <div class="card-img-wrapper">
            <img
              :src="
                'http://localhost:8081/finalproject/php_api/uploads/' + product.image
              "
              class="card-img-top"
              style="height: 200px; object-fit: cover"
              :alt="product.product_name"
              @error="handleImageError"
            />
          </div>
          <div class="card-body text-center d-flex flex-column">
            <div class="flex-grow-1">
              <h5 class="card-title fw-bold">{{ product.product_name }}</h5>
            </div>
            <div>
              <p class="card-text text-price fw-bold fs-5">
                {{ product.price }} บาท
              </p>
              <button class="btn btn-purple mt-auto" @click="addToCart(product)">
                <i class="bi bi-cart-plus-fill me-1"></i>
                เพิ่มลงตะกร้า
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="mt-5" v-if="cart.length > 0">
      <h4 class="mb-3 text-purple">🧺 ตะกร้าสินค้าของคุณ</h4>
      <div class="table-responsive">
        <table class="table table-bordered align-middle">
          <thead class="table-dark-header">
            <tr>
              <th>สินค้า</th>
              <th>ราคา</th>
              <th style="width: 180px">จำนวน</th>
              <th>รวม</th>
              <th style="width: 80px">ลบ</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in cart" :key="index">
              <td>{{ item.product_name }}</td>
              <td>{{ item.price }} บาท</td>
              <td class="text-center">
                <div class="btn-group" role="group">
                  <button
                    class="btn btn-sm btn-outline-light"
                    @click="decreaseQty(item)"
                  >
                    -
                  </button>
                  <button class="btn btn-sm btn-outline-light" disabled>
                    {{ item.quantity }}
                  </button>
                  <button
                    class="btn btn-sm btn-outline-light"
                    @click="increaseQty(item)"
                  >
                    +
                  </button>
                </div>
              </td>
              <td class="fw-bold">{{ (item.price * item.quantity).toFixed(2) }} บาท</td>
              <td class="text-center">
                <button
                  class="btn btn-danger btn-sm"
                  @click="removeFromCart(index)"
                >
                  ลบ
                </button>
              </td>
            </tr>
          </tbody>
          <tfoot class="table-dark-footer">
            <tr>
              <td colspan="3" class="text-end fw-bold">รวมทั้งหมด</td>
              <td colspan="2" class="fw-bold text-price fs-5">
                {{ totalPrice.toFixed(2) }} บาท
              </td>
            </tr>
          </tfoot>
        </table>
      </div>
      <div class="text-end mt-3">
        <button class="btn btn-outline-danger me-2" @click="clearCart">
          ล้างตะกร้า
        </button>
        <button
          class="btn btn-purple btn-lg"
          @click="submitOrder"
          :disabled="submitting"
        >
          <span v-if="submitting">
            <span class="spinner-border spinner-border-sm me-2"></span>
            กำลังส่งออเดอร์...
          </span>
          <span v-else>
            <i class="bi bi-box-arrow-in-right me-1"></i>
            สั่งซื้อสินค้า
          </span>
        </button>
      </div>
    </div>
    <div v-else class="alert alert-cart-empty text-center mt-5">
      <h5>🛒 ยังไม่มีสินค้าในตะกร้า</h5>
      <p class="mb-0">เลือก Gaming Gear ที่คุณต้องการได้เลย!</p>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from "vue";
import axios from "axios";
import { useRouter } from 'vue-router'; // ✨ 1. Import useRouter

export default {
  name: "ProductList",
  setup() {
    const router = useRouter(); // ✨ 2. ใช้งาน router
    const products = ref([]);
    const categories = ref([]);
    const cart = ref([]);
    const selectedCategory = ref("");
    const loading = ref(true);
    const error = ref(null);
    const submitting = ref(false);

    // ... (ฟังก์ชัน fetchCategories, fetchProducts, filterByCategory... เหมือนเดิม) ...
        // ✅ ดึงข้อมูลหมวดหมู่
    const fetchCategories = async () => {
      try {
        const response = await axios.get(
          "http://localhost:8081/finalproject/php_api/get_categories.php"
        );
        if (response.data.success) {
          categories.value = response.data.data;
        }
      } catch (err) {
        console.error("Error fetching categories:", err);
      }
    };

    // ✅ ดึงข้อมูลสินค้า
    const fetchProducts = async (categoryId = "") => {
      loading.value = true;
      error.value = null;

      try {
        let url = "http://localhost:8081/finalproject/php_api/show_product.php";
        if (categoryId) {
          url += `?category_id=${categoryId}`;
        }

        const response = await axios.get(url);

        if (response.data.success) {
          products.value = response.data.data;
        } else {
          if (Array.isArray(response.data.data) && response.data.data.length === 0) {
            products.value = [];
          } else {
            error.value = response.data.message;
          }
        }
      } catch (err) {
        error.value = "เกิดข้อผิดพลาดในการโหลดสินค้า: " + err.message;
      } finally {
        loading.value = false;
      }
    };

    // ✅ กรองสินค้าตามหมวดหมู่
    const filterByCategory = (categoryId) => {
      selectedCategory.value = categoryId;
      fetchProducts(categoryId);
    };


    // ✅ เพิ่มสินค้าเข้าตะกร้า (ฟังก์ชันนี้อนุญาตให้ Guest เพิ่มได้)
    const addToCart = (product) => {
      const existing = cart.value.find(
        (item) => item.product_id === product.product_id
      );
      if (existing) {
        existing.quantity++;
        alert(
          `✅ เพิ่มจำนวน "${product.product_name}" แล้ว (${existing.quantity} ชิ้น)`
        );
      } else {
        cart.value.push({
          product_id: product.product_id,
          product_name: product.product_name,
          price: parseFloat(product.price),
          quantity: 1,
        });
        alert(`✅ เพิ่ม "${product.product_name}" ลงในตะกร้าแล้ว`);
      }
    };

    // ... (ฟังก์ชัน increaseQty, decreaseQty, removeFromCart, clearCart, totalPrice, handleImageError... เหมือนเดิม) ...
        // ✅ เพิ่มจำนวนสินค้า
    const increaseQty = (item) => {
      item.quantity++;
    };

    // ✅ ลดจำนวนสินค้า
    const decreaseQty = (item) => {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        if (confirm("ต้องการลบสินค้านี้ออกจากตะกร้าหรือไม่?")) {
          const index = cart.value.indexOf(item);
          if (index !== -1) cart.value.splice(index, 1);
        }
      }
    };

    // ✅ ลบสินค้าออกจากตะกร้า
    const removeFromCart = (index) => {
      if (confirm("ยืนยันการลบสินค้านี้หรือไม่?")) {
        cart.value.splice(index, 1);
      }
    };

    // ✅ ล้างตะกร้า
    const clearCart = () => {
      if (confirm("ต้องการล้างสินค้าทั้งหมดในตะกร้าหรือไม่?")) {
        cart.value = [];
        alert("✅ ล้างตะกร้าเรียบร้อยแล้ว");
      }
    };

    // ✅ คำนวณราคารวมทั้งหมด
    const totalPrice = computed(() =>
      cart.value.reduce((sum, item) => sum + item.price * item.quantity, 0)
    );

    // ✅ จัดการ error รูปภาพ
    const handleImageError = (event) => {
      event.target.src = "https://via.placeholder.com/200x200.png?text=No+Image";
    };


    // ✨ 3. แก้ไขฟังก์ชัน submitOrder ทั้งหมด
    const submitOrder = async () => {
      
      // 3.1 ตรวจสอบการล็อกอินของ "ลูกค้า"
      const isCustomerLoggedIn = localStorage.getItem("customerLogin") === "true";
      if (!isCustomerLoggedIn) {
        alert("⚠️ กรุณาเข้าสู่ระบบ (Login) ก่อนสั่งซื้อสินค้าครับ");
        router.push('/login'); // สั่งให้ย้ายไปหน้า Login
        return;
      }

      // 3.2 ตรวจสอบตะกร้า (เหมือนเดิม)
      if (cart.value.length === 0) {
        alert("⚠️ กรุณาเพิ่มสินค้าในตะกร้าก่อนสั่งซื้อ");
        return;
      }

      // 3.3 สร้างข้อมูลออเดอร์ (ลบ table_no, เพิ่ม customer_username)
      const orderData = {
        // table_no: selectedTable.value, // ❌ ลบส่วนนี้ทิ้ง
        
        // ✨ (แนะนำ) เพิ่มข้อมูลลูกค้าที่ล็อกอินอยู่แทน
        customer_username: localStorage.getItem("customer_username"), 

        items: cart.value.map((item) => ({
          product_id: item.product_id,
          product_name: item.product_name,
          quantity: item.quantity,
          price: item.price,
        })),
        total: totalPrice.value,
      };

      submitting.value = true;

      try {
        // 3.4 ส่งข้อมูล (เหมือนเดิม)
        const response = await axios.post(
          "http://localhost:8081/finalproject/php_api/order.php",
          orderData
        );

        if (response.data.success) {
          alert(
            "✅ สั่งซื้อสำเร็จ!\n" +
              `ยอดรวม: ${totalPrice.value.toFixed(2)} บาท`
          );
          cart.value = [];
        } else {
          alert("❌ " + response.data.message);
        }
      } catch (error) {
        alert("เกิดข้อผิดพลาด: " + error.message);
        console.error("Error submitting order:", error);
      } finally {
        submitting.value = false;
      }
    };

    // โหลดข้อมูลเมื่อเริ่มต้น
    onMounted(() => {
      fetchCategories();
      fetchProducts();
    });

    return {
      products, categories, cart, selectedCategory,
      totalPrice, loading, error, submitting,
      addToCart, increaseQty, decreaseQty, removeFromCart,
      clearCart, submitOrder, filterByCategory, handleImageError,
    };
  },
};
</script>

<style scoped>
/* (CSS ทั้งหมดเหมือนเดิม) */
:root,
.gaming-theme {
  --primary-purple: #9d4edd;
  --primary-purple-hover: #c77dff;
  /* --dark-bg: #121212;  */
  /* --card-bg: #1e1e1e;  */
  --text-light: #3f3f3f;
  --text-muted: #888;
  --border-color: #333;
}
.gaming-theme {
  background-color: var(--dark-bg);
  color: var(--text-light);
  min-height: 100vh;
}
.text-purple {
  color: var(--primary-purple) !important;
}
.card {
  transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
  border: 1px solid var(--border-color);
  border-radius: 10px;
  background-color: var(--card-bg);
  color: var(--text-light);
  overflow: hidden; 
}
.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2), 0 0 15px var(--primary-purple-hover); 
  border-color: var(--primary-purple);
}
.card-img-wrapper {
  overflow: hidden;
  border-radius: 10px 10px 0 0; 
}
.card-img-top {
  border-radius: 0; 
  transition: transform 0.4s ease; 
}
.card:hover .card-img-top {
  transform: scale(1.1); 
}
.card-title {
  color: var(--text-light);
  font-size: 1.1rem;
  margin-bottom: 0.5rem; 
}
.text-price {
  color: var(--primary-purple-hover) !important;
  text-shadow: 0 0 8px var(--primary-purple-hover); 
  margin-bottom: 0.75rem; 
}
.card-body .btn-purple {
  width: 100%; 
}
.btn-group .btn {
  min-width: 80px;
  font-weight: 500;
}
.btn-purple {
  background-color: var(--primary-purple);
  color: #fff;
  border-color: var(--primary-purple);
  transition: all 0.3s;
}
.btn-purple:hover {
  background-color: var(--primary-purple-hover);
  border-color: var(--primary-purple-hover);
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(157, 78, 221, 0.4);
}
.btn-outline-purple {
  color: var(--primary-purple);
  border-color: var(--primary-purple);
  transition: all 0.3s;
}
.btn-outline-purple:hover {
  background-color: var(--primary-purple);
  color: #fff;
  transform: scale(1.05);
}
.table {
  background-color: var(--card-bg);
  color: var(--text-light);
  border-color: var(--border-color);
}
.table th,
.table td {
  vertical-align: middle;
  border-color: var(--border-color);
}
.table-dark-header th {
  background-color: var(--primary-purple);
  color: var(--dark-bg);
  font-weight: bold;
}
.table-dark-footer td {
  background-color: var(--card-bg);
}
.table-responsive {
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid var(--border-color);
}
.form-select {
  border-radius: 8px;
  padding: 8px 16px;
  background-color: var(--card-bg);
  color: var(--text-light);
  border-color: var(--border-color);
}
.form-select:focus {
  background-color: var(--card-bg);
  color: var(--text-light);
  border-color: var(--primary-purple);
  box-shadow: 0 0 0 0.25rem rgba(157, 78, 221, 0.25);
}
.alert-cart-empty {
  background-color: var(--card-bg);
  color: var(--text-light);
  border: 1px dashed var(--primary-purple);
  border-radius: 8px;
}
.form-label {
  margin-bottom: 0.5rem;
}
.category-scroll-container {
  display: flex; 
  overflow-x: auto; 
  white-space: nowrap; 
  padding-bottom: 15px; 
  margin-bottom: -15px; 
}
.category-scroll-container::-webkit-scrollbar {
  display: none; 
}
.category-scroll-container {
  -ms-overflow-style: none; 
  scrollbar-width: none; 
}
.category-btn {
  flex-shrink: 0; 
  margin-right: 10px; 
  font-weight: 600;
  padding: 8px 16px;
  border-radius: 50px; 
  transition: all 0.3s ease;
}
.category-btn:last-child {
  margin-right: 0;
}
</style>