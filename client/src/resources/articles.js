import { apiClient, apiURL } from '@/utils/apiClient'
import { PER_PAGE } from "@/utils/constants";

const v = 'v1'
const res = 'articles'

// main
export const index = () => apiClient.get(apiURL(v, res))

export const show = (id) => apiClient.get(apiURL(v, res, id))

// neasted

// sites articles
const nRes = 'sites'

export const siteArticles = (siteId, page) => apiClient.get(apiURL(v, nRes, siteId, res),{
  params: {
    page,
    per_page: PER_PAGE
  }
})
