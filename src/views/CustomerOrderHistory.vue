<template>
  <div class="container my-5 customer-theme">
    <div class="header-section text-center mb-5">
      <h2 class="text-gradient">
        <i class="bi bi-bag-check-fill me-2"></i>
        ประวัติคำสั่งซื้อของฉัน
      </h2>
      <p class="text-muted">ติดตามสถานะคำสั่งซื้อของคุณได้ที่นี่</p>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary"></div>
      <p class="mt-3 text-muted">กำลังโหลดข้อมูล...</p>
    </div>

    <!-- Error -->
    <div v-if="error" class="alert alert-danger text-center">
      <i class="bi bi-exclamation-triangle-fill me-2"></i>{{ error }}
    </div>

    <!-- Empty -->
    <div v-if="!loading && filteredOrders.length === 0" class="empty-state text-center py-5">
      <i class="bi bi-cart-x" style="font-size: 5rem; color: #ccc;"></i>
      <h4 class="mt-4 text-muted">ยังไม่มีคำสั่งซื้อ</h4>
      <router-link to="/" class="btn btn-primary mt-3">
        <i class="bi bi-shop me-2"></i>เริ่มช็อปปิ้ง
      </router-link>
    </div>

    <!-- Orders List -->
    <div v-if="!loading && filteredOrders.length > 0">
      <div v-for="order in filteredOrders" :key="order.order_id" class="order-card mb-4">
        
        <!-- Header -->
        <div class="order-header">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <h5 class="mb-1">
                <i class="bi bi-receipt me-2"></i>คำสั่งซื้อ #{{ order.order_id }}
              </h5>
              <small class="text-muted">
                <i class="bi bi-calendar3 me-1"></i>{{ formatDate(order.order_date) }}
              </small>
            </div>
            <div class="text-end">
              <span :class="['status-badge', getStatusClass(order.order_status)]">
                <i :class="getStatusIcon(order.order_status)" class="me-1"></i>
                {{ order.order_status }}
              </span>
              <div class="total-price mt-2">
                <small class="text-muted d-block">ยอดรวม</small>
                <strong class="text-primary">฿{{ order.total_price.toLocaleString('th-TH') }}</strong>
              </div>
            </div>
          </div>
        </div>

        <!-- Items -->
        <div class="order-body">
          <div v-for="item in order.items" :key="item.order_item_id" class="order-item">
            <div class="row align-items-center">
              <div class="col-md-2 col-3">
                <div class="product-image-wrapper">
                  <img 
                    :src="getImageUrl(item.image)" 
                    :alt="item.product_name"
                    class="product-image"
                    @error="handleImageError"
                  />
                </div>
              </div>
              
              <div class="col-md-5 col-9">
                <h6 class="product-name mb-1">{{ item.product_name }}</h6>
                <div class="product-details">
                  <span class="badge bg-light text-dark me-2">
                    <i class="bi bi-box me-1"></i>จำนวน: {{ item.quantity }}
                  </span>
                  <span class="text-muted">฿{{ item.price.toLocaleString('th-TH') }} / ชิ้น</span>
                </div>
              </div>
              
              <div class="col-md-3 col-6 text-center mt-3 mt-md-0">
                <small class="d-block text-muted mb-1">สถานะสินค้า</small>
                <span :class="['item-status-badge', getStatusClass(item.item_status)]">
                  {{ item.item_status || 'รอดำเนินการ' }}
                </span>
              </div>
              
              <div class="col-md-2 col-6 text-end mt-3 mt-md-0">
                <small class="d-block text-muted mb-1">ราคา</small>
                <strong class="text-primary">
                  ฿{{ (item.price * item.quantity).toLocaleString('th-TH') }}
                </strong>
              </div>
            </div>
          </div>
        </div>

        <!-- Footer -->
        <div class="order-footer">
          <div class="d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-2">
              <i :class="[getProgressIcon(order.order_status), 'progress-icon']"></i>
              <span class="progress-text">{{ getProgressText(order.order_status) }}</span>
            </div>
            <div>
              <!-- ✅ ปุ่มยกเลิกคำสั่งซื้อ -->
              <button 
                v-if="order.order_status === 'รอดำเนินการ'"
                @click="cancelOrder(order.order_id)"
                class="btn btn-danger btn-sm me-2"
              >
                <i class="bi bi-x-circle me-1"></i>ยกเลิก
              </button>
              <button class="btn btn-outline-primary btn-sm" @click="toggleDetails(order.order_id)">
                <i class="bi bi-info-circle me-1"></i>รายละเอียด
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue';

