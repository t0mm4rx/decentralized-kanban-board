<template>
<div v-if="open" class="overlay-container">
	<slot></slot>
</div>	
</template>

<script>
export default {
	props: ["open"]
}
</script>

<style lang="scss" scoped>
.overlay-container {
	z-index: 3;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	backdrop-filter: blur(3px);
	background-color: rgba(255, 255, 255, 0.3);
	display: flex;
	align-items: center;
	justify-content: center;
}
</style>