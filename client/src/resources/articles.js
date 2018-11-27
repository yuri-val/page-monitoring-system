import {
  apiClient,
  apiURL
} from '@/utils/apiClient'

const v = 'v1'
const res = 'articles'

// main
export const index = () => apiClient.get(apiURL(v, res))

export const show = (id) => apiClient.get(apiURL(v, res, id))

// neasted

// sites articles
const nRes = 'sites'

export const siteArticles = (siteId) => apiClient.get(apiURL(v, nRes, siteId, res))
