import {
  apiClient,
  apiURL
} from '@/utils/apiClient'

const v = 'v1'
const res = 'versions'

// main
export const index = () => apiClient.get(apiURL(v, res))

export const show = (id) => apiClient.get(apiURL(v, res, id))

export const text = (id, type) => apiClient.get(apiURL(v, res, id, type))

export const compare = (id, anotherId) => (
  apiClient.get(apiURL(v, res, id, 'diff', anotherId), {
    params: {
      format: 'html',
      type: 'html',
      diff_by: 'char'
    }
  })
)

// neasted

// sites articles
const nRes = 'articles'

export const articleVersions = (articleId) => apiClient.get(apiURL(v, nRes, articleId, res))
