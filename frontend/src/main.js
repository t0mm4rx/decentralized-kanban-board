import { createApp } from 'vue'
import { reactive } from '@vue/reactivity';
import App from './App.vue'
import router from './router'

window.currentAddress = "0x78b028bB62f8C500d5A4aB3Fd957027E8dfd0974"

window.web3Instance = null

window.store = reactive({});

createApp(App).use(router).mount('#app')