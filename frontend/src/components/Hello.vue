<template>
  <div>
    <h1>{{ message }}</h1>
    <button @click="fetchMessage">Fetch Message</button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      message: ''
    }
  },
  methods: {
    async fetchMessage() {
      try {
        const response = await fetch('<API_URL_PLACEHOLDER>')
        const data = await response.json()
        this.message = data.message
      } catch (error) {
        console.error('Error fetching message:', error)
      }
    }
  }
}
</script>
