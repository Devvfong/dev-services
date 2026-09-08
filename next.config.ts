import type { NextConfig } from 'next'

const repo = 'dev-services'

const nextConfig: NextConfig = {
  output: 'export',
  basePath: `/${repo}`,
  assetPrefix: `/${repo}/`,
  trailingSlash: true,
  reactStrictMode: false,
}

export default nextConfig
