<template>
  <div class="register-container">
    <div class="register-box">
      <h2 class="text-center mb-4 text-purple">CREATE ACCOUNT</h2>
      
      <form @submit.prevent="handleRegister">
        
        <div class="form-floating mb-3">
          <input
            type="text"
            class="form-control"
            id="full_name"
            placeholder="Full Name"
            v-model="full_name"
            required
          />
          <label for="full_name">Full Name (ชื่อ-นามสกุล)</label>
        </div>

        <div class="form-floating mb-3">
          <input
            type="email"
            class="form-control"
            id="email"
            placeholder="Email"
            v-model="email"
            required
          />
          <label for="email">Email</label>
        </div>

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
        <div v-if="success" class="alert alert-success">{{ success }}</div>

        <button class="btn btn-purple w-100 btn-lg" type="submit" :disabled="loading">
          <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>
          {{ loading ? 'Registering...' : 'Register' }}
        </button>
        
        <p class="text-center mt-3">
          Already have an account?
          <router-link to="/login">Login here</router-link>
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
  name: 'CustomerRegister',
  setup() {
    const full_name = ref('');
    const email = ref('');
    const username = ref('');
    const password = ref('');
    const error = ref(null);
    const success = ref(null);
    const loading = ref(false);
    const router = useRouter();

    const handleRegister = async () => {
      loading.value = true;
      error.value = null;
      success.value = null;

      try {
        const response = await axios.post(
          'http://localhost:8081/MK_SHOP/php_api/customer_register.php',
          {
            full_name: full_name.value,
            email: email.value,
            username: username.value,
            password: password.value,
          }
        );

        if (response.data.success) {
          success.value = "สมัครสมาชิกสำเร็จ! กำลังไปหน้า Login...";
          setTimeout(() => {
            router.push('/login'); // ย้ายไปหน้า Login
          }, 2000);
        } else {
          error.value = response.data.message || 'การสมัครสมาชิกล้มเหลว';
        }
      } catch (err) {
        error.value = 'เกิดข้อผิดพลาดในการเชื่อมต่อ: ' + err.message;
      } finally {
        loading.value = false;
      }
    };

    return { full_name, email, username, password, error, success, loading, handleRegister };
  },
};
</script>

<style scoped>
/* (สไตล์เดียวกับหน้า Login) */
:root {
  --primary-purple: #9d4edd;
  --dark-bg: #121212;
  --card-bg: #1e1e1e;
  --text-light: #f4f4f4;
  --border-color: #333;
}

.register-container {
  display: flex;
  align-items: center;
  justify-content: center;
  padding-top: 3rem;
  padding-bottom: 3rem;
}
.register-box {
  background-color: var(--card-bg, #1e1e1e);
  padding: 2.5rem;
  border-radius: 15px;
  width: 100%;
  max-width: 500px;
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

/* สไตล์ลิงก์ */
p {
  color: #ccc;
}
a {
  color: var(--primary-purple, #9d4edd);
  text-decoration: none;
}
a:hover {
  text-decoration: underline;
}
</style>