import { createApp } from 'vue'
import { reactive } from '@vue/reactivity';
import App from './App.vue'
import router from './router'

window.currentAddress = null

window.web3Instance = null

window.store = reactive({});

createApp(App).use(router).mount('#app')