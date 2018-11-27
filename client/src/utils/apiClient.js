import axios from 'axios'

export const apiURL = (...args) => args.join('/')

export const apiClient = axios.create({
  baseURL: 'http://localhost:3000/'
})
