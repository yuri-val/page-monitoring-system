import {
  apiClient,
  apiURL
} from '@/utils/apiClient'

const v = 'v1'
const res = 'sites'

export const index = () => apiClient.get(apiURL(v, res))

export const show = (id) => apiClient.get(apiURL(v, res, id))
