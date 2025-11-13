<template>
  <nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
      <a class="navbar-brand fw-bold" href="/">CoreGear</a>
      <button
        class="navbar-toggler"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          
          <template v-if="isLoggedIn">
            <!-- Admin Menu -->
            <li class="nav-item">
              <router-link class="nav-link" to="/orders">Orders</router-link>
            </li>
            <li class="nav-item">
              <router-link class="nav-link" to="/show_orders">Orders Detail</router-link>
            </li>
            <li class="nav-item">
              <router-link class="nav-link" to="/product_edit">Add Product</router-link>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/report">Report</a>
            </li>
            <li class="nav-item">
              <a class="nav-link text-danger" href="#" @click="logout">Logout (Admin)</a>
            </li>
          </template>

          <template v-else-if="isCustomerLoggedIn">
            <li class="nav-item">
              <router-link class="nav-link" to="/" exact-active-class="router-link-active">
                <i class="bi bi-house-door-fill me-1"></i>Menu
              </router-link>
            </li>
            <li class="nav-item">
              <router-link class="nav-link" to="/my-orders" exact-active-class="router-link-active">
                <i class="bi bi-bag-check-fill me-1"></i>ประวัติคำสั่งซื้อ
              </router-link>
            </li>
            <li class="nav-item">
              <a class="nav-link text-warning" href="#" @click="customerLogout">Logout (Customer)</a>
            </li>
          </template>

          <template v-else>
            <li class="nav-item">
              <router-link class="nav-link" to="/" exact-active-class="router-link-active">Menu</router-link>
            </li>
            <li class="nav-item">
              <router-link class="nav-link" to="/login">Login</router-link>
            </li>
            <li class="nav-item">
              <router-link class="nav-link" to="/admin-login">Admin</router-link>
            </li>
          </template>

        </ul>

        <!-- ตะกร้าสินค้า (แสดงเฉพาะลูกค้า) -->
        <div v-if="isCustomerLoggedIn" class="d-flex align-items-center">
          <button 
            @click="toggleCart" 
            class="btn btn-primary"
            title="Cart"
          >
            <i class="bi bi-cart3 me-2"></i>
            Cart
            <span v-if="cartTotalItems > 0" class="cart-badge-solid">
              {{ cartTotalItems }}
            </span>
          </button>
        </div>

        <form class="d-flex" role="search" v-if="isLoggedIn">
          <input
            class="form-control me-2"
            type="search"
            placeholder="Search"
            aria-label="Search"
          />
          <button class="btn btn-outline-purple" type="submit">Search</button>
        </form>
      </div>
    </div>
  </nav>

  <!-- ตะกร้าสินค้า Sidebar -->
  <div v-if="showCart" class="cart-overlay" @click="showCart = false">
    <div class="cart-sidebar" @click.stop>
      <div class="cart-header">
        <h5 class="cart-title">
          <i class="bi bi-cart3 me-2"></i> 
          ตะกร้าสินค้า 
          <span class="cart-badge">{{ cartTotalItems }}</span>
        </h5>
        <button @click="showCart = false" class="btn-close"></button>
      </div>
      
      <div class="cart-body">
        <div v-if="cartItems.length === 0" class="empty-cart text-center py-4">
          <i class="bi bi-cart-x cart-empty-icon"></i>
          <p class="mt-3 text-muted">ตะกร้าว่างเปล่า</p>
        </div>
        
        <div v-else>
          <div v-for="item in cartItems" :key="item.product_id" class="cart-item">
            <img 
              :src="getImageUrl(item.image)" 
              :alt="item.product_name" 
              class="item-image"
              @error="handleImageError"
            >
            <div class="item-info">
              <h6 class="mb-1 product-name">{{ item.product_name }}</h6>
              <p class="mb-1 text-price">฿{{ item.price.toLocaleString('th-TH') }}</p>
              <div class="quantity-controls">
                <button 
                  @click="decreaseQuantity(item.product_id)" 
                  class="btn btn-sm btn-outline-purple"
                >-</button>
                <span class="quantity mx-2">{{ item.quantity }}</span>
                <button 
                  @click="increaseQuantity(item.product_id)" 
                  class="btn btn-sm btn-outline-purple"
                >+</button>
                <button 
                  @click="removeItem(item.product_id)" 
                  class="btn btn-sm btn-remove ms-2"
                >
                  <i class="bi bi-trash"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div v-if="cartItems.length > 0" class="cart-footer">
        <div class="total-price mb-3">
          <strong>รวมทั้งหมด: ฿{{ cartTotalPrice.toLocaleString('th-TH') }}</strong>
        </div>
        <button @click="checkout" class="btn btn-checkout w-100">
          <i class="bi bi-bag-check me-2"></i> สั่งซื้อ
        </button>
      </div>
    </div>
  </div>

  <div class="main-content">
    <router-view />
  </div>
