import Vue from 'vue'
import App from '../app.vue'

document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById("app")
  const props = JSON.parse(element.getAttribute('data'))
  const app = new Vue({
    el: '#app',
    render: h => h(App,{props})
  })

  console.log(app)
})
