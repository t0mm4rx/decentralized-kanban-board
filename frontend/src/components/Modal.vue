<template>
	<div
	v-if="open"
	class="modal-container"
	@click="(e) => e.target.classList.contains('modal-container') && onClose()">
		<div class="modal-body" :style="style">
			<slot></slot>
		</div>
	</div>
</template>

<script>
export default {
	props: ["open", "onClose", "style"]
}
</script>


<style lang="scss" scoped>
.modal-container {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	backdrop-filter: blur(3px);
	display: flex;
	align-items: center;
	justify-content: center;
}

.modal-body {
	box-shadow: rgba(100, 100, 111, 0.2) 0px 7px 29px 0px;
	padding: 40px;
	box-sizing: border-box;
	background-color: white;
	border-radius: 10px;
}
</style>