</template>

<script>
import { useCartStore } from './stores/cartStore';
import { computed, ref, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';

export default {
  name: "App",
  setup() {
    const router = useRouter();
    
    const isLoggedIn = ref(false);
    const isCustomerLoggedIn = ref(false);
    const showCart = ref(false);
    
    const cartStore = useCartStore();
    
    const cartItems = computed(() => cartStore.items);
    const cartTotalPrice = computed(() => cartStore.totalPrice);
    const cartTotalItems = computed(() => cartStore.totalItems);
    
    const checkLogin = () => {
      isLoggedIn.value = localStorage.getItem("adminLogin") === "true";
      isCustomerLoggedIn.value = localStorage.getItem("customerLogin") === "true";
    };
    
    const toggleCart = () => {
      showCart.value = !showCart.value;
    };
    
    const increaseQuantity = (productId) => {
      const item = cartStore.items.find(item => item.product_id === productId);
      if (item) {
        cartStore.updateQuantity(productId, item.quantity + 1);
      }
    };
    
    const decreaseQuantity = (productId) => {
      const item = cartStore.items.find(item => item.product_id === productId);
      if (item && item.quantity > 1) {
        cartStore.updateQuantity(productId, item.quantity - 1);
      }
    };
    
    const removeItem = (productId) => {
      if (confirm('ต้องการลบสินค้าออกจากตะกร้าหรือไม่?')) {
        cartStore.removeFromCart(productId);
      }
    };
    
    const checkout = () => {
      showCart.value = false;
      router.push('/cart'); // ✅ เปลี่ยนไปหน้า Cart
    };
    
    const getImageUrl = (imageName) => {
      if (!imageName) return 'http://localhost:8081/finalproject/php_api/uploads/default-product.jpg';
      return `http://localhost:8081/finalproject/php_api/uploads/${imageName}`;
    };
    
    const handleImageError = (e) => {
      e.target.src = 'http://localhost:8081/finalproject/php_api/uploads/default-product.jpg';
    };
    
    const logout = () => {
      if (confirm("ต้องการออกจากระบบ (Admin) หรือไม่?")) {
        localStorage.removeItem("adminLogin");
        localStorage.removeItem("username");
        localStorage.removeItem("token");
        isLoggedIn.value = false;
        router.push("/");
      }
    };
    
    const customerLogout = () => {
      if (confirm("ต้องการออกจากระบบ (Customer) หรือไม่?")) {
        cartStore.clearCart();
        localStorage.removeItem("customerLogin");
        localStorage.removeItem("username"); // ✅ แก้จาก customer_username
        isCustomerLoggedIn.value = false;
        showCart.value = false;
        router.push("/");
      }
    };
    
    onMounted(() => {
      checkLogin();
    });
    
    watch(router.currentRoute, () => {
      checkLogin();
    });
    
    return {
      isLoggedIn,
      isCustomerLoggedIn,
      showCart,
      cartItems,
      cartTotalPrice,
      cartTotalItems,
      checkLogin,
      toggleCart,
      increaseQuantity,
      decreaseQuantity,
      removeItem,
      checkout,
      getImageUrl,
      handleImageError,
      logout,
      customerLogout
    };
  }
};
</script>



<style scoped>
/* เพิ่ม CSS Variables ที่ด้านบน */
:root {
  --primary-purple: #9d4edd;
  --primary-purple-hover: #c77dff;
  --card-bg: #1e1e1e; 
  --text-light: #f4f4f4;
  --cyber-red: #e02a6f; 
  --border-color: #333;
  --dark-bg: #121212; /* เพิ่มตัวนี้ */
}

.main-content {
  background-color: var(--dark-bg);
  color: var(--text-light);
  min-height: calc(100vh - 70px); 
}

.navbar {
  background-color: var(--card-bg) !important;
  border-bottom: 2px solid var(--primary-purple); 
  box-shadow: 0 4px 15px rgba(157, 78, 221, 0.2);
  min-height: 70px; 
}

.navbar-brand {
  color: var(--primary-purple) !important;
  font-size: 1.5rem;
  transition: color 0.3s ease;
}

.navbar-brand:hover {
  color: var(--text-light) !important;
}

.nav-link {
  color: var(--text-light) !important;
  font-weight: 500;
  transition: color 0.3s ease, background-color 0.3s ease;
  padding: 0.5rem 1rem;
  border-radius: 5px;
  margin: 0 2px;
}

.nav-link:hover,
.nav-link.router-link-active { 
  color: var(--primary-purple) !important;
  background-color: rgba(157, 78, 221, 0.1); 
  text-decoration: none;
}

.nav-link.text-danger {
  color: var(--cyber-red) !important;
  font-weight: bold;
}

.nav-link.text-danger:hover {
  color: var(--text-light) !important;
  background-color: rgba(224, 42, 111, 0.2); 
}

.nav-link.text-warning {
  color: #ffc107 !important; 
  font-weight: bold;
}

.nav-link.text-warning:hover {
  color: var(--text-light) !important;
  background-color: rgba(255, 193, 7, 0.2);
}

.navbar-toggler {
  border-color: rgba(157, 78, 221, 0.5); 
}

.navbar-toggler:focus {
  box-shadow: 0 0 5px var(--primary-purple); 
}

.form-control {
  background-color: var(--card-bg);
  color: var(--text-light);
  border-color: var(--border-color);
}

.form-control:focus {
  background-color: var(--card-bg);
  color: var(--text-light);
  border-color: var(--primary-purple);
  box-shadow: 0 0 0 0.25rem rgba(157, 78, 221, 0.25);
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

/* ตะกร้าสินค้า */
.cart-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  z-index: 1040;
  backdrop-filter: blur(5px);
}

.cart-sidebar {
  position: fixed;
  top: 0;
  right: 0;
  width: 420px;
  height: 100vh;
  background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
  box-shadow: -5px 0 25px rgba(157, 78, 221, 0.3);
  z-index: 1050;
  display: flex;
  flex-direction: column;
  color: #ffffff;
  border-left: 3px solid var(--primary-purple);
}

.cart-header {
  padding: 1.5rem;
  border-bottom: 2px solid var(--primary-purple);
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(135deg, var(--primary-purple) 0%, #7b1fa2 100%);
  position: relative;
  overflow: hidden;
}

.cart-header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.1) 50%, transparent 70%);
  animation: shimmer 3s infinite;
}

