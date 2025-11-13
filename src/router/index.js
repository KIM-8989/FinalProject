import { createRouter, createWebHistory } from "vue-router";

const routes = [
  {
    path: "/",
    name: "productList",
    component: () => import("../views/ProductList.vue"),
  },

  {
    path: "/product_edit",
    name: "product_edit",
    component: () => import("../views/product_edit.vue"),
    meta: { requiresAuth: true, role: 'admin' },
  },
  
  {
    path: "/orders",
    name: "OrderList",
    component: () => import("../views/OrderList.vue"),
    meta: { requiresAuth: true, role: 'admin' },
  },
  {
    path: "/show_orders",
    name: "show_orders",
    component: () => import("../views/Show_Order.vue"),
    meta: { requiresAuth: true, role: 'admin' },
  },
  {
    path: "/report",
    name: "ReportChart",
    component: () => import("../views/ReportChart.vue"),
    meta: { requiresAuth: true, role: 'admin' },
  },
  
  {
    path: "/admin-login",
    name: "AdminLogin",
    component: () => import("../views/AdminLogin.vue"),
  },
  {
    path: "/login",
    name: "CustomerLogin",
    component: () => import("../views/login.vue"),
  },
  {
    path: "/register",
    name: "CustomerRegister", 
    component: () => import("../views/Register.vue"), 
  },
  
  {
    path: '/my-orders',
    name: 'CustomerOrderHistory',
    component: () => import('@/views/CustomerOrderHistory.vue'),
    meta: { requiresAuth: true, role: 'customer' }
  },
  {
  path: '/cart',
  name: 'Cart',
  component: () => import('@/views/Cart.vue')
}
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

// Navigation Guard — ตรวจสอบการเข้าสู่ระบบแยก Admin และ Customer
router.beforeEach((to, from, next) => {
  const isAdminLoggedIn = localStorage.getItem("adminLogin") === "true";
  const isCustomerLoggedIn = localStorage.getItem("customerLogin") === "true";

  // ถ้าหน้านั้นต้องล็อกอินก่อน
  if (to.meta.requiresAuth) {
    const requiredRole = to.meta.role;

    // ถ้าเป็นหน้า Admin และ Admin Login แล้ว → ผ่าน
    if (requiredRole === 'admin' && isAdminLoggedIn) {
      next();
    }
    // ถ้าเป็นหน้า Customer และ Customer Login แล้ว → ผ่าน
    else if (requiredRole === 'customer' && isCustomerLoggedIn) {
      next();
    }
    // ถ้าไม่ตรงเงื่อนไข → ส่งกลับหน้า Login
    else {
      alert("⚠ กรุณาเข้าสู่ระบบก่อนใช้งานหน้านี้");
      if (requiredRole === 'admin') {
        next("/admin-login");
      } else {
        next("/login");
      }
    }
  }
  // ถ้าเข้าสู่ระบบแล้วแต่พยายามกลับไปหน้า login อีก → ส่งกลับหน้าแรก
  else if ((to.path === "/login" && isCustomerLoggedIn) || (to.path === "/admin-login" && isAdminLoggedIn)) {
    next("/");
  } 
  // อื่น ๆ ไปต่อได้ตามปกติ
  else {
    next();
  }
});

export default router;