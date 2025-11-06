<template>
  <div class="login-container">
    <div class="login-box">
      <h2 class="text-center mb-4 text-purple">MEMBER LOGIN</h2>
      <form @submit.prevent="handleLogin">
        
        <div class="form-floating mb-3">
          <input
            type="text"
            class="form-control"
            id="username"
            placeholder="Username"
            v-model="username"
            required
          />
          <label for="username">Username</label>
        </div>
        
        <div class="form-floating mb-3">
          <input
            type="password"
            class="form-control"
            id="password"
            placeholder="Password"
            v-model="password"
            required
          />
          <label for="password">Password</label>
        </div>

        <div v-if="error" class="alert alert-danger">{{ error }}</div>

        <button class="btn btn-purple w-100 btn-lg" type="submit" :disabled="loading">
          <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>
          {{ loading ? 'Loading...' : 'Login' }}
        </button>
            <p class="text-center mt-3">
          New user?
          <router-link to="/register">Create an account</router-link>
        </p>
      </form>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

export default {
  name: 'CustomerLogin',
  setup() {
    const username = ref('');
    const password = ref('');
    const error = ref(null);
    const loading = ref(false);
    const router = useRouter();

    const handleLogin = async () => {
      loading.value = true;
      error.value = null;
      try {
        const response = await axios.post(
          'http://localhost:8081/finalproject/php_api/customer_login.php', // (สมมติ API ชื่อนี้)
          {
            username: username.value,
            password: password.value,
          }
        );

        if (response.data.success) {
          // บันทึกสถานะล็อกอินของ "ลูกค้า"
          localStorage.setItem('customerLogin', 'true');
          localStorage.setItem('customer_username', response.data.username); 
          
          // ส่งกลับไปหน้าแรก (หน้าซื้อของ)
          router.push('/');
        } else {
          error.value = response.data.message || 'Username หรือ Password ไม่ถูกต้อง';
        }
      } catch (err) {
        error.value = 'เกิดข้อผิดพลาดในการเชื่อมต่อ: ' + err.message;
      } finally {
        loading.value = false;
      }
    };

    return { username, password, error, loading, handleLogin };
  },
};
</script>

<style scoped>
:root {
  --primary-purple: #9d4edd;
  --dark-bg: #121212;
  --card-bg: #1e1e1e;
  --text-light: #f4f4f4;
  --border-color: #333;
}
.login-container {
  display: flex;
  align-items: center;
  justify-content: center;
  padding-top: 5rem;
}
.login-box {
  background-color: var(--card-bg, #1e1e1e);
  padding: 2.5rem;
  border-radius: 15px;
  width: 100%;
  max-width: 450px;
  border: 1px solid var(--border-color, #333);
  box-shadow: 0 8px 20px rgba(157, 78, 221, 0.2);
}
.text-purple {
  color: var(--primary-purple, #9d4edd);
}
.form-control {
  background-color: var(--dark-bg, #121212);
  color: var(--text-light, #f4f4f4);
  border-color: var(--border-color, #333);
}
.form-control:focus {
  background-color: var(--dark-bg, #121212);
  color: var(--text-light, #f4f4f4);
  border-color: var(--primary-purple, #9d4edd);
  box-shadow: 0 0 0 0.25rem rgba(157, 78, 221, 0.25);
}
.form-floating > label {
  color: #888;
}
.btn-purple {
  background-color: var(--primary-purple, #9d4edd);
  color: #fff;
  border: none;
  padding: 0.75rem;
  font-weight: bold;
}
.btn-purple:hover {
  background-color: var(--primary-purple-hover, #c77dff);
}
</style>