@keyframes shimmer {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(100%); }
}

.cart-title {
  color: #ffffff;
  font-weight: 700;
  font-size: 1.3rem;
  margin: 0;
  display: flex;
  align-items: center;
  text-shadow: 0 2px 4px rgba(0,0,0,0.3);
}

.cart-badge {
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
  color: white;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 0.8rem;
  font-weight: 700;
  margin-left: 8px;
  box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4);
}

.cart-body {
  flex: 1;
  overflow-y: auto;
  padding: 1.5rem;
  background: rgba(30, 30, 30, 0.8);
}

.cart-item {
  display: flex;
  margin-bottom: 1.5rem;
  padding: 1rem;
  border-radius: 12px;
  background: linear-gradient(145deg, #2d2d2d 0%, #3d3d3d 100%);
  border: 1px solid #444;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(0,0,0,0.2);
}

.cart-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(157, 78, 221, 0.3);
  border-color: var(--primary-purple);
}

.item-image {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 8px;
  margin-right: 1rem;
  border: 2px solid #444;
  transition: border-color 0.3s ease;
}

.cart-item:hover .item-image {
  border-color: var(--primary-purple);
}

.item-info {
  flex: 1;
}

.product-name {
  color: #ffffff;
  font-weight: 600;
  font-size: 0.95rem;
  margin-bottom: 0.5rem;
}

