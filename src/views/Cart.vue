<template>
  <div class="container my-5 gaming-theme">
    <h2 class="text-center mb-4 text-purple">🛒 ตะกร้าสินค้า</h2>

    <!-- ถ้าไม่ได้ล็อกอิน -->
    <div v-if="!cartStore.isLoggedIn()" class="alert alert-warning text-center">
      <h5>⚠️ กรุณาเข้าสู่ระบบก่อนสั่งซื้อ</h5>
      <router-link to="/login" class="btn btn-purple mt-2">เข้าสู่ระบบ</router-link>
    </div>

    <!-- ถ้าตะกร้าว่าง -->
    <div v-else-if="cartStore.items.length === 0" class="text-center text-muted my-5">
      <i class="bi bi-cart-x" style="font-size: 4rem;"></i>
      <h5 class="mt-3">ไม่มีสินค้าในตะกร้า</h5>
      <router-link to="/" class="btn btn-purple mt-3">
        <i class="bi bi-shop"></i> เลือกซื้อสินค้า
      </router-link>
    </div>

    <!-- แสดงรายการสินค้า -->
    <div v-else>
      <table class="table table-hover">
        <thead class="table-dark-header text-center">
          <tr>
            <th style="width: 100px;">รูปภาพ</th>
            <th>สินค้า</th>
            <th style="width: 120px;">ราคา</th>
            <th style="width: 180px;">จำนวน</th>
            <th style="width: 120px;">รวม</th>
            <th style="width: 100px;">จัดการ</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in cartStore.items" :key="item.product_id">
            <td class="text-center">
              <img 
                :src="getImageUrl(item.image)" 
                alt="" 
                style="width: 60px; height: 60px; object-fit: cover; border-radius: 8px;"
              >
            </td>
            <td class="align-middle">{{ item.product_name }}</td>
            <td class="align-middle text-center">{{ item.price.toFixed(2) }} บาท</td>
            <td class="align-middle">
              <div class="d-flex align-items-center justify-content-center gap-2">
                <button 
                  class="btn btn-sm btn-outline-purple" 
                  @click="cartStore.updateQuantity(item.product_id, item.quantity - 1)"
                >
                  -
                </button>
                <input 
                  type="number" 
                  v-model.number="item.quantity" 
                  @change="cartStore.updateQuantity(item.product_id, item.quantity)" 
                  min="1" 
                  class="form-control text-center" 
                  style="width: 60px;"
                >
                <button 
                  class="btn btn-sm btn-outline-purple" 
                  @click="cartStore.updateQuantity(item.product_id, item.quantity + 1)"
                >
                  +
                </button>
              </div>
            </td>
            <td class="align-middle text-center text-price fw-bold">
              {{ (item.price * item.quantity).toFixed(2) }} บาท
            </td>
            <td class="align-middle text-center">
              <button 
                class="btn btn-sm btn-danger" 
                @click="cartStore.removeFromCart(item.product_id)"
              >
                <i class="bi bi-trash"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- แสดงยอดรวมและปุ่มสั่งซื้อ -->
      <div class="text-end mt-4">
        <h4 class="text-purple mb-3">
          ยอดรวมทั้งหมด: <span class="fw-bold">{{ cartStore.totalPrice.toFixed(2) }} บาท</span>
        </h4>
        <button class="btn btn-danger me-2" @click="confirmClearCart">
          <i class="bi bi-trash-fill"></i> ล้างตะกร้า
        </button>
        <button class="btn btn-purple btn-lg" @click="submitOrder">
          <i class="bi bi-check-circle-fill"></i> ยืนยันสั่งซื้อ
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { useCartStore } from '@/stores/cartStore';
import { useRouter } from 'vue-router';
import axios from 'axios';

