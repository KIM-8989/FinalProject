<template>
  <nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
      <a class="navbar-brand fw-bold" href="/">SPUC GAMING-GEAR</a>
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
            <li class="nav-item">
              <router-link class="nav-link" to="/orders">Orders</router-link>
            </li>
            <li class="nav-item">
              <router-link class="nav-link" to="/show_orders"
                >Orders Detail</router-link
              >
            </li>
            <li class="nav-item">
              <router-link class="nav-link" to="/product_edit"
                >Add Product</router-link
              >
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/report">Report</a>
            </li>
            <li class="nav-item">
              <a class="nav-link text-danger" href="#" @click="logout"
                >Logout (Admin)</a
              >
            </li>
          </template>

          <template v-else-if="isCustomerLoggedIn">
             <li class="nav-item">
              <router-link class="nav-link" to="/" exact-active-class="router-link-active">Menu</router-link>
            </li>
            <li class="nav-item">
              <a class="nav-link text-warning" href="#" @click="customerLogout"
                >Logout (Customer)</a
              >
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

  <div class="main-content">
    <router-view />
  </div>
</template>

<script>
export default {
  name: "App",
  data() {
    return {
      isLoggedIn: false, // สำหรับ Admin
      isCustomerLoggedIn: false, // ✨ สำหรับ Customer
    };
  },
  mounted() {
    this.checkLogin();
  },
  methods: {
    // ✨ ตรวจสอบการ Login ทั้ง 2 สถานะ
    checkLogin() {
      this.isLoggedIn = localStorage.getItem("adminLogin") === "true";
      this.isCustomerLoggedIn = localStorage.getItem("customerLogin") === "true";
    },
    
    // Logout ของ Admin
    logout() {
      if (confirm("ต้องการออกจากระบบ (Admin) หรือไม่?")) {
        localStorage.removeItem("adminLogin");
        localStorage.removeItem("username");
        localStorage.removeItem("token");
        this.isLoggedIn = false;
        this.$router.push("/");
      }
    },

    // ✨ Logout ของ Customer (สร้างใหม่)
    customerLogout() {
       if (confirm("ต้องการออกจากระบบ (Customer) หรือไม่?")) {
        localStorage.removeItem("customerLogin");
        localStorage.removeItem("customer_username"); 
        this.isCustomerLoggedIn = false;
        this.$router.push("/"); // กลับหน้าแรก
      }
    }
  },
  watch: {
    // ✨ เมื่อเปลี่ยนหน้า, ตรวจสอบสถานะ Login ใหม่เสมอ
    $route() {
      this.checkLogin();
    },
  },
};
</script>

<style scoped>

/* (CSS ทั้งหมดเหมือนเดิม) */
:root {
  --primary-purple: #9d4edd;
  --primary-purple-hover: #c77dff;
  /* --dark-bg: #121212; */
  --card-bg: #1e1e1e; 
  --text-light: #f4f4f4;
  --cyber-red: #e02a6f; 
  --border-color: #333;
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
</style>
<!-- <style>
/* ✨ (แท็ก style นี้ "ไม่มี" คำว่า scoped) ✨ */

/* * นี่คือการบอกให้ <body> (ทั้งหน้าเว็บ) 
 * ใช้สีพื้นหลังสีดำ/เทาเข้ม ที่เราต้องการ
 */
body {
  background-color: #ffffff; /* ✨ นี่คือสี --dark-bg ของเรา */
}
</style> -->