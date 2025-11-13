import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

export const useCartStore = defineStore('cart', () => {
  const items = ref([]);
  
  // ✅ เพิ่มฟังก์ชันตรวจสอบการล็อกอิน
  const isLoggedIn = () => {
    return localStorage.getItem('customerLogin') === 'true' && 
           localStorage.getItem('username') !== null;
  };
  
  // ✅ เพิ่มฟังก์ชันดึง username
  const getUsername = () => {
    return localStorage.getItem('username');
  };
  
  // โหลดจาก localStorage
  const loadCart = () => {
    const saved = localStorage.getItem('customer_cart');
    if (saved) {
      try {
        items.value = JSON.parse(saved);
      } catch (e) {
        console.error('Error loading cart from localStorage:', e);
        items.value = [];
      }
    }
  };
  
  // บันทึกลง localStorage
  const saveCart = () => {
    localStorage.setItem('customer_cart', JSON.stringify(items.value));
  };
  
  // เพิ่มสินค้า
  const addToCart = (product) => {
    const existingItem = items.value.find(item => item.product_id === product.product_id);
    
    if (existingItem) {
      existingItem.quantity += 1;
    } else {
      items.value.push({
        product_id: product.product_id,
        product_name: product.product_name,
        price: parseFloat(product.price),
        image: product.image,
        quantity: 1
      });
    }
    saveCart();
  };
  
  // ลบสินค้า
  const removeFromCart = (productId) => {
    items.value = items.value.filter(item => item.product_id !== productId);
    saveCart();
  };
  
  // อัพเดทจำนวน
  const updateQuantity = (productId, quantity) => {
    const item = items.value.find(item => item.product_id === productId);
    if (item) {
      if (quantity <= 0) {
        removeFromCart(productId);
      } else {
        item.quantity = quantity;
        saveCart();
      }
    }
  };
  
  // ล้างตะกร้า
  const clearCart = () => {
    items.value = [];
    localStorage.removeItem('customer_cart');
  };
  
  // คำนวณรวม
  const totalPrice = computed(() => {
    return items.value.reduce((total, item) => total + (item.price * item.quantity), 0);
  });
  
  const totalItems = computed(() => {
    return items.value.reduce((total, item) => total + item.quantity, 0);
  });
  
  // โหลดครั้งแรก
  loadCart();
  
  return {
    items,
    addToCart,
    removeFromCart,
    updateQuantity,
    clearCart,
    totalPrice,
    totalItems,
    loadCart,
    saveCart,
    isLoggedIn,    // ✅ เพิ่ม
    getUsername    // ✅ เพิ่ม
  };
});