export default {
  name: 'Cart',
  setup() {
    const cartStore = useCartStore();
    const router = useRouter();

    const getImageUrl = (imageName) => {
      if (!imageName) {
        return 'http://localhost:8081/finalproject/php_api/uploads/default-product.jpg';
      }
      return `http://localhost:8081/finalproject/php_api/uploads/${imageName}`;
    };

    const confirmClearCart = () => {
      if (confirm('คุณต้องการล้างตะกร้าสินค้าทั้งหมดหรือไม่?')) {
        cartStore.clearCart();
        alert('ล้างตะกร้าเรียบร้อยแล้ว');
      }
    };

    const submitOrder = async () => {
      // ตรวจสอบการล็อกอิน
      if (!cartStore.isLoggedIn()) {
        alert('❌ กรุณาเข้าสู่ระบบก่อนสั่งซื้อ');
        router.push('/login');
        return;
      }

      if (cartStore.items.length === 0) {
        alert('❌ ไม่มีสินค้าในตะกร้า');
        return;
      }

      // ✅ ดึง username จาก localStorage
      const username = cartStore.getUsername();
      
      console.log('📌 Username:', username);
      console.log('📌 Cart Items:', cartStore.items);

      const orderData = {
        customer_username: username, // ✅ ส่ง username ไปที่ order.php
        items: cartStore.items.map(item => ({
          product_id: item.product_id,
          quantity: item.quantity,
          price: item.price
        })),
        total: cartStore.totalPrice
      };

      console.log('📌 Order Data:', orderData);

      try {
        const response = await axios.post(
          'http://localhost:8081/finalproject/php_api/order.php',
          orderData
        );

        console.log('📌 Response:', response.data);

        if (response.data.success) {
          alert('✅ สั่งซื้อสำเร็จ! Order ID: ' + response.data.order_id);
          cartStore.clearCart();
          router.push('/customer-order-history');
        } else {
          alert('❌ เกิดข้อผิดพลาด: ' + response.data.message);
        }
      } catch (error) {
        console.error('❌ Error:', error);
        alert('เกิดข้อผิดพลาดในการสั่งซื้อ: ' + error.message);
      }
    };

    return {
      cartStore,
      getImageUrl,
      confirmClearCart,
      submitOrder
    };
  }
};
</script>

<style scoped>
:root, .gaming-theme {
  --primary-purple: #9d4edd;
  --primary-purple-hover: #c77dff;
  --card-bg: #1e1e1e;
  --text-light: #000000ff;
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

.text-price { 
  color: var(--primary-purple-hover) !important; 
}

.table {
  background-color: var(--card-bg);
  color: var(--text-light);
  border-color: var(--border-color);
  border-radius: 10px;
  overflow: hidden;
}

.table th, .table td {
  border-color: var(--border-color);
}

.table-dark-header th {
  background-color: var(--primary-purple);
  color: #fff;
  font-weight: bold;
}

.table-hover tbody tr:hover {
  background-color: rgba(157, 78, 221, 0.1);
}

.form-control {
  background-color: var(--dark-bg);
  color: var(--text-light);
  border-color: var(--border-color);
}

.form-control:focus {
  background-color: var(--dark-bg);
  color: var(--text-light);
  border-color: var(--primary-purple);
  box-shadow: 0 0 0 0.25rem rgba(157, 78, 221, 0.25);
}

.btn-purple {
  background: linear-gradient(135deg, var(--primary-purple) 0%, #7b1fa2 100%);
  color: #fff;
  border: none;
  border-radius: 25px;
  padding: 10px 25px;
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(138, 43, 226, 0.3);
}

.btn-purple:hover {
  background: linear-gradient(135deg, #c77dff 0%, #9d4edd 100%);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(138, 43, 226, 0.6);
}

.btn-outline-purple {
  color: var(--primary-purple);
  border: 2px solid var(--primary-purple);
  background: transparent;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.btn-outline-purple:hover {
  background: var(--primary-purple);
  color: #fff;
  transform: scale(1.05);
}

.alert-warning {
  background-color: rgba(255, 193, 7, 0.1);
  border: 1px solid #ffc107;
  color: var(--text-light);
  border-radius: 10px;
}

.btn-danger {
  border-radius: 25px;
  padding: 10px 20px;
}
</style>