.text-price {
  color: var(--primary-purple) !important;
  font-weight: 700;
  font-size: 1rem;
  text-shadow: 0 0 10px rgba(157, 78, 221, 0.5);
  margin-bottom: 0.75rem;
}

.quantity-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.5rem;
}

.btn-outline-purple {
  color: var(--primary-purple);
  border: 2px solid var(--primary-purple);
  background: transparent;
  border-radius: 8px;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  transition: all 0.3s ease;
}

.btn-outline-purple:hover {
  background: var(--primary-purple);
  color: #ffffff;
  transform: scale(1.1);
}

.quantity {
  padding: 0 0.75rem;
  font-weight: 700;
  min-width: 40px;
  text-align: center;
  color: #ffffff;
  background: rgba(157, 78, 221, 0.2);
  border-radius: 6px;
  border: 1px solid var(--primary-purple);
}

.btn-remove {
  background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
  color: white;
  border: none;
  border-radius: 8px;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.btn-remove:hover {
  background: linear-gradient(135deg, #c82333 0%, #bd2130 100%);
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(220, 53, 69, 0.4);
}

.cart-footer {
  padding: 1.5rem;
  border-top: 2px solid var(--primary-purple);
  background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%);
}

.total-price {
  color: #ffffff;
  font-size: 1.2rem;
  text-align: center;
  padding: 1rem;
  background: rgba(157, 78, 221, 0.1);
  border-radius: 10px;
  border: 1px solid var(--primary-purple);
}

.total-price strong {
  color: var(--primary-purple);
  text-shadow: 0 0 10px rgba(157, 78, 221, 0.5);
}

.btn-checkout {
  background: linear-gradient(135deg, var(--primary-purple) 0%, #7b1fa2 100%);
  color: white;
  border: none;
  border-radius: 12px;
  padding: 12px 24px;
  font-weight: 700;
  font-size: 1.1rem;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(157, 78, 221, 0.4);
  position: relative;
  overflow: hidden;
}

.btn-checkout::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
  transition: left 0.5s;
}

.btn-checkout:hover::before {
  left: 100%;
}

.btn-checkout:hover {
  background: linear-gradient(135deg, #9d4edd 0%, #8a2be2 100%);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(157, 78, 221, 0.6);
}

.empty-cart {
  color: #6c757d;
  padding: 3rem 1rem;
}

.cart-empty-icon {
  font-size: 4rem;
  color: #6c757d;
  opacity: 0.5;
}

.btn-close {
  background: transparent;
  border: none;
  font-size: 1.2rem;
  color: #ffffff;
  opacity: 0.8;
  transition: all 0.3s ease;
}

.btn-close:hover {
  opacity: 1;
  transform: scale(1.1);
  color: var(--primary-purple);
}

@media (max-width: 768px) {
  .cart-sidebar {
    width: 100%;
  }
  
  .cart-header {
    padding: 1rem;
  }
  
  .cart-title {
    font-size: 1.1rem;
  }
  
  .cart-body {
    padding: 1rem;
  }
}






</style>