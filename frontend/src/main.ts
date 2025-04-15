import './assets/main.css';

import { createApp } from 'vue';

import PrimeVue from 'primevue/config';
import { Ripple, ToastService } from 'primevue';

import App from '@/App.vue';
import router from '@/router';

import theme from '@/theme';

const app = createApp(App);

app.use(PrimeVue, theme);
app.directive('ripple', Ripple);
app.use(ToastService);

app.use(router);

app.mount('#app');
