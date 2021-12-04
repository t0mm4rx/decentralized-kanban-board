import { createApp } from 'vue'
import { reactive } from '@vue/reactivity';
import App from './App.vue'
import router from './router'
import Toaster from "@meforma/vue-toaster"

window.store = reactive({});

createApp(App).use(router).use(Toaster).mount('#app')