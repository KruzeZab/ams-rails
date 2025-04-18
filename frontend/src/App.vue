<script setup lang="ts">
import { provideCurrentUser } from '@/injectors/currentUser';

import Header from '@/components/header/Header.vue';
import Footer from '@/components/footer/Footer.vue';

provideCurrentUser();
</script>

<template>
  <Header />
  <Toast />
  <main class="min-h-[calc(100vh_-_145px)]">
    <RouterView />
  </main>
  <Footer />
</template>
