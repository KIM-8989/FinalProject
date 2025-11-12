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
              :src="getImageUrl(product.image)"
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
                {{ formatPrice(product.price) }} บาท
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
  </div>
</template>

<script>
import { ref, onMounted } from "vue";
import axios from "axios";
import { useRouter } from 'vue-router';
import { useCartStore } from '@/stores/cartStore';

export default {
  name: "ProductList",
  setup() {
    const router = useRouter();
    const cartStore = useCartStore();
    
    const products = ref([]);
    const categories = ref([]);
    const selectedCategory = ref("");
    const loading = ref(true);
    const error = ref(null);

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
        const response = await axios.get(
          "http://localhost:8081/finalproject/php_api/products.php"
        );

        console.log('API Response:', response.data); // Debug

        if (response.data.success && response.data.products) {
          // 🔧 กรองตามหมวดหมู่ถ้ามีการเลือก
          if (categoryId) {
            products.value = response.data.products.filter(
              p => p.category_id == categoryId
            );
          } else {
            products.value = response.data.products;
          }
          console.log('Filtered products:', products.value.length); // Debug
        } else {
          products.value = [];
          error.value = "ไม่พบข้อมูลสินค้า";
        }
      } catch (err) {
        console.error("Error:", err);
        error.value = "เกิดข้อผิดพลาดในการโหลดสินค้า: " + err.message;
        products.value = [];
      } finally {
        loading.value = false;
      }
    };

    // ✅ กรองสินค้าตามหมวดหมู่
    const filterByCategory = (categoryId) => {
      selectedCategory.value = categoryId;
      fetchProducts(categoryId);
    };

    // ✅ เพิ่มสินค้าเข้าตะกร้า
    const addToCart = (product) => {
      const cartProduct = {
        product_id: product.product_id,
        product_name: product.product_name,
        price: parseFloat(product.price),
        image: product.image,
        quantity: 1
      };
      
      cartStore.addToCart(cartProduct);
      alert(`✅ เพิ่ม "${product.product_name}" ลงตะกร้าเรียบร้อย!`);
    };

    // ✅ จัดการ URL รูปภาพ
    const getImageUrl = (imageName) => {
      if (!imageName) {
        return 'http://localhost:8081/finalproject/php_api/uploads/default-product.jpg';
      }
      return `http://localhost:8081/finalproject/php_api/uploads/${imageName}`;
    };

    const handleImageError = (event) => {
      event.target.src = "http://localhost:8081/finalproject/php_api/uploads/default-product.jpg";
    };

    // ✅ Format ราคา
    const formatPrice = (price) => {
      return parseFloat(price).toLocaleString('th-TH', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
      });
    };

    // โหลดข้อมูลเมื่อเริ่มต้น
    onMounted(() => {
      fetchCategories();
      fetchProducts();
    });

    return {
      products, 
      categories, 
      selectedCategory,
      loading, 
      error, 
      addToCart, 
      filterByCategory, 
      getImageUrl,
      handleImageError,
      formatPrice
    };
  },
};
</script>

<style scoped>
:root,
.gaming-theme {
  --primary-purple: #8a2be2;
  --primary-purple-hover: #9d4edd;
  --neon-glow: 0 0 15px rgba(138, 43, 226, 0.7);
  --text-light: #ffffff;
  --text-muted: #cccccc;
  --border-color: #444;
  --card-bg: #1a1a1a;
  --dark-bg: #0a0a0a;
}

.gaming-theme {
  color: var(--text-light);
  min-height: 100vh;
}

.text-purple {
  color: var(--primary-purple) !important;
  text-shadow: var(--neon-glow);
}

.card {
  transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
  border: 1px solid var(--border-color);
  border-radius: 15px;
  background: linear-gradient(145deg, #1a1a1a 0%, #2d2d2d 100%);
  color: var(--text-light);
  overflow: hidden;
  position: relative;
}

.card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--primary-purple), var(--primary-purple-hover));
  opacity: 0;
  transition: opacity 0.3s ease;
}

.card:hover::before {
  opacity: 1;
}

.card:hover {
  transform: translateY(-8px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.4), var(--neon-glow);
  border-color: var(--primary-purple);
}

.card-img-wrapper {
  overflow: hidden;
  border-radius: 15px 15px 0 0;
  position: relative;
}

.card-img-top {
  border-radius: 0;
  transition: transform 0.4s ease;
}

.card:hover .card-img-top {
  transform: scale(1.15);
}

.card-title {
  color: var(--text-light);
  font-size: 1.1rem;
  margin-bottom: 0.5rem;
  text-shadow: 0 2px 4px rgba(0,0,0,0.5);
}

.text-price {
  color: var(--primary-purple) !important;
  text-shadow: 0 0 10px var(--primary-purple);
  margin-bottom: 0.75rem;
  font-size: 1.3rem !important;
}

.card-body .btn-purple {
  width: 100%;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.btn-purple {
  background: linear-gradient(135deg, var(--primary-purple) 0%, #7b1fa2 100%);
  color: #fff;
  border: none;
  border-radius: 25px;
  padding: 10px 20px;
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(138, 43, 226, 0.3);
  position: relative;
  overflow: hidden;
}

.btn-purple::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
  transition: left 0.5s;
}

.btn-purple:hover::before {
  left: 100%;
}

.btn-purple:hover {
  background: linear-gradient(135deg, #9d4edd 0%, #8a2be2 100%);
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 8px 25px rgba(138, 43, 226, 0.6);
}

.btn-outline-purple {
  color: var(--primary-purple);
  border: 2px solid var(--primary-purple);
  background: transparent;
  border-radius: 25px;
  padding: 8px 16px;
  font-weight: 600;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.btn-outline-purple:hover {
  background: var(--primary-purple);
  color: #fff;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(138, 43, 226, 0.4);
}

.category-scroll-container {
  display: flex;
  overflow-x: auto;
  white-space: nowrap;
  padding-bottom: 15px;
  margin-bottom: -15px;
  gap: 10px;
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
  font-weight: 600;
  padding: 10px 20px;
  border-radius: 25px;
  transition: all 0.3s ease;
  border: 2px solid transparent;
}

.category-btn:hover {
  transform: translateY(-2px);
}

.form-label {
  margin-bottom: 1rem;
  font-size: 1.2rem;
  text-shadow: 0 2px 4px rgba(0,0,0,0.3);
}

.spinner-border.text-light {
  border-color: var(--primary-purple) transparent transparent transparent;
}

.alert-danger {
  background: rgba(220, 53, 69, 0.1);
  border: 1px solid #dc3545;
  color: #fff;
  border-radius: 10px;
}

@media (max-width: 768px) {
  .card {
    margin-bottom: 20px;
  }
  
  .category-btn {
    padding: 8px 16px;
    font-size: 0.9rem;
  }
  
  .text-price {
    font-size: 1.1rem !important;
  }
}
</style>