export default {
  name: 'CustomerOrderHistory',
  setup() {
    const orders = ref([]);
    const loading = ref(true);
    const error = ref(null);

    // ✅ ใช้ computed เพื่อกรองคำสั่งซื้อที่ยกเลิกออก
    const filteredOrders = computed(() => {
      return orders.value.filter(order => 
        order.order_status !== 'ยกเลิก'
      );
    });

    onMounted(() => {
      const username = localStorage.getItem('username');
      if (!username) {
        error.value = 'กรุณาเข้าสู่ระบบก่อน';
        loading.value = false;
        return;
      }
      fetchOrders(username);
    });

    const fetchOrders = async (username) => {
      try {
        const res = await fetch('http://localhost:8081/finalproject/php_api/customer_orders.php', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ username })
        });
        const data = await res.json();
        orders.value = data.success ? data.data : [];
        if (!data.success) error.value = data.message;
      } catch (err) {
        error.value = 'เกิดข้อผิดพลาด: ' + err.message;
      } finally {
        loading.value = false;
      }
    };

    // ✅ ฟังก์ชันยกเลิกคำสั่งซื้อ
    const cancelOrder = async (orderId) => {
      if (!confirm(`ต้องการยกเลิกคำสั่งซื้อ #${orderId} หรือไม่?`)) return;
      
      try {
        const res = await fetch('http://localhost:8081/finalproject/php_api/cancel_order.php', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ order_id: orderId })
        });
        const data = await res.json();
        
        if (data.success) {
          alert('✅ ยกเลิกคำสั่งซื้อเรียบร้อยแล้ว');
          
          // ✅ วิธีที่ 1: ลบออกจาก array ทันที (ไม่ต้องโหลดใหม่)
          orders.value = orders.value.filter(order => order.order_id !== orderId);
          
          // หรือ วิธีที่ 2: โหลดข้อมูลใหม่
          // const username = localStorage.getItem('username');
          // fetchOrders(username);
        } else {
          alert('❌ เกิดข้อผิดพลาด: ' + data.message);
        }
      } catch (err) {
        alert('เกิดข้อผิดพลาด: ' + err.message);
      }
    };

    const formatDate = (d) => new Date(d).toLocaleDateString('th-TH', {
      year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit'
    });

    const getStatusClass = (s) => {
      if (!s) return 'status-pending';
      const sl = s.toLowerCase();
      if (sl.includes('เสร็จ') || sl.includes('จัดส่ง')) return 'status-completed';
      if (sl.includes('ยกเลิก')) return 'status-cancelled';
      return 'status-pending';
    };

    const getStatusIcon = (s) => {
      if (!s) return 'bi bi-clock-history';
      const sl = s.toLowerCase();
      if (sl.includes('เสร็จ') || sl.includes('จัดส่ง')) return 'bi bi-check-circle-fill';
      if (sl.includes('ยกเลิก')) return 'bi bi-x-circle-fill';
      return 'bi bi-clock-history';
    };

    const getProgressIcon = (s) => {
      if (!s) return 'bi bi-hourglass-split';
      const sl = s.toLowerCase();
      if (sl.includes('เสร็จ') || sl.includes('จัดส่ง')) return 'bi bi-truck';
      if (sl.includes('ยกเลิก')) return 'bi bi-x-octagon';
      return 'bi bi-hourglass-split';
    };

    const getProgressText = (s) => {
      if (!s) return 'กำลังดำเนินการ...';
      const sl = s.toLowerCase();
      if (sl.includes('เสร็จ') || sl.includes('จัดส่ง')) return 'สินค้าถึงมือคุณแล้ว';
      if (sl.includes('ยกเลิก')) return 'คำสั่งซื้อถูกยกเลิก';
      return 'กำลังเตรียมสินค้า...';
    };

    const getImageUrl = (img) => {
      if (!img || img.trim() === '') return 'http://localhost:8081/finalproject/php_api/uploads/default-product.jpg';
      return `http://localhost:8081/finalproject/php_api/uploads/${img.trim()}`;
    };

    const handleImageError = (e) => {
      e.target.src = 'http://localhost:8081/finalproject/php_api/uploads/default-product.jpg';
      e.target.onerror = null;
    };

    const toggleDetails = (id) => console.log('Details:', id);

    return {
      orders,
      filteredOrders, // ✅ เพิ่ม
      loading,
      error,
      formatDate,
      getStatusClass,
      getStatusIcon,
      getProgressIcon,
      getProgressText,
      getImageUrl,
      handleImageError,
      toggleDetails,
      cancelOrder
    };
  }
};
</script>

<style scoped>
.customer-theme {
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: 100vh;
  padding: 2rem 0;
}

.header-section {
  background: white;
  padding: 2rem;
  border-radius: 15px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.08);
}

.text-gradient {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-weight: 700;
  font-size: 2rem;
}

.order-card {
  background: white;
  border-radius: 15px;
  overflow: hidden;
  box-shadow: 0 4px 15px rgba(0,0,0,0.1);
  transition: all 0.3s ease;
}

.order-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0,0,0,0.15);
}

.order-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 1.5rem;
}

.status-badge {
  display: inline-block;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 600;
  font-size: 0.875rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.status-completed {
  background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
  color: white;
}

.status-pending {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: white;
}

.status-cancelled {
  background: linear-gradient(135deg, #434343 0%, #000000 100%);
  color: white;
}

.item-status-badge {
  display: inline-block;
  padding: 0.4rem 0.8rem;
  border-radius: 15px;
  font-size: 0.8rem;
  font-weight: 600;
}

.order-body {
  padding: 1.5rem;
}

.order-item {
  padding: 1rem;
  margin-bottom: 1rem;
  border-radius: 10px;
  background: #f8f9fa;
  transition: background 0.3s ease;
}

.order-item:hover {
  background: #e9ecef;
}

.order-item:last-child {
  margin-bottom: 0;
}

.product-image-wrapper {
  position: relative;
  width: 100%;
  padding-top: 100%;
  overflow: hidden;
  border-radius: 10px;
  background: white;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.product-image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.product-image:hover {
  transform: scale(1.05);
}

.product-name {
  font-weight: 600;
  color: #2c3e50;
}

.product-details {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.order-footer {
  padding: 1rem 1.5rem;
  background: #f8f9fa;
  border-top: 1px solid #e9ecef;
}

.progress-icon {
  font-size: 1.2rem;
  color: #667eea;
}

.progress-text {
  font-weight: 500;
  color: #495057;
}

.total-price strong {
  font-size: 1.2rem;
}

/* ปุ่มยกเลิก */
.btn-danger {
  background: linear-gradient(135deg, #ee0979 0%, #ff6a00 100%);
  border: none;
  transition: all 0.3s ease;
}

.btn-danger:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(238, 9, 121, 0.4);
}

@media (max-width: 768px) {
  .text-gradient {
    font-size: 1.5rem;
  }
  
  .order-header {
    padding: 1rem;
  }
  
  .order-body {
    padding: 1rem;
  }
  
  .product-name {
    font-size: 0.9rem;
  }
}
</style>